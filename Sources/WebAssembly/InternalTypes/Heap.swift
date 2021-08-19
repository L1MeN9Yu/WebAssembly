//
// Created by Mengyu Li on 2021/8/19.
//

struct Heap {
    let pointer: UnsafeMutablePointer<UInt8>
    let size: Int

    init(pointer: UnsafeMutablePointer<UInt8>, size: Int) {
        self.pointer = pointer
        self.size = size
    }
}

extension Heap {
    func isValid(byteOffset: Int, length: Int) -> Bool {
        (byteOffset + length) <= size
    }
}
