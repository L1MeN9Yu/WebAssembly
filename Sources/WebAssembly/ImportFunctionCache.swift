//
// Created by Mengyu Li on 2021/8/19.
//

import CWasm3
import Locks

enum ImportFunctionCache {}

private extension ImportFunctionCache {
    static let lock = Atom.lock
    private static var importedFunctionCache = [UInt64: [UnsafeMutableRawPointer: ImportedFunctionSignature]]()
}

// MARK: - Managing imported functions

extension ImportFunctionCache {
    static func addImportedFunction(_ function: @escaping ImportedFunctionSignature, for context: UnsafeMutableRawPointer, instanceIdentifier id: UInt64) {
        lock.withLockVoid {
            switch importedFunctionCache[id] {
            case .none:
                let functionsForID = [context: function]
                importedFunctionCache[id] = functionsForID
            case .some(var functionsForID):
                functionsForID[context] = function
                importedFunctionCache[id] = functionsForID
            }
        }
    }

    static func removeImportedFunction(for context: UnsafeMutableRawPointer, instanceIdentifier id: UInt64) {
        lock.withLockVoid {
            guard var functionsForID = importedFunctionCache[id] else { return }
            functionsForID.removeValue(forKey: context)
            importedFunctionCache[id] = functionsForID
        }
    }

    static func removeImportedFunctions(forInstanceIdentifier id: UInt64) {
        lock.withLockVoid {
            _ = importedFunctionCache.removeValue(forKey: id)
        }
    }

    static func importedFunction(for userData: UnsafeMutableRawPointer?, instanceIdentifier id: UInt64) -> ImportedFunctionSignature? {
        guard let context = userData else { return nil }
        return lock.withLock { importedFunctionCache[id]?[context] }
    }
}
