//
//  CityAqiItem.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

final class CityAqiItem: TableViewItem {
    var identifier: AnyClass = CityAqiCell.self

    let title: String
    let aqi: String

    init(title: String, aqi: String) {
        self.title = title
        self.aqi = aqi
    }
}
