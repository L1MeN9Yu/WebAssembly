//
// Created by Mengyu Li on 2021/8/20.
//

import CWasm3

enum Validator {}

extension Validator {
    static func isValidWasmPrimitive<T: Primitive>(_ type: T.Type) -> Bool {
        switch type {
        case is Int32.Type, is Int64.Type, is Float32.Type, is Float64.Type:
            return true
        default:
            return false
        }
    }
}
