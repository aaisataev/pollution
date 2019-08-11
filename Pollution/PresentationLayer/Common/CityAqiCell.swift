//
//  CityAqiCell.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

class CityAqiCell: UITableViewCell, TableViewCell {
    private let titleLabel = UILabel()
    private let aqiLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: TableViewItem) {
        guard let item = item as? CityAqiItem else {
            assertionFailure()
            return
        }
        titleLabel.text = item.title
        aqiLabel.text = item.aqi
    }

    private func setupViews() {
        backgroundColor = .white

        addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0

        addSubview(aqiLabel)
        aqiLabel.font = UIFont.boldSystemFont(ofSize: 33)
        aqiLabel.textAlignment = .right
    }

    private func setupConstraints() {
        aqiLabel.translatesAutoresizingMaskIntoConstraints = false
        aqiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        aqiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        aqiLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        aqiLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: aqiLabel.leftAnchor, constant: -16).isActive = true
    }
}
