import PublicInit

/// Example for struct type
@PublicInit
public struct TestStruct {
    let a: Int
    var b: Bool
}
/**
   The following code produces the following result:
 public struct TestStruct {
     let a: Int
     var b: Bool
    public init(a: Int, b: Bool) {
     self.a = a
     self.b = b
    }
 }
 */

/// Example for class type
@PublicInit
public class TestClass {
    let a: Int
    var b: Bool
}

/**
   The following code produces the following result:
 public class TestClass {
     let a: Int
     var b: Bool
    public init(a: Int, b: Bool) {
     self.a = a
     self.b = b
    }
 }
 */
