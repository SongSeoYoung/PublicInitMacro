import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PublicInitMacros)
import PublicInitMacros

let testMacros: [String: Macro.Type] = [
    "PublicInit": PublicInitMacro.self,
]
#endif

final class PublicInitMacroTests: XCTestCase {
    func test_Class() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public class TestClass {
            public let a: String
            public let b: Int
            public let c: TestEnum
            public let d: TestClass
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public class TestClass {
            public let a: String
            public let b: Int
            public let c: TestEnum
            public let d: TestClass
        
            public init(a: String, b: Int, c: TestEnum, d: TestClass) {
                self.a = a
                self.b = b
                self.c = c
                self.d = d
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Class_ACL() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public class TestClass {
            internal var a: String?
            let b: Float
            fileprivate let c: Int
            private let d: TestEnum
            private let e: TestClass
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public class TestClass {
            internal var a: String?
            let b: Float
            fileprivate let c: Int
            private let d: TestEnum
            private let e: TestClass
        
            public init(a: String? = nil, b: Float, c: Int, d: TestEnum, e: TestClass) {
                self.a = a
                self.b = b
                self.c = c
                self.d = d
                self.e = e
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Class_WithOptionalTypes() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public class TestClass {
            let a: String?
            let b: Float? = nil
            var c: Int?
            var d: Int? = nil
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public class TestClass {
            let a: String?
            let b: Float? = nil
            var c: Int?
            var d: Int? = nil
        
            public init(a: String?, c: Int? = nil, d: Int? = nil) {
                self.a = a
                self.c = c
                self.d = d
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Class_InitialValues() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public class TestClass {
            let a: String = "aa"
            let b: Float? = nil
            var c: Int? = 1
            var d: Int? = nil
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public class TestClass {
            let a: String = "aa"
            let b: Float? = nil
            var c: Int? = 1
            var d: Int? = nil
        
            public init(c: Int? = nil, d: Int? = nil) {
                self.c = c
                self.d = d
            }
        }
        
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Struct() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public struct TestStruct {
            public let a: String
            public let b: Int
            public let c: TestEnum
            public let d: TestClass
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public struct TestStruct {
            public let a: String
            public let b: Int
            public let c: TestEnum
            public let d: TestClass
        
            public init(a: String, b: Int, c: TestEnum, d: TestClass) {
                self.a = a
                self.b = b
                self.c = c
                self.d = d
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Struct_ACL() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public struct TestStruct {
            internal var a: String?
            let b: Float
            fileprivate let c: Int
            private let d: TestEnum
            private let e: TestClass
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public struct TestStruct {
            internal var a: String?
            let b: Float
            fileprivate let c: Int
            private let d: TestEnum
            private let e: TestClass
        
            public init(a: String? = nil, b: Float, c: Int, d: TestEnum, e: TestClass) {
                self.a = a
                self.b = b
                self.c = c
                self.d = d
                self.e = e
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func test_Struct_WithOptionalTypes() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public struct TestStruct {
            let a: String?
            let b: Float? = nil
            var c: Int?
            var d: Int? = nil
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public struct TestStruct {
            let a: String?
            let b: Float? = nil
            var c: Int?
            var d: Int? = nil
        
            public init(a: String?, c: Int? = nil, d: Int? = nil) {
                self.a = a
                self.c = c
                self.d = d
            }
        }
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func test_Struct_InitialValues() {
#if canImport(PublicInitMacros)
        assertMacroExpansion(
            #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        @PublicInit
        public struct TestStruct {
            let a: String = "aa"
            let b: Float? = nil
            var c: Int? = 1
            var d: Int? = nil
        }
        """#
            , expandedSource: #"""
        public enum TestEnum {
        }
        public class TestClass {
            public init() {}
        }
        public struct TestStruct {
            let a: String = "aa"
            let b: Float? = nil
            var c: Int? = 1
            var d: Int? = nil
        
            public init(c: Int? = nil, d: Int? = nil) {
                self.c = c
                self.d = d
            }
        }
        
        """#,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
