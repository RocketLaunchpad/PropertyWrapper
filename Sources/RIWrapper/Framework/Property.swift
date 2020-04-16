//
//  Property.swift
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

// This is used by Wrapper to determine, without associated or parameterized types, whether an object is a Property.
internal protocol PropertyMarker {

    var file: StaticString { get }

    var line: UInt { get }
}

extension PropertyMarker {

    public var typeDescription: String {
        "@\(type(of: self))"
    }

    public var usageLocation: String {
        "\(file):\(line)"
    }
}

open class Property<WrappedType>: PropertyMarker {

    let file: StaticString

    let line: UInt

    private unowned var _owner: Wrapper<WrappedType>? = nil

    public var owner: Wrapper<WrappedType> {
        get {
            guard let o = _owner else {
                // This will occur if this Property was used in a class that does not extend Wrapper.
                fatalError("API MISUSE: The property wrapper \(typeDescription) used at \(usageLocation) is not in a subclass of Wrapper.")
            }
            return o
        }

        set {
            _owner = newValue
        }
    }

    init(file: StaticString, line: UInt) {
        self.file = file
        self.line = line
    }
}
