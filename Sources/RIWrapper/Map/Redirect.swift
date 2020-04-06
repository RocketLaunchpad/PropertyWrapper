//
//  Redirect.swift
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

@propertyWrapper
public class Redirect<WrappedType, ValueType>: Map<WrappedType, ValueType, ValueType> {

    public init(_ keyPath: KeyPath<WrappedType, ValueType>) {
        super.init(from: keyPath, using: { $0 })
    }

    public override var wrappedValue: ValueType {
        get {
            super.wrappedValue
        }
    }
}

@propertyWrapper
public class MutableRedirect<WrappedType, ValueType>: MutableMap<WrappedType, ValueType, ValueType> {

    public init(_ keyPath: WritableKeyPath<WrappedType, ValueType>) {
        super.init(from: keyPath, get: { $0 }, set: { $0 })
    }

    public override var wrappedValue: ValueType {
        get {
            super.wrappedValue
        }

        set {
            super.wrappedValue = newValue
        }
    }
}
