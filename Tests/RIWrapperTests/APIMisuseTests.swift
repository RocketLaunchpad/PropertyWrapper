//
//  APIMisuseTests.swift
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

import RIWrapper
import XCTest

class APIMisuseTests: XCTestCase {

    // MARK: - Property Wrapped Used in Non-Wrapper Class

    // Change `false` to `true` below to verify that we properly detect when a property wrapper is used outside of a Wrapper subclass.
    #if false
    class TestClass {
        let value: Int = 42
    }

    class TestWrapper {
        // Using a RIWrapper propertyWrapper in a type that does not extend Wrapper will cause a crash when referencing this property.
        @Redirect(\TestClass.value)
        var value: Int
    }

    func testCrash1() {
        let wrapper = TestWrapper()

        // This will crash.
        XCTAssertEqual(42, wrapper.value)
    }
    #endif

    // MARK: - WrappedType Mismatch

    // Change `false` to `true` below to verify that the WrappedType mismatch condition is caught.
    #if false
    class TestClass1 {
        let value1: Int = 42
    }

    class TestClass2 {
        let value2: Int = 88
    }

    class TestWrapper1: Wrapper<TestClass1> {
        // Here, the key path refers to TestClass2 while the enclosing type wraps TestClass1. This will cause a crash when creating an object of this type.
        @Redirect(\TestClass2.value2)
        var value: Int
    }

    func testCrash() {
        // This will crash.
        let wrapper = TestWrapper1(wrapping: TestClass1())
        XCTAssertEqual(42, wrapper.value)
    }
    #endif
}
