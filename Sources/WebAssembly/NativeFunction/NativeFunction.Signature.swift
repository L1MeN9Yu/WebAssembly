//
// Created by Mengyu Li on 2021/8/19.
//

private extension NativeFunction {
    static func identifier<T: Primitive>(for type: T.Type) throws -> String {
        switch type {
        case is Int32.Type:
            return "i"
        case is Int64.Type:
            return "I"
        case is Float32.Type:
            return "f"
        case is Float64.Type:
            return "F"
        default:
            throw WebAssemblyError.unsupportedPrimitive(String(describing: T.self))
        }
    }
}

extension NativeFunction {
    static func signature() throws -> String { "v()" }

    static func signature<Arg1>(arg1: Arg1.Type) throws -> String where Arg1: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self)
        signature += ")"
        return signature
    }

    static func signature<Ret>(ret: Ret.Type) throws -> String where Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += ")"
        return signature
    }

    static func signature<Arg1, Ret>(arg1: Arg1.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2>(arg1: Arg1.Type, arg2: Arg2.Type) throws -> String where Arg1: Primitive, Arg2: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type, arg7: Arg7.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self) + " "
        signature += try identifier(for: arg7.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type, arg7: Arg7.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self) + " "
        signature += try identifier(for: arg7.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type, arg7: Arg7.Type, arg8: Arg8.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive {
        var signature = "v"
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self) + " "
        signature += try identifier(for: arg7.self) + " "
        signature += try identifier(for: arg8.self)
        signature += ")"
        return signature
    }

    static func signature<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Ret>(arg1: Arg1.Type, arg2: Arg2.Type, arg3: Arg3.Type, arg4: Arg4.Type, arg5: Arg5.Type, arg6: Arg6.Type, arg7: Arg7.Type, arg8: Arg8.Type, ret: Ret.Type) throws -> String where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive, Ret: Primitive {
        var signature = ""
        signature += try identifier(for: ret.self)
        signature += "("
        signature += try identifier(for: arg1.self) + " "
        signature += try identifier(for: arg2.self) + " "
        signature += try identifier(for: arg3.self) + " "
        signature += try identifier(for: arg4.self) + " "
        signature += try identifier(for: arg5.self) + " "
        signature += try identifier(for: arg6.self) + " "
        signature += try identifier(for: arg7.self) + " "
        signature += try identifier(for: arg8.self)
        signature += ")"
        return signature
    }
}
