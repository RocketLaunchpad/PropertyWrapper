//
//  MapTests.swift
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

private let conversion: Double = 0.3048 // (1 ft / 0.3048 m)

private func meters(fromFeet feet: Double) -> Double {
    return feet * conversion
}

private func feet(fromMeters meters: Double) -> Double {
    return meters / conversion
}

class MapTests: XCTestCase {

    class TestClass {
        let immutableMeters: Double
        var mutableMeters: Double
        let immutableOptionalDouble: Double?

        init(meters: Double) {
            immutableMeters = meters
            mutableMeters = meters
            immutableOptionalDouble = nil
        }
    }

    class TestWrapper: Wrapper<TestClass> {

        @Map(from: \TestClass.immutableMeters, using: {$0})
        var immutableMeters: Double

        @MutableMap(from: \TestClass.mutableMeters, get: {$0}, set: {$0})
        var mutableMeters: Double

        @Map(from: \TestClass.immutableMeters, using: { feet(fromMeters: $0) })
        var immutableFeet: Double

        @MutableMap(from: \TestClass.mutableMeters, get: { feet(fromMeters: $0) }, set: { meters(fromFeet: $0) })
        var mutableFeet: Double

        @Map(from: \TestClass.immutableOptionalDouble, using: { $0 ?? 3.14159 })
        var immutableDefaultDouble: Double
    }

    func testMap() {
        let wrapped = TestClass(meters: 10)
        let wrapper = TestWrapper(wrapping: wrapped)

        XCTAssertEqual(10, wrapper.immutableMeters)
        XCTAssertEqual(10, wrapper.mutableMeters)
        XCTAssertEqual(32.8084, wrapper.immutableFeet, accuracy: 0.0001)
        XCTAssertEqual(32.8084, wrapper.mutableFeet, accuracy: 0.0001)
        XCTAssertEqual(3.14159, wrapper.immutableDefaultDouble)

        wrapper.mutableFeet = 3
        XCTAssertEqual(3, wrapper.mutableFeet)
        XCTAssertEqual(0.9144, wrapper.mutableMeters, accuracy: 0.0001)
        XCTAssertEqual(0.9144, wrapped.mutableMeters, accuracy: 0.0001)
    }
}
