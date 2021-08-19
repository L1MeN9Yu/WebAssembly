//
// Created by Mengyu Li on 2021/8/20.
//

import Locks

enum Atom {}

extension Atom {
    static let lock = Lock()
}

extension Atom {
    private static var id: UInt64 = 0

    static func retrieveID() -> (UInt64, UnsafeMutableRawPointer) {
        lock.withLock {
            id += 1
            let idPointer = UnsafeMutableRawPointer(id)
            return (id, idPointer)
        }
    }
}
