//
//  FoodInteractor.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-30.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Intents
import os.log

protocol FoodsInteractor {
    func naturalNutrients(query: String) async throws -> [ApiModel.Food]
    func searchItem(query: String) async throws -> [ApiModel.Food]
    func donateInteraction(_ searchFoodInput: SearchFoodInput)
    
    func search(searchFoodInput: SearchFoodInput) async throws -> [AppFoodType: [AppFoodItem]]
}

struct RealFoodsInteractor: FoodsInteractor {

    let webRepository: FoodWebRepository

    func naturalNutrients(query: String) async throws -> [ApiModel.Food] {
        return try await webRepository.naturalNutrients(query: query)
    }
    
    func searchItem(query: String) async throws -> [ApiModel.Food] {
        return try await webRepository.searchItem(query: query)
    }
    
    func donateInteraction(_ searchFoodInput: SearchFoodInput) {
        let interaction = INInteraction(intent: searchFoodInput.intent, response: nil)
        
        interaction.identifier = searchFoodInput.id.uuidString
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    Logger().debug("Interaction donation failed: \(error)")
                }
            } else {
                Logger().debug("Successfully donated interaction")
            }
        }
    }
    
    func search(searchFoodInput: SearchFoodInput) async throws -> [AppFoodType: [AppFoodItem]] {
        let results = try await self.webRepository.searchInstant(query: searchFoodInput.foodName)
        let commondFoodNames = results[.common]?.compactMap{ $0.foodName } ?? []
        let commondFoodItems = try await self.webRepository
            .naturalNutrients(query: commondFoodNames.joined(separator: ", "))
            .appFoodItems(foodType: .common)
        
        let brandedFoodItems = results[.branded]?
            .appFoodItems(foodType: .branded) ?? []
        
        // TODO: .save all results to local DB for caching
        
        let filter = { (food: AppFoodItem) -> Bool in
            switch searchFoodInput.comparative {
            case .more:
                return food.calories ?? 0 > Double(searchFoodInput.calories)
            case .less:
                return food.calories ?? Double(Int.max) < Double(searchFoodInput.calories)
            }
        }
        
        return [
            .common: commondFoodItems.filter(filter),
            .branded: brandedFoodItems.filter(filter)
        ]
    }
}

struct StubFoodsInteractor: FoodsInteractor {

    func naturalNutrients(query: String) async throws -> [ApiModel.Food] {
        return []
    }
    
    func searchItem(query: String) async throws -> [ApiModel.Food] {
        throw ValueIsMissingError()
    }
    
    func donateInteraction(_ searchFoodInput: SearchFoodInput) {
    }
    
    func search(searchFoodInput: SearchFoodInput) async throws -> [AppFoodType: [AppFoodItem]] {
        return [:]
    }

}
