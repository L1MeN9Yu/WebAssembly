//
// Created by Mengyu Li on 2021/8/19.
//

extension Float64: Primitive {}

extension Primitive {
    var float64: Float64? {
        switch self {
        case is Float64:
            return self as? Float64
        default:
            return nil
        }
    }
}
