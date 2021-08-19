// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebAssembly",
    products: [
        .library(name: "WebAssembly", targets: ["WebAssembly"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CWasm3",
            cSettings: [
                .define("APPLICATION_EXTENSION_API_ONLY", to: "YES"),
                .define("d_m3MaxDuplicateFunctionImpl", to: "10"),
            ]
        ),
        .target(
            name: "Locks"
        ),
        .target(
            name: "WebAssembly",
            dependencies: [
                .target(name: "CWasm3"),
                .target(name: "Locks"),
            ],
            cSettings: [
                .define("APPLICATION_EXTENSION_API_ONLY", to: "YES"),
            ]
        ),
        .testTarget(
            name: "WebAssemblyTests",
            dependencies: [
                .target(name: "WebAssembly"),
            ],
            exclude: [
                "Resources/constant.wat",
                "Resources/memory.wat",
                "Resources/fib64.wat",
                "Resources/imported-add.wat",
                "Resources/add.wat",
            ]
        ),
    ]
)
