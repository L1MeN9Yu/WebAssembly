//
// Created by Mengyu Li on 2021/8/27.
//

import CWasm3

public extension Interpreter {
    func globalValue(name: String) throws {
        let global = try global(name: name)
        let taggedValue = IM3TaggedValue.allocate(capacity: MemoryLayout<M3TaggedValue>.stride)
        defer { taggedValue.deallocate() }
        try Self.execute(m3_GetGlobal(global, taggedValue))
        print("\(taggedValue.pointee.value.i32)")
        let valueOffset = taggedValue.pointee.value.i32
        let value = try stringFromHeap(byteOffset: Int(valueOffset), length: 3)
        print("\(value)")
    }
}

private extension Interpreter {
    func global(name: String) throws -> IM3Global {
        guard let global: IM3Global = m3_FindGlobal(module, name) else {
            throw WebAssemblyError.globalNotFound(name)
        }
        return global
    }
}
