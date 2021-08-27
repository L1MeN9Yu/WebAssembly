//
// Created by Mengyu Li on 2021/8/19.
//

import CWasm3
import Locks

public final class Interpreter {
    let id: UInt64
    private let idPointer: UnsafeMutableRawPointer

    let environment: IM3Environment
    let runtime: IM3Runtime
    let module: IM3Module

    private let bytes: [UInt8]

    private let lock = Lock()

    private var functionCache = [String: IM3Function]()
    private var importedFunctionContexts = [UnsafeMutableRawPointer]()

    public init(stackSize: UInt32 = Interpreter.stackSize, module bytes: [UInt8]) throws {
        (id, idPointer) = Atom.retrieveID()

        guard let environment = m3_NewEnvironment() else {
            throw WebAssemblyError.couldNotLoadEnvironment
        }

        guard let runtime = m3_NewRuntime(environment, stackSize, idPointer) else {
            throw WebAssemblyError.couldNotLoadRuntime
        }

        var moduleInput: IM3Module?
        try Interpreter.execute(m3_ParseModule(environment, &moduleInput, bytes, UInt32(bytes.count)))

        guard let module = moduleInput else {
            throw WebAssemblyError.couldNotParseModule
        }

        try Interpreter.execute(m3_LoadModule(runtime, module))

        self.environment = environment
        self.runtime = runtime
        self.module = module
        self.bytes = bytes
    }

    deinit {
        m3_FreeRuntime(runtime)
        m3_FreeEnvironment(environment)
        ImportFunctionCache.removeImportedFunctions(forInstanceIdentifier: id)
        idPointer.deallocate()
    }
}

extension Interpreter {
    /// Imports the specified block into the module matching the supplied name. The
    /// imported block must be included in the compiled module as an `import`.
    ///
    /// The function's signature must conform to `wasm3`'s format, which matches the following
    /// form:
    ///
    /// ```c
    /// u8  ConvertTypeCharToTypeId (char i_code)
    /// {
    ///     switch (i_code) {
    ///     case 'v': return c_m3Type_void;
    ///     case 'i': return c_m3Type_i32;
    ///     case 'I': return c_m3Type_i64;
    ///     case 'f': return c_m3Type_f32;
    ///     case 'F': return c_m3Type_f64;
    ///     case '*': return c_m3Type_ptr;
    ///     }
    ///     return c_m3Type_none;
    /// }
    /// ```
    ///
    /// For example, a block taking two arguments of types `Int64` and `Float32` and
    /// no return value would have this signature: `v(I f)`
    ///
    /// - Throws: Throws if a module matching the given name can't be found or if the
    /// underlying `wasm3` function returns an error.
    ///
    /// - Parameters:
    ///   - name: The name of the function to import, matching the name specified inside the
    ///   WebAssembly module.
    ///   - namespace: The namespace of the function to import, matching the namespace
    ///   specified inside the WebAssembly module.
    ///   - signature: The signature of the function to import, conforming to `wasm3`'s guidelines
    ///   as outlined above.
    ///   - handler: The function to import into the specified WebAssembly module.
    func importNativeFunction(name: String, namespace: String, signature: String, handler: @escaping ImportedFunctionSignature) throws {
        guard let context = UnsafeMutableRawPointer(bitPattern: (namespace + name).hashValue) else {
            throw WebAssemblyError.couldNotGenerateFunctionContext
        }

        do {
            ImportFunctionCache.addImportedFunction(handler, for: context, instanceIdentifier: id)
            try Interpreter.execute(
                m3_LinkRawFunctionEx(
                    module,
                    namespace,
                    name,
                    signature,
                    { runtime, context, stackPointer, heap in
                        guard let id = m3_GetUserData(runtime)?.load(as: UInt64.self) else {
                            return UnsafeRawPointer(m3Err_trapUnreachable)
                        }

                        guard let userData = context?.pointee.userdata else {
                            return UnsafeRawPointer(m3Err_trapUnreachable)
                        }

                        guard let function = ImportFunctionCache.importedFunction(for: userData, instanceIdentifier: id) else {
                            return UnsafeRawPointer(m3Err_trapUnreachable)
                        }

                        return function(stackPointer, heap)
                    },
                    context
                )
            )
            lock.withLockVoid { importedFunctionContexts.append(context) }
        } catch {
            ImportFunctionCache.removeImportedFunction(for: context, instanceIdentifier: id)
            throw error
        }
    }
}

extension Interpreter {
    func function(named name: String) throws -> IM3Function {
        try lock.withLock { () throws -> IM3Function in
            switch functionCache[name] {
            case .none:
                var functionInput: IM3Function?
                try Interpreter.execute(m3_FindFunction(&functionInput, runtime, name))
                guard let function = functionInput else {
                    throw WebAssemblyError.couldNotFindFunction(name)
                }
                functionCache[name] = function
                return function
            case .some(let compiledFunction):
                return compiledFunction
            }
        }
    }

    func _call(_ function: IM3Function, args: [String]) throws {
        try args.withCStringList { cStrings throws -> Void in
            var mutableCStrings = cStrings
            let size = UnsafeMutablePointer<Int>.allocate(capacity: 1)
            let callResult = wasm3_CallWithArgs(function, UInt32(args.count), &mutableCStrings, size, nil)
            if let result = callResult {
                throw WebAssemblyError.onCallFunction(String(cString: result))
            } else if 0 != size.pointee {
                throw WebAssemblyError.invalidFunctionReturnType
            }

            return ()
        }
    }

    func _call<T: Primitive>(_ function: IM3Function, args: [String]) throws -> T {
        try args.withCStringList { cStrings throws -> T in
            var mutableCStrings = cStrings
            let size = UnsafeMutablePointer<Int>.allocate(capacity: 1)
            let output = UnsafeMutablePointer<T>.allocate(capacity: 1)
            let callResult = wasm3_CallWithArgs(function, UInt32(args.count), &mutableCStrings, size, output)
            if let result = callResult {
                throw WebAssemblyError.onCallFunction(String(cString: result))
            } else if MemoryLayout<T>.size != size.pointee {
                throw WebAssemblyError.invalidFunctionReturnType
            }

            return output.pointee
        }
    }
}

// MARK: - Static

extension Interpreter {
    static func execute(_ block: @autoclosure () throws -> M3Result?) throws {
        if let result = try block() {
            throw WebAssemblyError.wasm3Error(String(cString: result))
        }
    }
}

public extension Interpreter {
    static let stackSize: UInt32 = 512 * 1024
}
