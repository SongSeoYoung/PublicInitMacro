import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PublicInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        let members: MemberBlockItemListSyntax
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            members = structDecl.memberBlock.members
        } else if let classDecl = declaration.as(ClassDeclSyntax.self) {
            members = classDecl.memberBlock.members
        } else {
            fatalError("This can only be used with classes and structs.")
        }
        
        let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let variableSpecifiers = variableDecl.compactMap { $0.bindingSpecifier }
        let variableValues = variableDecl.map { $0.bindings.first?.initializer?.value }
        let variableNames = variableDecl.compactMap { $0.bindings.first?.pattern }
        let variableTypes = variableDecl.compactMap { $0.bindings.first?.typeAnnotation?.type }
        
        let initializer = try InitializerDeclSyntax(PublicInitMacro.generateInitialCode(
            variableSpecifiers: variableSpecifiers,
            variableNames: variableNames,
            variableTypes: variableTypes,
            initialValue: variableValues
        )) {
            for ((specifier, name), (_, initialValue)) in zip(zip(variableSpecifiers, variableNames), zip(variableTypes, variableValues)) {
                if specifier.text == "let", (initialValue != nil || isOptionalValue(initialValue)) { // If it's a constant and has an initial value, it won't be added to the init.
                } else {
                    ExprSyntax("self.\(name) = \(name)")
                }
            }
        }
        return [DeclSyntax(initializer)]
    }
    
    public static func isOptionalType(_ type: TypeSyntax) -> Bool {
        OptionalTypeSyntax(type) != nil
    }
    
    public static func isOptionalValue(_ value: ExprSyntax?) -> Bool {
        NilLiteralExprSyntax(value) != nil
    }
    
    public static func generateInitialCode(
        variableSpecifiers: [TokenSyntax],
        variableNames: [PatternSyntax],
        variableTypes: [TypeSyntax],
        initialValue:  [ExprSyntax?]
    ) -> SyntaxNodeString {
            var initialCode: String = "public init("
            
            for ((specifier, name), (type, initialValue)) in zip(zip(variableSpecifiers, variableNames), zip(variableTypes, initialValue)) {
                switch (isOptionalType(type), specifier.text == "let") {
                    
                case (true, true): // optional & let
                    if !isOptionalValue(initialValue) {
                        initialCode += "\(name): \(type), "
                    }
                    
                case (true, false): // optional & var
                    initialCode += "\(name): \(type)"
                    initialCode = initialCode.trimmingCharacters(in: .whitespaces)
                    initialCode += " = nil, "
                    
                case (false, true): // not optional & let
                    if initialValue == nil {
                        initialCode += "\(name): \(type), "
                    }
                    
                case (false, false): // not optional & var
                    initialCode += "\(name): \(type), "
                }
            }
            
            initialCode = String(initialCode.dropLast(2))
            initialCode += ")"
            return SyntaxNodeString(stringLiteral: initialCode)
    }
}

@main
struct PublicInitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PublicInitMacro.self,
    ]
}
