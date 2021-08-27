//
// Created by Mengyu Li on 2021/8/19.
//

public enum WebAssemblyError: Error {
    case couldNotLoadEnvironment
    case couldNotLoadRuntime
    case couldNotLoadWasmBinary(String)
    case couldNotParseModule
    case couldNotLoadModule
    case couldNotFindFunction(String)
    case globalNotFound(String)
    case onCallFunction(String)
    case invalidFunctionReturnType
    case invalidStackPointer
    case invalidMemoryAccess
    case invalidUTF8String
    case couldNotGenerateFunctionContext
    case incorrectArguments
    case missingHeap
    case couldNotLoadMemory
    case couldNotBindMemory
    case unsupportedPrimitive(String)
    case wasm3Error(String)
}
