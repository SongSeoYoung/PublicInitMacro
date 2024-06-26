# PublicInitMacro
As you know in Swift, when you create an object using the public access modifier, the compiler doesn't automatically generate a public memberwise initializer. This means that developers have to explicitly declare it. However when you need to add or remove properties from the object, you also have to update the memberwise initializer manually, which can be cumbersome.   
🤩 **This macro generates a public access control initializer. The generation criteria are the same as Xcode autocomplete.**
## Motivation:
While studying Java's Lombok, I thought it would be nice if Swift had features like ```@RequiredArgsConstructor```.

## Install:
You can install it via SwiftPackageManager. 
```
https://github.com/SongSeoYoung/PublicInitMacro
```

## Usage:
```swift
@PublicInit
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil
}
```
expands the following code:
```swift
public struct TestStruct {
    private let a: String?
    public let b: Float? = nil
    var c: Int?
    var d: Int? = nil

    public init(a: String?, c: Int? = nil, d: Int? = nil) {
        self.a = a
        self.c = c
        self.d = d
    }
}
```
