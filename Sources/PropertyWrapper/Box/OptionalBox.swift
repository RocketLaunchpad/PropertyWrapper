//
//  OptionalBox.swift
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

@propertyWrapper
public class OptionalBox<WrappedType, BoxedType, ValueType>: Property<WrappedType> where ValueType: Boxable, BoxedType == ValueType.BoxedType {

    let keyPath: KeyPath<WrappedType, BoxedType?>

    public init(_ keyPath: KeyPath<WrappedType, BoxedType?>,
                _file: StaticString = #file,
                _line: UInt = #line) {

        self.keyPath = keyPath
        super.init(file: _file, line: _line)
    }

    public var wrappedValue: ValueType? {
        get {
            owner.unbox(from: keyPath)
        }
    }
}

@propertyWrapper
public class MutableOptionalBox<WrappedType, BoxedType, ValueType>: Property<WrappedType> where ValueType: Boxable, BoxedType == ValueType.BoxedType {

    let keyPath: WritableKeyPath<WrappedType, BoxedType?>

    public init(_ keyPath: WritableKeyPath<WrappedType, BoxedType?>,
                _file: StaticString = #file,
                _line: UInt = #line) {

        self.keyPath = keyPath
        super.init(file: _file, line: _line)
    }

    public var wrappedValue: ValueType? {
        get {
            owner.unbox(from: keyPath)
        }

        set {
            owner.box(newValue, to: keyPath)
        }
    }
}
