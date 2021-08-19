//
// Created by Mengyu Li on 2021/8/19.
//

extension Int32: Primitive {}

extension Primitive {
    var int32: Int32? {
        switch self {
        case is Int32:
            return self as? Int32
        default:
            return nil
        }
    }
}
