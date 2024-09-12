//
//  ExpandVariantsForOCPlugin.swift
//
//
//  Created by mlch911 on 2024/9/11.
//

#if canImport(SwiftCompilerPlugin)
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct ExpandVariantsForOCPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ExpandVariantsForOCMacro.self
    ]
}
#endif
