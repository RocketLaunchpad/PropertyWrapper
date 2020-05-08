//
//  BoxTests.swift
//  PropertyWrapperTests
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

import PropertyWrapper
import XCTest

class BoxTests: XCTestCase {

    class TestClass {
        let immutableInt: NSNumber
        var mutableInt: NSNumber

        let immutableOptionalInt: NSNumber?
        var mutableOptionalInt: NSNumber?

        let immutableDefaultInt: NSNumber?
        var mutableDefaultInt: NSNumber?

        init(value: Int) {
            immutableInt = NSNumber(value: value + 1)
            mutableInt = NSNumber(value: value + 2)
            immutableOptionalInt = NSNumber(value: value + 3)
            mutableOptionalInt = NSNumber(value: value + 4)
            immutableDefaultInt = nil
            mutableDefaultInt = nil
        }
    }

    class TestWrapper: Wrapper<TestClass> {

        @Box(\TestClass.immutableInt)
        var immutableInt: Int

        @MutableBox(\TestClass.mutableInt)
        var mutableInt: Int

        @OptionalBox(\TestClass.immutableOptionalInt)
        var immutableOptionalInt: Int?

        @MutableOptionalBox(\TestClass.mutableOptionalInt)
        var mutableOptionalInt: Int?

        @DefaultBox(\TestClass.immutableDefaultInt, default: 5)
        var immutableDefaultInt: Int

        @MutableDefaultBox(\TestClass.mutableDefaultInt, default: 6)
        var mutableDefaultInt: Int
    }

    func testBox() {
        let wrapped = TestClass(value: 0)
        let wrapper = TestWrapper(wrapping: wrapped)

        XCTAssertEqual(1, wrapper.immutableInt)
        XCTAssertEqual(2, wrapper.mutableInt)
        XCTAssertEqual(3, wrapper.immutableOptionalInt)
        XCTAssertEqual(4, wrapper.mutableOptionalInt)
        XCTAssertEqual(5, wrapper.immutableDefaultInt)
        XCTAssertEqual(6, wrapper.mutableDefaultInt)

        wrapper.mutableInt = 42
        XCTAssertEqual(42, wrapper.mutableInt)
        XCTAssertEqual(NSNumber(value: 42), wrapped.mutableInt)

        wrapper.mutableOptionalInt = nil
        XCTAssertNil(wrapper.mutableOptionalInt)
        XCTAssertNil(wrapped.mutableOptionalInt)

        wrapper.mutableDefaultInt = 88
        XCTAssertEqual(88, wrapper.mutableDefaultInt)
        XCTAssertEqual(NSNumber(value: 88), wrapped.mutableDefaultInt)
    }

    static override func tearDown() {
        super.tearDown()
    }
}
