//
//  TableViewManager.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

final class TableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    private weak var tableView: UITableView?
    private weak var delegate: TableViewManagerDelegate?

    var dataSource: [TableViewItem] = [] {
        didSet {
            if dataSource.count == oldValue.count {
                updateCells()
            } else {
                tableView?.reloadData()
            }
        }
    }

    func configure(tableView: UITableView, delegate: TableViewManagerDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    func deleteRow(at index: Int) {
        dataSource.remove(at: index)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func updateCells() {
        for i in 0 ..< dataSource.count {
            guard let cell = tableView?.cellForRow(at: IndexPath(row: i, section: 0)) as? TableViewCell else {
                continue
            }
            cell.configure(with: dataSource[i])
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataSource.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(item.identifier)", for: indexPath)
        if let cell = cell as? TableViewCell {
            cell.configure(with: item)
        } else {
            assertionFailure()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(at: indexPath.row)
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.delete(at: indexPath.row)
        }
    }
}
