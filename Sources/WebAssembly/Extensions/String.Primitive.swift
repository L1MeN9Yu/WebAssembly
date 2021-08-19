//
// Created by Mengyu Li on 2021/8/19.
//

import Foundation

extension String {
    init<T: Primitive>(primitive: T) throws {
        switch primitive {
        case is Int32:
            guard let value = primitive.int32 else {
                throw WebAssemblyError.unsupportedPrimitive(String(describing: primitive.self))
            }
            self = "\(value)"
        case is Int64:
            guard let value = primitive.int64 else {
                throw WebAssemblyError.unsupportedPrimitive(String(describing: primitive.self))
            }
            self = "\(value)"
        case is Float32:
            guard let value = primitive.float32 else {
                throw WebAssemblyError.unsupportedPrimitive(String(describing: primitive.self))
            }
            self = "\(value)"
        case is Float64:
            guard let value = primitive.float64 else {
                throw WebAssemblyError.unsupportedPrimitive(String(describing: primitive.self))
            }
            self = "\(value)"
        default:
            throw WebAssemblyError.unsupportedPrimitive(String(describing: primitive.self))
        }
    }
}
