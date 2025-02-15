//
//  SearchFoodIntentHandler.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-31.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation
import Intents

public class SearchFoodIntentHandler: NSObject, SearchFoodIntentHandling {
    public func resolveFoodName(for intent: SearchFoodIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let food = intent.foodName else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: food))
    }
    
    public func resolveComparative(for intent: SearchFoodIntent, with completion: @escaping (ComparativeTypeResolutionResult) -> Void) {
        if intent.comparative == .unknown {
            completion(ComparativeTypeResolutionResult.needsValue())
        } else {
            completion(ComparativeTypeResolutionResult.success(with: intent.comparative))
        }
    }
        
    public func resolveCalories(for intent: SearchFoodIntent, with completion: @escaping (SearchFoodCaloriesResolutionResult) -> Void) {
        guard let calories = intent.calories else {
            completion(SearchFoodCaloriesResolutionResult.needsValue())
            return
        }
        
        completion(SearchFoodCaloriesResolutionResult.success(with: calories.intValue))
    }
    
    public func handle(intent: SearchFoodIntent, completion: @escaping (SearchFoodIntentResponse) -> Void) {
        let foodName = intent.foodName
        let moreOrLess = intent.comparative
        let calories = intent.calories

        // Perform action based on the event data (e.g., start a timer, schedule, etc.)
        print("Starting event: \(foodName) with \(moreOrLess) than \(calories) calories")

        // Respond back to Siri
        let response = SearchFoodIntentResponse.success(food: foodName ?? "error")
    
        completion(response)
    }
}
