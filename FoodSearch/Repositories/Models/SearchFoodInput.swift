//
//  SearchFoodInput.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

struct SearchFoodInput: Equatable, Identifiable {
    let id: UUID = UUID()
    let foodName: String
    let comparative: ComparativeTypeAppEnum
    let calories: Int
}

extension SearchFoodInput {
    var intent: SearchFoodIntent {
        let searchFoodIntent = SearchFoodIntent()
        searchFoodIntent.foodName = self.foodName
        searchFoodIntent.comparative = self.comparative.intentEnum
        searchFoodIntent.calories = NSNumber(integerLiteral: self.calories)
        
        return searchFoodIntent
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
extension SearchFoodInput {
    
    init(from entity: SearchFood) {
        self.init(
            foodName: entity.foodName,
            comparative: entity.comparative,
            calories: entity.calories
        )
    }
}
