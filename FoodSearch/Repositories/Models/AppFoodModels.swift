//
//  AppFoodModels.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

struct AppFoodItem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.foodType)
        hasher.combine(self.foodName)
        hasher.combine(self.calories)
        hasher.combine(self.imagePath)
        hasher.combine(self.nixItemId)
    }
    
    static func == (lhs: AppFoodItem, rhs: AppFoodItem) -> Bool {
        return lhs.foodType == rhs.foodType && lhs.foodName == rhs.foodName && lhs.imagePath == rhs.imagePath && lhs.nixItemId == rhs.nixItemId && lhs.calories == rhs.calories
    }
    
    let foodType: AppFoodType
    let foodName: String
    let calories: Double?
    let imagePath: String
    let nixItemId: String?
    let apiFoodItem: ApiModel.Food?
}

enum AppFoodType: Hashable {
    case common
    case branded
    
    var title: String {
        switch self {
        case .common:
            return "Common Foods"
        case .branded:
            return "Branded Foods"
        }
    }
}
