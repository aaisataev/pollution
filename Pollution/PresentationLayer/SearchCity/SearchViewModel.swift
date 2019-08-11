//
//  SearchViewModel.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 8/11/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

final class SearchViewModel {
    var dataSource = Box([TableViewItem]())
    var viewState = Box(ViewState.none)
    var dispatchWorkItem: DispatchWorkItem?

    private let service: Service
    private var cityIndexes: [Int] = []

    init(service: Service = .init()) {
        self.service = service
    }

    func textDidChange(searchText: String) {
        dispatchWorkItem?.cancel()
        guard !searchText.isEmpty else { return }
        dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.service.search(keyword: searchText) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(value):
                        if value.data.isEmpty {
                            self?.viewState.value = .empty(message: "There is no such station")
                        }
                        self?.dataSource.value = value.data.map { CityItem(name: $0.station.name) }
                        self?.cityIndexes = value.data.map { $0.uid }
                    case let .failure(value):
                        self?.viewState.value = .error(error: value.localizedDescription)
                    }
                }
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: dispatchWorkItem!)
    }

    func didSelect(at index: Int) {
        let city = cityIndexes[index]
        service.saveCity(city)
    }
}
