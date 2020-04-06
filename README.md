# RIWrapper

This library facilitates the creation of wrapper objects used to adapt data model objects from one API to another.

## Problem Description

Sometimes we need to integrate with an Objective-C library that was not written with Swift in mind. Maybe the naming conventions are wrong, or the use of optionals is not sensible in a Swift context. Maybe the library exposes `NSNumber` values instead of primitive values (since in Objective-C collections like `NSArray` and `NSDictionary` could only contain objects).

We'll explore an example Objective-C library providing two types, `XYZDataModel` and `XYZChildModel`:

```objc
// XYZDataModel.h

@interface XYZDataModel : NSObject

// Boolean
@property (nullable) NSNumber *isEnabled;

// Double
@property (nullable) NSNumber *averageScore;

// Array of XYZChildModel
@property (nullable) NSArray *children;

@end



// XYZChildModel.h

@interface XYZChildModel : NSObject

@property (nullable) NSString *name;

// Integer
@property (nullable) NSNumber *birthdayTimeIntervalSince1970;

@end
```

The generated Swift interfaces for these types would be:

```swift
open class XYZDataModel : NSObject {

    // Boolean
    open var isEnabled: NSNumber?

    // Double
    open var averageScore: NSNumber?

    // Array of XYZChildModel
    open var children: [Any]?
}

open class XYZChildModel : NSObject {

    open var name: String?

    // Integer
    open var birthdayTimeIntervalSince1970: NSNumber?
}
```

This is not ideal. We need to refer to the comments to know the unboxed types of `XYZDataModel.isEnabled` and `XYZDataModel.averageScore`, as well as the element type of `XYZDataModel.children`. We need to convert `XYZChildModel.birthdayTimeIntervalSince1970` to and from a `Date` value to be used in other parts of the client code.

We decide to make protocols for each of these model types. This allows us to define a more-sane API as well as to create mock data types for unit testing.

```swift
protocol DataModel {

    var isEnabled: Bool { get set }

    var averageScore: Double { get }

    var children: [ChildModel] { get }
}

protocol ChildModel {

    var name: String? { get set }

    var birthday: Date? { get set }
}
```

Now we need to manually create adapters to make `XYZDataModel` conform to the `DataModel` protocol and `XYZChildModel` conform to the `ChildModel` protocol. This involves a fair amount of boilerplate code and lots of potential for mistakes.

```swift
class ManualDataModelAdapter: DataModel {

    private let model: XYZDataModel

    init(model: XYZDataModel) {
        self.model = model
    }

    var isEnabled: Bool {
        get {
            return model.isEnabled?.boolValue ?? false
        }

        set {
            model.isEnabled = NSNumber(value: newValue)
        }
    }

    var averageScore: Double {
        return model.averageScore?.doubleValue ?? 0
    }

    var children: [ChildModel] {
        guard let array = model.children else {
            return []
        }

        return array.compactMap { obj in
            guard let child = obj as? XYZChildModel else {
                return nil
            }
            return ManualChildModelAdapter(model: child)
        }
    }
}

class ManualChildModelAdapter: ChildModel {

    private let model: XYZChildModel

    init(model: XYZChildModel) {
        self.model = model
    }

    var name: String? {
        get {
            return model.name
        }

        set {
            model.name = newValue
        }
    }

    var birthday: Date? {
        get {
            guard let interval = model.birthdayTimeIntervalSince1970?.doubleValue else {
                return nil
            }
            return Date(timeIntervalSince1970: interval)
        }

        set {
            guard let interval = newValue?.timeIntervalSince1970 else {
                model.birthdayTimeIntervalSince1970 = nil
                return
            }
            model.birthdayTimeIntervalSince1970 = NSNumber(value: interval)
        }
    }
}
```

## Using RIWrapper

The RIWrapper library uses property wrappers to eliminate most of the boilerplate code in the adapters shown above, allowing us to write something much more concise:

