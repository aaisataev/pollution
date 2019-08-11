//
//  CityItem.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/4/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

final class CityItem: TableViewItem {
    var identifier: AnyClass = CityCell.self

    let name: String

    init(name: String) {
        self.name = name
    }
}
