//
//  FoodsInteractorTests.swift
//  UnitTests
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Testing
import SwiftUI
@testable import FoodSearch

@MainActor
@Suite class FoodsInteractorTests {

    let mockedWebRepo: MockedFoodsWebRepository
    let sut: RealFoodsInteractor

    init() {
        self.mockedWebRepo = MockedFoodsWebRepository()
        self.sut = RealFoodsInteractor(webRepository: self.mockedWebRepo)
    }
}

// MARK: - NaturalNutrientsFoodsList()

final class NaturalNutrientsFoodsListTests: FoodsInteractorTests {

    @Test func happyPath() async throws {
        let foods = ApiModel.Food.mockedData
        let queryFood = foods.first!.foodName
        self.mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        self.mockedWebRepo.foodsResponses = [.success(foods)]
        let result = try await self.sut.naturalNutrients(query: queryFood)
        #expect(result == foods)
        self.mockedWebRepo.verify()
    }

    @Test func webFailure() async throws {
        let queryFood = "pizza"
        mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        let error = NSError.test
        mockedWebRepo.foodsResponses = [.failure(error)]
        await #expect(throws: error) {
            try await sut.naturalNutrients(query: queryFood)
        }
        mockedWebRepo.verify()
    }
}

// MARK: - SearchItemFoodsListTests()

final class SearchItemFoodsListTests: FoodsInteractorTests {

    @Test func happyPath() async throws {
        let foods = ApiModel.Food.mockedData
        let queryFood = foods.first!.foodName
        self.mockedWebRepo.actions = .init(expected: [
            .searchItem(queryFood)
        ])
        self.mockedWebRepo.foodsResponses = [.success(foods)]
        let result = try await self.sut.searchItem(query: queryFood)
        #expect(result == foods)
        self.mockedWebRepo.verify()
    }

    @Test func webFailure() async throws {
        let queryFood = "hamburger"
        mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        let error = NSError.test
        mockedWebRepo.foodsResponses = [.failure(error)]
        await #expect(throws: error) {
            try await sut.naturalNutrients(query: queryFood)
        }
        mockedWebRepo.verify()
    }
}

// MARK: - SearchFoodInputTests()

final class SearchFoodInputTests: FoodsInteractorTests {

    static let foodName = "pizza"
    
    static let commonFoods: [ApiModel.Food] = [
        ApiModel.Food.mockFood(foodName: foodName, calories: 250),
        ApiModel.Food.mockFood(foodName: foodName, calories: 400)
    ]
    
    static let brandedFoods: [ApiModel.FoodItem] = [
        ApiModel.FoodItem.mockFoodItem(foodName: foodName, calories: 250),
        ApiModel.FoodItem.mockFoodItem(foodName: foodName, calories: 350)
    ]
    
    static let instantFoods: [AppFoodType: [ApiModel.FoodItem]] = [
        .common: commonFoods.map{ $0.foodItem },
        .branded: brandedFoods,
    ]
    
    static let commonFoodsNames = commonFoods.map{ $0.foodName}.joined(separator: ", ")
    
    @Test func getFoodsMoreThan300Calories() async throws {
        let searchFoodInput = SearchFoodInput(
            foodName: Self.foodName,
            comparative: .more,
            calories: 300
        )
        
        self.mockedWebRepo.actions = .init(expected: [
            .searchInstant(Self.foodName),
            .naturalNutrients(Self.commonFoodsNames)
        ])
        
        self.mockedWebRepo.foodsResponses = [.success(Self.commonFoods)]
        self.mockedWebRepo.instantsResponses = [.success(Self.instantFoods)]
        let result = try await self.sut.search(searchFoodInput: searchFoodInput)
        #expect(result[.common]?.count == 1)
        #expect(result[.branded]?.count == 1)
        self.mockedWebRepo.verify()
    }
    
    @Test func getFoodsMoreThan100Calories() async throws {
        let searchFoodInput = SearchFoodInput(
            foodName: Self.foodName,
            comparative: .more,
            calories: 100
        )
        
        self.mockedWebRepo.actions = .init(expected: [
            .searchInstant(Self.foodName),
            .naturalNutrients(Self.commonFoodsNames)
        ])
        
        self.mockedWebRepo.foodsResponses = [.success(Self.commonFoods)]
        self.mockedWebRepo.instantsResponses = [.success(Self.instantFoods)]
        let result = try await self.sut.search(searchFoodInput: searchFoodInput)
        #expect(result[.common]?.count == 2)
        #expect(result[.branded]?.count == 2)
        self.mockedWebRepo.verify()
    }
    
    @Test func getFoodsMoreThan380Calories() async throws {
        let searchFoodInput = SearchFoodInput(
            foodName: Self.foodName,
            comparative: .more,
            calories: 380
        )
        
        self.mockedWebRepo.actions = .init(expected: [
            .searchInstant(Self.foodName),
            .naturalNutrients(Self.commonFoodsNames)
        ])
        
        self.mockedWebRepo.foodsResponses = [.success(Self.commonFoods)]
        self.mockedWebRepo.instantsResponses = [.success(Self.instantFoods)]
        let result = try await self.sut.search(searchFoodInput: searchFoodInput)
        #expect(result[.common]?.count == 1)
        #expect(result[.branded]?.count == 0)
        self.mockedWebRepo.verify()
    }
    
    @Test func getFoodsLessThan500Calories() async throws {
        let searchFoodInput = SearchFoodInput(
            foodName: Self.foodName,
            comparative: .less,
            calories: 500
        )
        
        self.mockedWebRepo.actions = .init(expected: [
            .searchInstant(Self.foodName),
            .naturalNutrients(Self.commonFoodsNames)
        ])
        
        self.mockedWebRepo.foodsResponses = [.success(Self.commonFoods)]
        self.mockedWebRepo.instantsResponses = [.success(Self.instantFoods)]
        let result = try await self.sut.search(searchFoodInput: searchFoodInput)
        #expect(result[.common]?.count == 2)
        #expect(result[.branded]?.count == 2)
        self.mockedWebRepo.verify()
    }
    
    @Test func getFoodsLessThan300Calories() async throws {
        let searchFoodInput = SearchFoodInput(
            foodName: Self.foodName,
            comparative: .less,
            calories: 300
        )
        
        self.mockedWebRepo.actions = .init(expected: [
            .searchInstant(Self.foodName),
            .naturalNutrients(Self.commonFoodsNames)
        ])
        
        self.mockedWebRepo.foodsResponses = [.success(Self.commonFoods)]
        self.mockedWebRepo.instantsResponses = [.success(Self.instantFoods)]
        let result = try await self.sut.search(searchFoodInput: searchFoodInput)
        #expect(result[.common]?.count == 1)
        #expect(result[.branded]?.count == 1)
        self.mockedWebRepo.verify()
    }

    @Test func webFailure() async throws {
        let queryFood = "pizza"
        mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        let error = NSError.test
        mockedWebRepo.foodsResponses = [.failure(error)]
        await #expect(throws: error) {
            try await sut.naturalNutrients(query: queryFood)
        }
        mockedWebRepo.verify()
    }
}


final class StubCountriesInteractorTests: FoodsInteractorTests {

    @Test func stubInteractor() async throws {
        let query = "apple"
        let sut = StubFoodsInteractor()
        await #expect(throws: ValueIsMissingError.self) {
            try await sut.searchItem(query: query)
        }
    }
}
