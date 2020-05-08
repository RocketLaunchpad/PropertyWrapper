//
//  Wrapper.swift
//  PropertyWrapper
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Foundation

open class Wrapper<WrappedType> {

    public final var wrapped: WrappedType {
        didSet {
            updateProperties()
        }
    }

    public required init(wrapping wrapped: WrappedType) {
        self.wrapped = wrapped
        updateProperties()
    }

    private func updateProperties() {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children {
            // Use the PropertyMarker protocol to determine whether this child is a Property.
            // We can't use Property with its parameterized type, or a protocol with an associated type here, because we want _any_ Property, not just
            // properties that match our known WrappedType. This allows us to do the subsequent check.
            guard let propertyMarker = value as? PropertyMarker else {
                continue
            }

            // We now know that value is a Property (because Property is the only type to implement PropertyMarker).
            // Next, we check to make sure that the parameterized type of the property matches our parameterized type.
            guard let property = propertyMarker as? Property<WrappedType> else {
                fatalError("API MISUSE: The WrappedType parameter in \(propertyMarker.typeDescription) used at \(propertyMarker.usageLocation) does not match the WrappedType parameter in this Wrapper<\(type(of: wrapped))>. This can occur when a property wrapper uses a key path that refers to a type other than this Wrapper object's WrappedType.")
            }
            property.owner = self
        }
    }

    func box<ValueType, BoxedType>(_ value: ValueType, to keyPath: WritableKeyPath<WrappedType, BoxedType>) where ValueType: Boxable, BoxedType == ValueType.BoxedType {
        wrapped[keyPath: keyPath] = value.box()
    }

    func box<ValueType, BoxedType>(_ value: ValueType?, to keyPath: WritableKeyPath<WrappedType, BoxedType?>) where ValueType: Boxable, BoxedType == ValueType.BoxedType {
        wrapped[keyPath: keyPath] = value?.box()
    }

    func unbox<ValueType, BoxedType>(from keyPath: KeyPath<WrappedType, BoxedType>) -> ValueType where ValueType: Boxable, BoxedType == ValueType.BoxedType {
        return ValueType.unbox(from: wrapped[keyPath: keyPath])
    }

    func unbox<ValueType, BoxedType>(from keyPath: KeyPath<WrappedType, BoxedType?>) -> ValueType? where ValueType: Boxable, BoxedType == ValueType.BoxedType {
        return wrapped[keyPath: keyPath].map { ValueType.unbox(from: $0) }
    }

    func map<StoredType, OutputType>(from keyPath: KeyPath<WrappedType, StoredType>, using transform: (StoredType) -> OutputType) -> OutputType {
        return transform(wrapped[keyPath: keyPath])
    }

    func map<StoredType, OutputType>(from keyPath: KeyPath<WrappedType, StoredType?>, using transform: (StoredType?) -> OutputType?) -> OutputType? {
        return transform(wrapped[keyPath: keyPath])
    }

    func unmap<InputType, StoredType>(_ value: InputType, to keyPath: WritableKeyPath<WrappedType, StoredType>, using transform: (InputType) -> StoredType) {
        wrapped[keyPath: keyPath] = transform(value)
    }

    func unmap<InputType, StoredType>(_ value: InputType?, to keyPath: WritableKeyPath<WrappedType, StoredType?>, using transform: (InputType?) -> StoredType?) {
        wrapped[keyPath: keyPath] = transform(value)
    }
}
