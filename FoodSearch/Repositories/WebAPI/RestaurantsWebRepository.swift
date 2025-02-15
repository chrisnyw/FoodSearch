//
//  RestaurantsWebRepository.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

protocol RestaurantsWebRepository: WebRepository {
    func restaurants(
        for foodName: String,
        latitude: Double,
        longitude: Double,
        radius: Int
    ) async throws -> [ApiModel.RestaurantItem]
}

struct RealRestaurantsWebRepository: RestaurantsWebRepository {

    let session: URLSession
    let baseURL: String

    init(session: URLSession) {
        self.session = session
        self.baseURL = "https://nominatim.openstreetmap.org"
    }
    
    func restaurants(
        for foodName: String,
        latitude: Double,
        longitude: Double,
        radius: Int
    ) async throws -> [ApiModel.RestaurantItem] {
        let response: [ApiModel.RestaurantItem] = try await self.call(
            endpoint: API.restaurants(
                food: foodName,
                latitude: latitude,
                longitude: longitude,
                radius: radius
            )
        )
        return response
    }
}

// MARK: - Endpoints

extension RealRestaurantsWebRepository {
    enum API {
        case restaurants(food: String, latitude: Double, longitude: Double, radius: Int)
    }
}

extension RealRestaurantsWebRepository.API: APICall {
    private func encodeString(_ string: String) -> String {
        // Define the allowed characters for the query string (excluding characters like space, &, etc.)
        let allowedCharacters = CharacterSet.urlQueryAllowed

        // Encode the string
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            return string
        }
        return encodedString
    }
    
    var path: String {
        switch self {
        case let .restaurants(food, latitude, longitude, radius):
            let query: [String: Any] = [
                "format" : "json",
                "q": food,
                "lat": latitude,
                "lon": longitude,
                "radius": radius
            ]
            
            return "/search?\(self.dictionaryToQueryString(dictionary: query))"
        }
    }
    var method: String {
        switch self {
        case .restaurants:
            return "GET"
        }
    }
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    func body() throws -> Data? {
        return nil
    }
}
