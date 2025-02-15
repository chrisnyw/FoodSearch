//
//  MockedInteractors.swift
//  UnitTests
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Testing
import SwiftUI

@testable import FoodSearch

extension DIContainer.Interactors {
    static func mocked(
        images: [MockedImagesInteractor.Action] = [],
        foods: [MockedFoodsInteractor.Action] = [],
        restaurants: [MockedRestaurantsInteractor.Action] = []
    ) -> DIContainer.Interactors {
        self.init(
            images: MockedImagesInteractor(expected: images),
            foods: MockedFoodsInteractor(expected: foods),
            restaurants: MockedRestaurantsInteractor(expected: restaurants)
        )
    }
    
    func verify(sourceLocation: SourceLocation = #_sourceLocation) {
        (foods as? MockedFoodsInteractor)?
            .verify(sourceLocation: sourceLocation)
        (restaurants as? MockedRestaurantsInteractor)?
            .verify(sourceLocation: sourceLocation)
    }
}

// MARK: - ImagesInteractor

struct MockedImagesInteractor: Mock, ImagesInteractor {
    
    enum Action: Equatable {
        case loadImage(URL?)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func load(image: LoadableSubject<UIImage>, url: URL?) {
        register(.loadImage(url))
    }
}

// MARK: - FoodsInteractor

final class MockedFoodsInteractor: Mock, FoodsInteractor {
    
    enum Action: Equatable {
        case naturalNutrients(String)
        case searchItem(String)
        case donateInteraction(SearchFoodInput)
        case searchFoodInput(SearchFoodInput)
    }
    
    let actions: MockActions<Action>
    var foodsResponse: Result<[ApiModel.Food], Error> = .failure(MockError.valueNotSet)
    var searchFoodResult: Result<[AppFoodType: [AppFoodItem]], Error> = .failure(MockError.valueNotSet)
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func naturalNutrients(query: String) async throws -> [ApiModel.Food] {
        self.register(.naturalNutrients(query))
        return try self.foodsResponse.get()
    }
    
    func searchItem(query: String) async throws -> [ApiModel.Food] {
        self.register(.searchItem(query))
        return try self.foodsResponse.get()
    }
    
    func donateInteraction(_ searchFoodInput: SearchFoodInput) {
        self.register(.donateInteraction(searchFoodInput))
    }
    
    func search(searchFoodInput: SearchFoodInput) async throws -> [AppFoodType: [AppFoodItem]] {
        self.register(.searchFoodInput(searchFoodInput))
        return try self.searchFoodResult.get()
    }
}

// MARK: - RestaurantsInteractor

final class MockedRestaurantsInteractor: Mock, RestaurantInteractor {
    
    enum Action: Equatable {
        case fetchNearbyRestaurants(String)
    }
    
    let actions: MockActions<Action>
    var restaurantsResponse: Result<[String], Error> = .failure(MockError.valueNotSet)
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func fetchNearbyRestaurants(food: String) async throws -> [String] {
        self.register(.fetchNearbyRestaurants(food))
        return try self.restaurantsResponse.get()
    }
}
