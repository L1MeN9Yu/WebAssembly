//
// Created by Mengyu Li on 2021/8/19.
//

import CWasm3

public extension Interpreter {
    func call(_ name: String) throws {
        try _call(
            try function(named: name),
            args: []
        )
    }

    func call<Ret>(_ name: String) throws -> Ret where Ret: Primitive {
        try _call(
            try function(named: name),
            args: []
        )
    }

    func call<Arg1>(_ name: String, _ arg1: Arg1) throws where Arg1: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
            ]
        )
    }

    func call<Arg1, Ret>(_ name: String, _ arg1: Arg1) throws -> Ret where Arg1: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
            ]
        )
    }

    func call<Arg1, Arg2>(_ name: String, _ arg1: Arg1, _ arg2: Arg2) throws where Arg1: Primitive, Arg2: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
            ]
        )
    }

    func call<Arg1, Arg2, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Ret: Primitive
    {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(
        _ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3,
        _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6
    ) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive
    {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
                try String(primitive: arg6),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
                try String(primitive: arg6),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(
        _ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3,
        _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7
    ) throws
        where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive,
        Arg4: Primitive, Arg5: Primitive, Arg6: Primitive,
        Arg7: Primitive
    {
        try _call(
            try function(named: name),
            args: [try String(primitive: arg1), try String(primitive: arg2), try String(primitive: arg3),
                   try String(primitive: arg4), try String(primitive: arg5), try String(primitive: arg6),
                   try String(primitive: arg7)]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
                try String(primitive: arg6),
                try String(primitive: arg7),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) throws where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
                try String(primitive: arg6),
                try String(primitive: arg7),
                try String(primitive: arg8),
            ]
        )
    }

    func call<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Ret>(_ name: String, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) throws -> Ret where Arg1: Primitive, Arg2: Primitive, Arg3: Primitive, Arg4: Primitive, Arg5: Primitive, Arg6: Primitive, Arg7: Primitive, Arg8: Primitive, Ret: Primitive {
        try _call(
            try function(named: name),
            args: [
                try String(primitive: arg1),
                try String(primitive: arg2),
                try String(primitive: arg3),
                try String(primitive: arg4),
                try String(primitive: arg5),
                try String(primitive: arg6),
                try String(primitive: arg7),
                try String(primitive: arg8),
            ]
        )
    }
}
