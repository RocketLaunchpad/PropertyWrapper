//
//  ChildModelAdapter.swift
//  PropertyWrapperExample
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
import PropertyWrapper

/// This is an example of a `ChildModel` adapter using the `PropertyWrapper` library. Compare to `ManualChildModelAdapter`.
class ChildModelAdapter: Wrapper<XYZChildModel>, ChildModel {

    @MutableRedirect(\XYZChildModel.name)
    var name: String?

    @MutableMap(from: \XYZChildModel.birthdayTimeIntervalSince1970,
                get: { number in number.map { Date(timeIntervalSince1970: $0.doubleValue) } },
                set: { date in date.map { NSNumber(value: $0.timeIntervalSince1970) } })
    var birthday: Date?
}

extension ChildModelAdapter {

    static func from(array: [Any]?) -> [ChildModelAdapter] {
        guard let array = array else {
            return []
        }

        return array.compactMap { obj in
            guard let child = obj as? XYZChildModel else {
                return nil
            }
            return ChildModelAdapter(wrapping: child)
        }
    }
}
