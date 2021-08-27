//
// Created by Mengyu Li on 2021/8/27.
//

import struct Foundation.Data
import WebAssembly

struct GlobalModule {
    private let _vm: Interpreter

    init() throws {
        _vm = try Interpreter(module: GlobalModule.wasm)
    }

    private static var wasm: [UInt8] {
        let base64 = "AGFzbQEAAAABBAFgAAADAgEABQMBABEGIQR/AUGAgMAAC38AQYSAwAALfwBBiIDAAAt/AEGIgMAACwczBQZtZW1vcnkCAAV3cml0ZQAAA1JBVwMBCl9fZGF0YV9lbmQDAgtfX2hlYXBfYmFzZQMDCjEBLwEBf0EAIQADQEEAKAKEgEAgAGogAEGAgMAAai0AADoAACAAQQFqIgBBA0cNAAsLCxgCAEGAgMAACwNhYmMAQYSAwAALBEgAAAA="
        return [UInt8](Data(base64Encoded: base64)!)
    }
}

extension GlobalModule {
    func run() throws {
        try _vm.globalValue(name: "RAW")
        try _vm.call("write")
        try _vm.globalValue(name: "RAW")
    }
}