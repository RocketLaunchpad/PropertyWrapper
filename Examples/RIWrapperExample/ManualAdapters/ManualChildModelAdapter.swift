//
//  ManualChildModelAdapter.swift
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

class ManualChildModelAdapter: ChildModel {

    private let model: XYZChildModel

    init(model: XYZChildModel) {
        self.model = model
    }

    var name: String? {
        get {
            return model.name
        }

        set {
            model.name = newValue
        }
    }

    var birthday: Date? {
        get {
            guard let interval = model.birthdayTimeIntervalSince1970?.doubleValue else {
                return nil
            }
            return Date(timeIntervalSince1970: interval)
        }

        set {
            guard let interval = newValue?.timeIntervalSince1970 else {
                model.birthdayTimeIntervalSince1970 = nil
                return
            }
            model.birthdayTimeIntervalSince1970 = NSNumber(value: interval)
        }
    }
}
