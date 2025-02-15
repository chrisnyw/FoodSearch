//
//  ApiRestaurant.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

extension ApiModel {
    // MARK: - Response
    struct RestaurantItem: Codable {
        let placeRank: Int
        let osmType: String
        let lon: String
        let boundingBox: [String]
        let addressType: String
        let licence: String
        let type: String
        let lat: String
        let importance: Double
        let osmID: Int
        let displayName: String
        let placeID: Int
        let locationClass: String
        let name: String
        
        // Coding keys to match the JSON keys with camelCase
        enum CodingKeys: String, CodingKey {
            case placeRank = "place_rank"
            case osmType = "osm_type"
            case lon
            case boundingBox = "boundingbox"
            case addressType = "addresstype"
            case licence
            case type
            case lat
            case importance
            case osmID = "osm_id"
            case displayName = "display_name"
            case placeID = "place_id"
            case locationClass = "class"
            case name
        }
    }
}
