//
//  StateView.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/4/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

protocol Reloadable: AnyObject {
    func reload()
}

enum ViewState {
    case empty(message: String)
    case error(error: String)
    case none
}

class StateView: UIView {
    weak var delegate: Reloadable?
    var state: ViewState = .none {
        didSet {
            setupState()
        }
    }

    private let label = UILabel()
    private let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.numberOfLines = 0

        addSubview(button)
        button.setTitle("Reload", for: .normal)
        button.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
    }

    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func setupState() {
        switch state {
        case let .empty(message):
            isHidden = false
            label.text = message
            button.isHidden = true
        case let .error(error):
            isHidden = false
            label.text = error
            button.isHidden = false
        case .none:
            isHidden = true
        }
    }

    @objc private func buttonDidPressed() {
        delegate?.reload()
    }
}
