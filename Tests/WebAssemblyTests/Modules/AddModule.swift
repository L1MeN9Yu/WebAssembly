import Foundation
import WebAssembly

public struct AddModule {
    private let _vm: Interpreter

    init() throws {
        _vm = try Interpreter(module: AddModule.wasm)
    }

    func add(_ first: Int, _ second: Int) throws -> Int {
        Int(try _vm.call("add", Int32(first), Int32(second)) as Int32)
    }

    // `wat2wasm -o >(base64) Tests/WasmInterpreterTests/Resources/add.wat | pbcopy`
    private static var wasm: [UInt8] {
        let base64 = "AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABags="
        return [UInt8](Data(base64Encoded: base64)!)
    }
}
