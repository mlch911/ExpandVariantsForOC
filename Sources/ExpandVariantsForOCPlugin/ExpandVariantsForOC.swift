import SwiftSyntax
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct ExpandVariantsForOCMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // 确保是一个函数声明
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            context.diagnose(Diagnostic.onlyAppliedToFunctions.diagnose(at: node))
            return []
        }
        
        // 生成可选参数的所有排列组合
        let combinations = generateCombinations(of: Array(funcDecl.signature.parameterClause.parameters))
        
        // 为每个组合生成对应的重载函数
        var generatedFunctions: [DeclSyntax] = []
        for combination in combinations {
            let newFunction = generateFunctionVariant(from: funcDecl, with: combination)
            generatedFunctions.append(DeclSyntax(newFunction))
        }
        
        return generatedFunctions
    }
    
    /// 生成参数组合的排列
    private static func generateCombinations(of parameters: [FunctionParameterSyntax]) -> [[FunctionParameterSyntax]] {
        // 分离带默认值的参数和不带默认值的参数
        var defaultParams = [FunctionParameterSyntax]()
        var nonDefaultParams = [FunctionParameterSyntax]()
        for param in parameters {
            if param.defaultValue != nil {
                var param = param
                param.defaultValue = nil
                defaultParams.append(param.trimmed)
            } else {
                nonDefaultParams.append(param)
            }
        }
        
        // 生成带默认值参数的所有组合
        var combinations = [[FunctionParameterSyntax]]()
        combinations.append([]) // 空组合
        for i in 0..<defaultParams.count {
            let currentCount = combinations.count
            for j in 0..<currentCount {
                var newCombo = combinations[j]
                newCombo.append(defaultParams[i])
                if newCombo.count < defaultParams.count {
                    combinations.append(newCombo)
                }
            }
        }
        combinations.sort { $0.count < $1.count }
        
        // 将不带默认值的参数添加到每个组合中
        let result = combinations.map { combo in
            nonDefaultParams + combo
        }.map { combo in
            combo.enumerated().map { index, param in
                if index == combo.count - 1 {
                    // 最后一个参数，去掉逗号和空格
                    var modifiedParam = param
                    modifiedParam.trailingComma = nil
                    modifiedParam.trailingTrivia = []
                    return modifiedParam
                } else {
                    // 其他参数，添加逗号和空格
                    var modifiedParam = param
                    modifiedParam.trailingComma = .commaToken()
                    return modifiedParam
                }
            }
        }
        return result
    }
    
    /// 根据组合生成重载函数
    private static func generateFunctionVariant(
        from originalFunctionDecl: FunctionDeclSyntax,
        with parameters: [FunctionParameterSyntax]
    ) -> FunctionDeclSyntax {
        // 构建参数输入部分
        let parameterClause = FunctionParameterClauseSyntax(
            leftParen: .leftParenToken(),
            parameters: .init(parameters),
            rightParen: .rightParenToken()
        )
        
        // 构建函数体：调用原始函数，将参数正确传递进去
        let body = CodeBlockSyntax {
            let argumentList = LabeledExprListSyntax {
                for param in originalFunctionDecl.signature.parameterClause.parameters {
                    if let matchingParam = parameters.first(where: { $0.realName.description == param.realName.description }) {
                        LabeledExprSyntax(
                            label: param.callName,
                            colon: param.callColon,
                            expression: ExprSyntax(DeclReferenceExprSyntax(baseName: matchingParam.realName))
                        )
                    } else if let defaultValue = param.defaultValue?.value {
                        // 如果参数有默认值，使用默认值
                        LabeledExprSyntax(
                            label: param.callName,
                            colon: param.callColon,
                            expression: defaultValue
                        )
                    } else {
                        // 如果参数既不在当前函数签名中，也没有默认值，则传递 nil
                        LabeledExprSyntax(
                            label: param.callName,
                            colon: param.callColon,
                            expression: ExprSyntax(NilLiteralExprSyntax())
                        )
                    }
                }
            }
            
            let functionCall = FunctionCallExprSyntax(
                calledExpression: ExprSyntax(DeclReferenceExprSyntax(baseName: originalFunctionDecl.name)),
                leftParen: .leftParenToken(),
                arguments: argumentList,
                rightParen: .rightParenToken()
            )
            
            if originalFunctionDecl.signature.returnClause != nil {
                ReturnStmtSyntax(
                    expression: ExprSyntax(functionCall)
                )
            } else {
                ExprSyntax(functionCall)
            }
        }

        // 创建新的属性列表，排除当前宏，避免死循环
        let attributes = AttributeListSyntax {
            "@objc"
            "@available(swift, obsoleted: 1.0)" // 不允许swift调用
            for attribute in originalFunctionDecl.attributes {
                if let element = attribute.as(AttributeSyntax.self) {
                    if element.attributeName.description != "ExpandVariantsForOC" {
                        attribute
                    }
                } else {
                    attribute
                }
            }
        }
        
        // 构建最终的函数声明
        return FunctionDeclSyntax(
            attributes: attributes,
            modifiers: originalFunctionDecl.modifiers,
            funcKeyword: originalFunctionDecl.funcKeyword,
            name: originalFunctionDecl.name,
            genericParameterClause: originalFunctionDecl.genericParameterClause,
            signature: FunctionSignatureSyntax(
                parameterClause: parameterClause,
                returnClause: originalFunctionDecl.signature.returnClause
            ),
            genericWhereClause: originalFunctionDecl.genericWhereClause,
            body: body
        )
    }
}

extension ExpandVariantsForOCMacro {
    public enum Diagnostic {
        case onlyAppliedToFunctions
    }
}

extension ExpandVariantsForOCMacro.Diagnostic: DiagnosticMessage {
    public var message: String {
        switch self {
        case .onlyAppliedToFunctions:   "This macro can only be applied to functions."
        }
    }
    
    public var severity: DiagnosticSeverity { .error }
    
    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "ExpandVariantsForOCMacro.\(self)")
    }
    
    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }
}

extension FunctionParameterSyntax {
    /// 调用方法时的参数名
    var callName: TokenSyntax? {
        if firstName.tokenKind == .wildcard {
            nil // 如果没有形参名(_)，则无需参数名
        } else {
            firstName.trimmed
        }
    }
    
    var callColon: TokenSyntax? {
        if firstName.tokenKind == .wildcard {
            nil
        } else {
            .colonToken()
        }
    }
    
    var realName: TokenSyntax {
        secondName ?? firstName
    }
}
