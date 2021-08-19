//
// Created by Mengyu Li on 2021/8/19.
//

extension Int64: Primitive {}

extension Primitive {
    var int64: Int64? {
        switch self {
        case is Int64:
            return self as? Int64
        default:
            return nil
        }
    }
}
