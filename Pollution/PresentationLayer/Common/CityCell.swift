//
//  CityCell.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/4/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell, TableViewCell {
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: TableViewItem) {
        guard let item = item as? CityItem else {
            assertionFailure()
            return
        }
        label.text = item.name
    }

    private func setupViews() {
        addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
    }

    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
}
