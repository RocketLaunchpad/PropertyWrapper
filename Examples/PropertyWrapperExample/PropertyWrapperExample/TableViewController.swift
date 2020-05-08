//
//  TableViewController.swift
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

import UIKit

/// Illustrates accessing an `XYZDataModel` instance with `XYZChildModel` children all using `DataModelAdapter` and `ChildModelAdapter`.
class TableViewController: UITableViewController {

    private var model: DataModelAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()
        model = DataModelAdapter(wrapping: XYZDataModel.buildExampleData())
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    private enum Section: Int, CaseIterable {
        case parent
        case children
    }

    private enum ParentRow: Int, CaseIterable {
        case isEnabled
        case averageScore
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .parent:
            return ParentRow.allCases.count
        case .children:
            return model.children.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == Section.children.rawValue else {
            return nil
        }
        return "Children"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        switch Section(rawValue: indexPath.section) {
        case .parent:
            let id = "parent"
            cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .value1, reuseIdentifier: id)

            switch ParentRow(rawValue: indexPath.row) {
            case .isEnabled:
                cell.textLabel?.text = "Is enabled?"
                cell.detailTextLabel?.text = "\(model.isEnabled)"

            case .averageScore:
                cell.textLabel?.text = "Average score"
                cell.detailTextLabel?.text = "\(model.averageScore)"

            default:
                return UITableViewCell()
            }

        case .children:
            let id = "child"
            cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .subtitle, reuseIdentifier: id)

            let child = model.children[indexPath.row]
            cell.textLabel?.text = child.name ?? "(nil)"
            cell.detailTextLabel?.text = child.birthday?.description ?? "(nil)"

        default:
            return UITableViewCell()
        }

        return cell
    }
}

