//
// Created by Mengyu Li on 2021/8/20.
//

extension UnsafeMutableRawPointer {
    init<T>(_ value: T) {
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<T>.size, alignment: MemoryLayout<T>.alignment)
        pointer.storeBytes(of: value, as: T.self)
        self = pointer
    }
}
