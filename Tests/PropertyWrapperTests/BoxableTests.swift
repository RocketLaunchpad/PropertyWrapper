//
//  BoxableTests.swift
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

class BoxableTests: XCTestCase {

    private func verify<T>(_ value: T, file: StaticString = #file, line: UInt = #line) where T: Boxable, T: Equatable {
        let unboxed = T.unbox(from: value.box())
        XCTAssertEqual(value, unboxed, file: file, line: line)
    }

    func testBoxable() {
        verify(Bool(true))
        verify(Double(1))
        verify(Float(2))
        verify(Int(3))
        verify(Int8(4))
        verify(Int16(5))
        verify(Int32(6))
        verify(Int64(7))
        verify(UInt(8))
        verify(UInt8(9))
        verify(UInt16(10))
        verify(UInt32(11))
        verify(UInt64(12))
    }
}
