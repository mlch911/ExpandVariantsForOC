// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ExpandVariantsForOC",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "ExpandVariantsForOC",
            targets: ["ExpandVariantsForOC"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.2.2"),
    ],
    targets: [
        .target(name: "ExpandVariantsForOC", dependencies: ["ExpandVariantsForOCPlugin"]),
        .macro(
            name: "ExpandVariantsForOCPlugin",
            dependencies: [
                .swiftSyntax,
                .swiftSyntaxMacros,
                .swiftCompilerPlugin,
                .swiftSyntaxBuilder,
                .swiftParserDiagnostics,
            ]
        ),
        .testTarget(
            name: "ExpandVariantsForOCTests",
            dependencies: [
                "ExpandVariantsForOCPlugin",
                .swiftSyntaxMacrosTestSupport,
                .macroTesting
            ]
        ),
    ]
)

extension Target.Dependency {
    // swift-syntax
    static let swiftSyntax = Self.product(name: "SwiftSyntax", package: "swift-syntax")
    static let swiftSyntaxMacros = Self.product(name: "SwiftSyntaxMacros", package: "swift-syntax")
    static let swiftCompilerPlugin = Self.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
    static let swiftSyntaxBuilder = Self.product(name: "SwiftSyntaxBuilder", package: "swift-syntax")
    static let swiftParserDiagnostics = Self.product(name: "SwiftParserDiagnostics", package: "swift-syntax")
    static let swiftSyntaxMacrosTestSupport = Self.product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
    // swift-macro-testing
    static let macroTesting = Self.product(name: "MacroTesting", package: "swift-macro-testing")
    
}
