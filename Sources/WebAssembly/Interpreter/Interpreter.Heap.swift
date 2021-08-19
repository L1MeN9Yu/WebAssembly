//
// Created by Mengyu Li on 2021/8/20.
//

import CWasm3
import struct Foundation.Data

public extension Interpreter {
    func stringFromHeap(byteOffset: Int, length: Int) throws -> String {
        let data = try dataFromHeap(byteOffset: byteOffset, length: length)

        guard let string = String(data: data, encoding: .utf8) else {
            throw WebAssemblyError.invalidUTF8String
        }

        return string
    }

    func valueFromHeap<T: Primitive>(byteOffset: Int) throws -> T {
        let values: [T] = try valuesFromHeap(byteOffset: byteOffset, length: 1)
        guard let value = values.first else {
            throw WebAssemblyError.couldNotLoadMemory
        }
        return value
    }

    func valuesFromHeap<T: Primitive>(byteOffset: Int, length: Int) throws -> [T] {
        let heap = try heap()

        guard heap.isValid(byteOffset: byteOffset, length: length) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        let ptr = UnsafeRawPointer(heap.pointer).advanced(by: byteOffset).bindMemory(to: T.self, capacity: length)

        return (0..<length).map { ptr[$0] }
    }

    func dataFromHeap(byteOffset: Int, length: Int) throws -> Data {
        let heap = try heap()

        guard heap.isValid(byteOffset: byteOffset, length: length) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        return Data(bytes: heap.pointer.advanced(by: byteOffset), count: length)
    }

    func bytesFromHeap(byteOffset: Int, length: Int) throws -> [UInt8] {
        let heap = try heap()

        guard heap.isValid(byteOffset: byteOffset, length: length) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        let bufferPointer = UnsafeBufferPointer(start: heap.pointer.advanced(by: byteOffset), count: length)

        return Array(bufferPointer)
    }

    func writeToHeap(string: String, byteOffset: Int) throws {
        try writeToHeap(data: Data(string.utf8), byteOffset: byteOffset)
    }

    func writeToHeap<T: Primitive>(value: T, byteOffset: Int) throws {
        try writeToHeap(values: [value], byteOffset: byteOffset)
    }

    func writeToHeap<T: Primitive>(values: [T], byteOffset: Int) throws {
        var values = values
        try writeToHeap(data: Data(bytes: &values, count: values.count * MemoryLayout<T>.size), byteOffset: byteOffset)
    }

    func writeToHeap(data: Data, byteOffset: Int) throws {
        let heap = try heap()

        guard heap.isValid(byteOffset: byteOffset, length: data.count) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        try data.withUnsafeBytes { (rawPointer: UnsafeRawBufferPointer) -> Void in
            guard let pointer = rawPointer.bindMemory(to: UInt8.self).baseAddress else {
                throw WebAssemblyError.couldNotBindMemory
            }
            heap.pointer.advanced(by: byteOffset).initialize(from: pointer, count: data.count)
        }
    }

    func writeToHeap(bytes: [UInt8], byteOffset: Int) throws {
        let heap = try heap()

        guard heap.isValid(byteOffset: byteOffset, length: bytes.count) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        heap.pointer.advanced(by: byteOffset).initialize(from: bytes, count: bytes.count)
    }
}

private extension Interpreter {
    func heap() throws -> Heap {
        let totalBytes = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        defer { totalBytes.deallocate() }

        guard let bytesPointer = m3_GetMemory(runtime, totalBytes, 0) else {
            throw WebAssemblyError.invalidMemoryAccess
        }

        return Heap(pointer: bytesPointer, size: Int(totalBytes.pointee))
    }
}
