//
//  Map.swift
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
public class Map<WrappedType, StoredType, OutputType>: Property<WrappedType> {

    let keyPath: KeyPath<WrappedType, StoredType>

    let transform: (StoredType) -> OutputType

    public init(from keyPath: KeyPath<WrappedType, StoredType>,
                using transform: @escaping (StoredType) -> OutputType,
                _file: StaticString = #file,
                _line: UInt = #line) {

        self.keyPath = keyPath
        self.transform = transform
        super.init(file: _file, line: _line)
    }

    public var wrappedValue: OutputType {
        get {
            owner.map(from: keyPath, using: transform)
        }
    }
}

@propertyWrapper
public class MutableMap<WrappedType, StoredType, OutputType>: Property<WrappedType> {

    let keyPath: WritableKeyPath<WrappedType, StoredType>

    let get: (StoredType) -> OutputType

    let set: (OutputType) -> StoredType

    public init(from keyPath: WritableKeyPath<WrappedType, StoredType>,
                get: @escaping (StoredType) -> OutputType,
                set: @escaping (OutputType) -> StoredType,
                _file: StaticString = #file,
                _line: UInt = #line) {

        self.keyPath = keyPath
        self.get = get
        self.set = set
        super.init(file: _file, line: _line)
    }

    public var wrappedValue: OutputType {
        get {
            owner.map(from: keyPath, using: get)
        }

        set {
            owner.unmap(newValue, to: keyPath, using: set)
        }
    }
}
