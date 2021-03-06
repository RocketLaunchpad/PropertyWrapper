//
//  DataModelAdapter.swift
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

/// This is an example of a `ChildModel` adapter using the `PropertyWrapper` library. Compare to `ManualDataModelAdapter`.
class DataModelAdapter: Wrapper<XYZDataModel>, DataModel {

    @MutableDefaultBox(\XYZDataModel.isEnabled, default: false)
    var isEnabled: Bool

    @DefaultBox(\XYZDataModel.averageScore, default: 0)
    var averageScore: Double

    @Map(from: \XYZDataModel.children, using: { ChildModelAdapter.from(array: $0) })
    var children: [ChildModel]
}
