//
// Created by Mengyu Li on 2021/8/19.
//

import CWasm3

// Arguments and return values are passed in and out through the stack pointer
// of imported functions.
//
// Placeholder return value slots are first and arguments after. So, the first
// argument is at _sp [numReturns].
//
// Return values should be written into _sp [0] to _sp [num_returns - 1].
//
// Wasm3 always aligns the stack to 64 bits.

public extension Interpreter {
    func addImportHandler(name: String, namespace: String, block: @escaping () throws -> Void) throws {
        let importedFunction: ImportedFunctionSignature = { (_: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                try block()
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature()
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler(name: String, namespace: String, block: @escaping (UnsafeMutableRawPointer?) throws -> Void) throws {
        let importedFunction: ImportedFunctionSignature = { (_: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                try block(heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature()
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Ret>(name: String, namespace: String, block: @escaping () throws -> Ret) throws where Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let ret = try block()
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Ret>(name: String, namespace: String, block: @escaping (UnsafeMutableRawPointer?) throws -> Ret) throws where Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let ret = try block(heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1>(name: String, namespace: String, block: @escaping (Arg1) throws -> Void) throws where Arg1: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                try block(arg1)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1>(name: String, namespace: String, block: @escaping (Arg1, UnsafeMutableRawPointer?) throws -> Void) throws where Arg1: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                try block(arg1, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Ret>(name: String, namespace: String, block: @escaping (Arg1) throws -> Ret) throws where Arg1: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let ret = try block(arg1)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Ret>(name: String, namespace: String, block: @escaping (Arg1, UnsafeMutableRawPointer?) throws -> Ret) throws where Arg1: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let ret = try block(arg1, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2>(name: String, namespace: String, block: @escaping (Arg1, Arg2) throws -> Void) throws where Arg1: Primitive, Arg2: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                try block(arg1, arg2)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2>(name: String, namespace: String, block: @escaping (Arg1, Arg2, UnsafeMutableRawPointer?) throws -> Void) throws where Arg1: Primitive, Arg2: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                try block(arg1, arg2, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2) throws -> Ret) throws where Arg1: Primitive, Arg2: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let ret = try block(arg1, arg2)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, UnsafeMutableRawPointer?) throws -> Ret) throws where Arg1: Primitive, Arg2: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let ret = try block(arg1, arg2, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3) throws -> Void) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                try block(arg1, arg2, arg3)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, UnsafeMutableRawPointer?) throws -> Void) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                try block(arg1, arg2, arg3, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3) throws -> Ret) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let ret = try block(arg1, arg2, arg3)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, UnsafeMutableRawPointer?) throws -> Ret) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let ret = try block(arg1, arg2, arg3, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                try block(arg1, arg2, arg3, arg4)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, UnsafeMutableRawPointer?) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                try block(arg1, arg2, arg3, arg4, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let ret = try block(arg1, arg2, arg3, arg4)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, UnsafeMutableRawPointer?) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let ret = try block(arg1, arg2, arg3, arg4, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                try block(arg1, arg2, arg3, arg4, arg5)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, UnsafeMutableRawPointer?) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                try block(arg1, arg2, arg3, arg4, arg5, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let ret = try block(arg1, arg2, arg3, arg4, arg5)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, UnsafeMutableRawPointer?) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                try block(arg1, arg2, arg3, arg4, arg5, arg6)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, UnsafeMutableRawPointer?) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                try block(arg1, arg2, arg3, arg4, arg5, arg6, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, UnsafeMutableRawPointer?) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 6)
                try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, UnsafeMutableRawPointer?) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 6)
                try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 7)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, UnsafeMutableRawPointer?) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 7)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 6)
                let arg8: Arg8 = try NativeFunction.argument(from: stack, at: 7)
                try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, arg8: Arg8.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, UnsafeMutableRawPointer?) throws -> Void) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 0)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 1)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 2)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 3)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 4)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 5)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 6)
                let arg8: Arg8 = try NativeFunction.argument(from: stack, at: 7)
                try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, heap)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, arg8: Arg8.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8) throws -> Ret) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, _: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 7)
                let arg8: Arg8 = try NativeFunction.argument(from: stack, at: 8)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, arg8: Arg8.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }

    func addImportHandler<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Ret>(name: String, namespace: String, block: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, UnsafeMutableRawPointer?) throws -> Ret) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive, Ret: Primitive {
        let importedFunction: ImportedFunctionSignature = { (stack: UnsafeMutablePointer<UInt64>?, heap: UnsafeMutableRawPointer?) -> UnsafeRawPointer? in
            do {
                let arg1: Arg1 = try NativeFunction.argument(from: stack, at: 1)
                let arg2: Arg2 = try NativeFunction.argument(from: stack, at: 2)
                let arg3: Arg3 = try NativeFunction.argument(from: stack, at: 3)
                let arg4: Arg4 = try NativeFunction.argument(from: stack, at: 4)
                let arg5: Arg5 = try NativeFunction.argument(from: stack, at: 5)
                let arg6: Arg6 = try NativeFunction.argument(from: stack, at: 6)
                let arg7: Arg7 = try NativeFunction.argument(from: stack, at: 7)
                let arg8: Arg8 = try NativeFunction.argument(from: stack, at: 8)
                let ret = try block(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, heap)
                try NativeFunction.pushReturnValue(ret, to: stack)
                return nil
            } catch {
                return NativeFunction.importedFunctionInternalErrorPointer
            }
        }
        let signature = try NativeFunction.signature(arg1: Arg1.self, arg2: Arg2.self, arg3: Arg3.self, arg4: Arg4.self, arg5: Arg5.self, arg6: Arg6.self, arg7: Arg7.self, arg8: Arg8.self, ret: Ret.self)
        try importNativeFunction(name: name, namespace: namespace, signature: signature, handler: importedFunction)
    }
}
