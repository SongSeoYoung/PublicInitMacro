/// This macro generates a public access control initializer.
/// The generation criteria are the same as Xcode autocomplete. For example,
///
/// ```
/// @PublicInit
/// public struct TestStruct {
///     private let a: String?
///     public let b: Float? = nil
///     var c: Int?
///     var d: Int? = nil
/// }
/// ```
///
/// produces the following code:
///
/// ```
/// public struct TestStruct {
///     private let a: String?
///     public let b: Float? = nil
///     var c: Int?
///     var d: Int? = nil
///
///     public init(a: String?, c: Int? = nil, d: Int? = nil) {
///         self.a = a
///         self.c = c
///         self.d = d
///     }
/// }
/// ```
@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "PublicInitMacros", type: "PublicInitMacro")