```swift
import RIWrapper

class DataModelAdapter: Wrapper<XYZDataModel>, DataModel {

    @MutableDefaultBox(\XYZDataModel.isEnabled, default: false)
    var isEnabled: Bool

    @DefaultBox(\XYZDataModel.averageScore, default: 0)
    var averageScore: Double

    @Map(from: \XYZDataModel.children, using: { ChildModelAdapter.from(array: $0) })
    var children: [ChildModel]
}

class ChildModelAdapter: Wrapper<XYZChildModel>, ChildModel {

    @MutableRedirect(\XYZChildModel.name)
    var name: String?

    @MutableMap(from: \XYZChildModel.birthdayTimeIntervalSince1970,
                get: { number in number.map { Date(timeIntervalSince1970: $0.doubleValue) } },
                set: { date in date.map { NSNumber(value: $0.timeIntervalSince1970) } })
    var birthday: Date?
}

extension ChildModelAdapter {

    static func from(array: [Any]?) -> [ChildModelAdapter] {
        guard let array = array else {
            return []
        }

        return array.compactMap { obj in
            guard let child = obj as? XYZChildModel else {
                return nil
            }
            return ChildModelAdapter(wrapping: child)
        }
    }
}
```

## API Description

The adapter classes all extend the `Wrapper<WrappedType>` class. The `WrappedType` type parameter is the type of the wrapped object. This provides an initializer `init(wrapping: WrappedType)`.

The library provides the following property wrappers to simplify the creation of adapters:

- `Box` property wrappers are used to box and unbox primitive values in and from box objects. The library supports using `NSNumber` as a box type, but you can extend it to support other box types. See the `Boxable` protocol for details.
    - `@Box(_ keyPath: KeyPath<WrappedType, BoxedType>)` is a read-only property extracted from a box. This is used to implement a primitive read-only property.
    - `@MutableBox(_ keyPath: WritableKeyPath<WrappedType, BoxedType>)` is a read-write property backed by a box. This is used to implement a primitive read-write property.
    - `@OptionalBox(_ keyPath: KeyPath<WrappedType, BoxedType?>)` is a read-only property extracted from an optional box. This is used to implement an optional primitive read-only property.
    - `@OptionalMutableBox(_ keyPath: WritableKeyPath<WrappedType, BoxedType?>)` is a read-write property backed by an optional box. This is used to implement an optional primitive read-write property.
    - `@DefaultBox(_ keyPath: KeyPath<WrappedType, BoxedType?>, default: ValueType)` is a read-only property backed by an optional box with a default value. This is used to implement a primitive read-only property backed by an optional box.
    - `@MutableDefaultBox(_ keyPath: MutableKeyPath<WrappedType, BoxedType?>, default: ValueType)` is a read-write property backed by an optional box with a default value. This is used to implement a primitive read-write property backed by an optional box.
- `Map` property wrappers are used to transform values:
    - `@Map(from keyPath: KeyPath<WrappedType, StoredType>, using transform: @escaping (StoredType) -> OutputType)` is a read-only property backed by a `StoredType` value. A block is provided to transform from `StoredType` to `OutputType`. This is used to implement a read-only property of type `OutputType`.
    - `@MutableMap(from keyPath: WritableKeyPath<WrappedType, StoredType>, get: @escaping (StoredType) -> OutputType, set: @escaping (OutputType) -> StoredType)` is a read-write property backed by a `StoredType` value. Two blocks are provided: a `get` block to transform from `StoredType` to `OutputType` and a `set` block to transform from `OutputType` to `StoredType`. This is used to implement a read-write property of type `OutputType`.
    - `@Redirect(_ keyPath: KeyPath<WrappedType, ValueType>)` is a special case of the `Map` property wrapper, providing an identity transform of `{ $0 }` as its block argument.
    - `@MutableRedirect(_ keyPath: WritableKeyPath<WrappedType, ValueType>)` is a special case of the `MutableMap` property wrapper, providing identity transforms of `{ $0 }` as the `get` and `set` block arguments.

## Installation Instructions

To install, add the following to your `Podfile`:

```
pod 'RIWrapper', :git => 'https://github.com/RocketLaunchpad/RIWrapper.git', :branch => 'master'
```

