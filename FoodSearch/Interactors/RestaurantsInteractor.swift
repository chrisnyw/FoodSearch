//
//  RestaurantsInteractor.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftLocation

protocol RestaurantInteractor {
    func fetchNearbyRestaurants(food: String) async throws -> [String]
}

class RealRestaurantInteractor: NSObject, RestaurantInteractor, CLLocationManagerDelegate {
    
    private let location = Location()
    private let restaurantsWebRepository: RestaurantsWebRepository

    init(restaurantsWebRepository: RestaurantsWebRepository) {
        self.restaurantsWebRepository = restaurantsWebRepository
    }
    
    func fetchNearbyRestaurants(food: String) async throws -> [String] {
    
        try await self.location.requestPermission(.whenInUse)
        let userLocation = try await self.location.requestLocation()
        
        guard let coordinate = userLocation.location?.coordinate else {
            throw APIError.invalidURL
        }
        let result = try await self.restaurantsWebRepository.restaurants(
            for: food,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            radius: 5000
        )
        return result.map { $0.displayName }
    }
}


struct StubRestaurantInteractor: RestaurantInteractor {
    func fetchNearbyRestaurants(food: String) async throws -> [String] {
        return []
    }
}
