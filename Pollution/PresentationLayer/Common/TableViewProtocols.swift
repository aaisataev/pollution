//
//  TableViewProtocols.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

protocol TableViewCell: AnyObject {
    func configure(with item: TableViewItem)
}

protocol TableViewItem {
    var identifier: AnyClass { get }
}

protocol TableViewManagerDelegate: AnyObject {
    func didSelect(at: Int)
    func delete(at: Int)
}

extension TableViewManagerDelegate {
    func didSelect(at _: Int) {}
    func delete(at _: Int) {}
}
