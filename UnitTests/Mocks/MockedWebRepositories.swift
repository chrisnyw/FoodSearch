//
//  MockedWebRepositories.swift
//  UnitTests
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation
import UIKit.UIImage
@testable import FoodSearch

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
}

// MARK: - FoodsWebRepository

final class MockedFoodsWebRepository: TestWebRepository, Mock, FoodWebRepository {
    
    enum Action: Equatable {
        case naturalNutrients(String)
        case searchInstant(String)
        case searchItem(String)
    }
    var actions = MockActions<Action>(expected: [])
    
    var foodsResponses: [Result<[ApiModel.Food], Error>] = []
    var instantsResponses: [Result<[AppFoodType: [ApiModel.FoodItem]], Error>] = []

    func naturalNutrients(query: String) async throws -> [ApiModel.Food] {
        self.register(.naturalNutrients(query))
        guard !self.foodsResponses.isEmpty else { throw MockError.valueNotSet }
        return try self.foodsResponses.removeFirst().get()
    }
    
    func searchInstant(query: String) async throws -> [AppFoodType: [ApiModel.FoodItem]] {
        self.register(.searchInstant(query))
        guard !self.instantsResponses.isEmpty else { throw MockError.valueNotSet }
        return try self.instantsResponses.removeFirst().get()
    }
    
    func searchItem(query: String) async throws -> [ApiModel.Food] {
        self.register(.searchItem(query))
        guard !self.foodsResponses.isEmpty else { throw MockError.valueNotSet }
        return try self.foodsResponses.removeFirst().get()
    }
}

// MARK: - RestaurantsWebRepository

final class MockedRestaurantsWebRepository: TestWebRepository, Mock, RestaurantsWebRepository {
    
    enum Action: Equatable {
        case restaurants(foodName: String, latitude: Double, longitude: Double, radius: Int)
    }
    var actions = MockActions<Action>(expected: [])
    
    var restaurantsResponses: [Result<[ApiModel.RestaurantItem], Error>] = []

    func restaurants(
        for foodName: String,
        latitude: Double,
        longitude: Double,
        radius: Int
    ) async throws -> [ApiModel.RestaurantItem] {
        self.register(
            .restaurants(
                foodName: foodName,
                latitude: latitude,
                longitude: longitude,
                radius: radius
            )
        )
        guard !self.restaurantsResponses.isEmpty else { throw MockError.valueNotSet }
        return try self.restaurantsResponses.removeFirst().get()
    }
}
