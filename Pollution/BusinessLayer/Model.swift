//
//  Model.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/20/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

struct FeedResponse: Codable {
    let status: String
    let data: FeedResponseData
}

struct FeedResponseData: Codable {
    let aqi: Int
    let city: City
}

struct SearchResponse: Codable {
    let status: String
    let data: [SearchResponseData]
}

struct SearchResponseData: Codable {
    let uid: Int
    let station: City
}

struct City: Codable {
    let name: String
}
