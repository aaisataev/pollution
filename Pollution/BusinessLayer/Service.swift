//
//  Service.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/20/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

typealias FeedCompletion = (Result<FeedResponse, Error>) -> Void
typealias SearchCompletion = (Result<SearchResponse, Error>) -> Void

class Service {
    private let sessionProvider: SessionProvider
    private let defaults: UserDefaults

    private enum Key: String {
        case cityIndexes
    }

    init(sessionProvider: SessionProvider = .init(), defaults: UserDefaults = .standard) {
        self.sessionProvider = sessionProvider
        self.defaults = defaults
    }

    func getSavedCities() -> [Int] {
        let cities = defaults.value(forKey: Key.cityIndexes.rawValue) as? [Int]
        return cities ?? []
    }

    func saveCity(_ city: Int) {
        let cities = getSavedCities()
        defaults.set(cities + [city], forKey: Key.cityIndexes.rawValue)
    }

    func deleteCity(at index: Int) {
        var cities = getSavedCities()
        cities.remove(at: index)
        defaults.set(cities, forKey: Key.cityIndexes.rawValue)
    }

    func getFeed(for cityIndex: Int, _ completion: @escaping FeedCompletion) {
        sessionProvider.request("/feed/@\(cityIndex)/") { result in
            completion(result)
        }
    }

    func search(keyword: String, _ completion: @escaping SearchCompletion) {
        sessionProvider.request("/search/", parameters: ["keyword": keyword]) { result in
            completion(result)
        }
    }
}
