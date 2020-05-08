//
//  NSNumber+Boxable.swift
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

extension Bool:   Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Bool   { return box.boolValue }}
extension Double: Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Double { return box.doubleValue }}
extension Float:  Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Float  { return box.floatValue }}
extension Int:    Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Int    { return box.intValue }}
extension Int8:   Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Int8   { return box.int8Value }}
extension Int16:  Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Int16  { return box.int16Value }}
extension Int32:  Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Int32  { return box.int32Value }}
extension Int64:  Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> Int64  { return box.int64Value }}
extension UInt:   Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> UInt   { return box.uintValue }}
extension UInt8:  Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> UInt8  { return box.uint8Value }}
extension UInt16: Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> UInt16 { return box.uint16Value }}
extension UInt32: Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> UInt32 { return box.uint32Value }}
extension UInt64: Boxable { public func box() -> NSNumber { NSNumber(value: self) }; public static func unbox(from box: NSNumber) -> UInt64 { return box.uint64Value }}
