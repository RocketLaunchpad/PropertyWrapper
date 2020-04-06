//
//  Wrapper.swift
//  RIWrapper
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
            if let property = value as? Property<WrappedType> {
                property.owner = self
            }
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
