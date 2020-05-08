//
//  XYZDataModel.m
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

#import "XYZDataModel.h"

#import "XYZChildModel.h"

@implementation XYZDataModel

+ (instancetype)buildExampleData
{
    XYZChildModel *child1 = [XYZChildModel new];
    child1.name = @"Moe";
    child1.birthdayTimeIntervalSince1970 = @866692800.0; // 6/19/1997

    XYZChildModel *child2 = [XYZChildModel new];
    child2.name = @"Larry";
    child2.birthdayTimeIntervalSince1970 = @1033790400.0; // 10/05/2002

    XYZChildModel *child3 = [XYZChildModel new];
    child3.name = @"Curly";
    child3.birthdayTimeIntervalSince1970 = @1066795200.0; // 10/22/2003

    XYZDataModel *parent = [XYZDataModel new];
    parent.averageScore = @4.2;
    parent.isEnabled = @YES;
    parent.children = @[child1, child2, child3];

    return parent;
}

@end
