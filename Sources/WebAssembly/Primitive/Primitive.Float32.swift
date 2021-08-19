//
// Created by Mengyu Li on 2021/8/19.
//

extension Float32: Primitive {}

extension Primitive {
    var float32: Float32? {
        switch self {
        case is Float32:
            return self as? Float32
        default:
            return nil
        }
    }
}
