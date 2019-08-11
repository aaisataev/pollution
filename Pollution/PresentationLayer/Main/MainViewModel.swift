//
//  MainViewModel.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/20/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

final class MainViewModel {
    var dataSource = Box([TableViewItem]())
    var viewState = Box(ViewState.none)

    private let service: Service

    init(service: Service = .init()) {
        self.service = service
    }

    func viewDidLoad() {
        getFeed()
    }

    func tableViewDidPulled() {
        getFeed()
    }

    func delete(at index: Int) {
        service.deleteCity(at: index)
        dataSource.value.remove(at: index)
    }

    private func getFeed() {
        let cities = service.getSavedCities()
        if cities.isEmpty {
            dataSource.value = []
            viewState.value = .empty(message: "Empty")
            return
        }

        let dispatchGroup = DispatchGroup()
        var responses: [FeedResponse] = []
        for city in cities {
            dispatchGroup.enter()
            service.getFeed(for: city) { result in
                switch result {
                case let .success(value):
                    responses.append(value)
                case let .failure(value):
                    print(value)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if responses.isEmpty {
                self.viewState.value = .error(error: NetworkError.unknown.localizedDescription)
            } else {
                let items = responses.map { CityAqiItem(title: $0.data.city.name, aqi: String($0.data.aqi)) }
                self.dataSource.value = items
            }
        }
    }
}
