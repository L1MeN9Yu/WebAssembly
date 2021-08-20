//
// Created by Mengyu Li on 2021/8/20.
//

import var CWasm3.M3_VERSION_MAJOR
import var CWasm3.M3_VERSION_MINOR
import var CWasm3.M3_VERSION_REV

private let _major: Int = 0
private let _minor: Int = 1
private let _patch: Int = 0

public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int

    private init(major: Int, minor: Int, patch: Int) {
        precondition(major <= Self.maxNumber)
        precondition(minor <= Self.maxNumber)
        precondition(patch <= Self.maxNumber)
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

public extension Version {
    var value: Int {
        var value = 0
        value |= major << (10 * 0)
        value |= minor << (10 * 1)
        value |= patch << (10 * 2)
        return value
    }

    init(value: Int) {
        let major = (value >> (10 * 0)) & Self.maxNumber
        let minor = (value >> (10 * 1)) & Self.maxNumber
        let patch = (value >> (10 * 2)) & Self.maxNumber
        self.init(major: major, minor: minor, patch: patch)
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        "\(major).\(minor).\(patch)"
    }
}

extension Version: Equatable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
}

private extension Version {
    static let maxNumber: Int = 1023
}

public extension Version {
    static let current: Self = .init(major: _major, minor: _minor, patch: _patch)
    static let wasm3: Self = .init(major: Int(M3_VERSION_MAJOR), minor: Int(M3_VERSION_MINOR), patch: Int(M3_VERSION_REV))
}
