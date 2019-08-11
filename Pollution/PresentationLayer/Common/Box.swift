//
//  Box.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/3/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
    }
}
