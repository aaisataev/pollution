//
//  UIExtensions.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

extension UITableView {
    func register(with dataSource: [TableViewItem]) {
        dataSource.forEach { item in
            register(item.identifier, forCellReuseIdentifier: "\(item.identifier)")
        }
    }
}
