//
// Created by Mengyu Li on 2021/8/19.
//

import CWasm3

enum NativeFunction {}

private extension NativeFunction {
    static let argumentStride = MemoryLayout<Int64>.stride
}

extension NativeFunction {
    static func argument<Arg: Primitive>(from stack: UnsafeMutablePointer<UInt64>?, at index: Int) throws -> Arg {
        guard let stack = UnsafeMutableRawPointer(stack) else {
            throw WebAssemblyError.invalidStackPointer
        }

        guard Validator.isValidWasmPrimitive(Arg.self) else {
            throw WebAssemblyError.unsupportedPrimitive(String(describing: Arg.self))
        }

        return stack.load(fromByteOffset: index * argumentStride, as: Arg.self)
    }

    /// Extracts the imported function's arguments of the specified types from the stack.
    ///
    /// - Throws: Throws if the stack pointer is `nil`.
    ///
    /// - Parameters:
    ///   - types: The expected argument types.
    ///   - stack: The stack pointer.
    ///
    /// - Returns: Array of the imported function's arguments.
    static func arguments(withTypes types: [PrimitiveType], from stack: UnsafeMutablePointer<UInt64>?) throws -> [PrimitiveValue] {
        guard let stack = UnsafeMutableRawPointer(stack) else {
            throw WebAssemblyError.invalidStackPointer
        }

        let values: [PrimitiveValue] = types.enumerated().map { (offset: Int, type: PrimitiveType) -> PrimitiveValue in
            switch type {
            case .int32:
                let value = stack.load(fromByteOffset: offset * argumentStride, as: Int32.self)
                return .int32(value)
            case .int64:
                let value = stack.load(fromByteOffset: offset * argumentStride, as: Int64.self)
                return .int64(value)
            case .float32:
                let value = stack.load(fromByteOffset: offset * argumentStride, as: Float32.self)
                return .float32(value)
            case .float64:
                let value = stack.load(fromByteOffset: offset * argumentStride, as: Float64.self)
                return .float64(value)
            }
        }
        return values
    }

    /// Places the specified return value on the stack.
    ///
    /// - Throws: Throws if the stack pointer is `nil` or if `Ret` is not of type
    /// `Int32`, `Int64`, `Float32`, or `Float64`.
    ///
    /// - Parameters:
    ///   - ret: The value to return from the imported function.
    ///   - stack: The stack pointer.
    static func pushReturnValue<Ret: Primitive>(_ ret: Ret, to stack: UnsafeMutablePointer<UInt64>?) throws {
        guard let stack = UnsafeMutableRawPointer(stack) else {
            throw WebAssemblyError.invalidStackPointer
        }

        guard Validator.isValidWasmPrimitive(Ret.self) else {
            throw WebAssemblyError.unsupportedPrimitive(String(describing: Ret.self))
        }

        stack.storeBytes(of: ret, as: Ret.self)
    }

    /// Places the specified return value on the stack.
    ///
    /// - Throws: Throws if the stack pointer is `nil`.
    ///
    /// - Parameters:
    ///   - ret: The value to return from the imported function.
    ///   - stack: The stack pointer.
    static func pushReturnValue(_ ret: PrimitiveValue, to stack: UnsafeMutablePointer<UInt64>?) throws {
        guard let stack = UnsafeMutableRawPointer(stack) else { throw WebAssemblyError.invalidStackPointer }

        switch ret {
        case .int32(let value):
            stack.storeBytes(of: value, as: Int32.self)
        case .int64(let value):
            stack.storeBytes(of: value, as: Int64.self)
        case .float32(let value):
            stack.storeBytes(of: value, as: Float32.self)
        case .float64(let value):
            stack.storeBytes(of: value, as: Float64.self)
        }
    }
}

extension NativeFunction {
    private static let importedFunctionInternalError = "ImportedFunctionInternalError".utf8CString
    static let importedFunctionInternalErrorPointer = UnsafeRawPointer(
        UnsafeMutableRawPointer.allocate(
            byteCount: importedFunctionInternalError.count,
            alignment: MemoryLayout<CChar>.alignment
        ))
}
