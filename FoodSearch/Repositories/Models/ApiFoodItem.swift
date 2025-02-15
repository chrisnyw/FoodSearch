//
//  ApiFoodItem.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

extension ApiModel {
    // MARK: - Response
    struct FoodInstantResponse: Codable, Equatable {
        let common: [FoodItem]
        let branded: [FoodItem]
    }
    
    // MARK: - FoodItem
    struct FoodItem: Codable, Identifiable, Equatable {
        let id: UUID = UUID()
        let foodName: String
        let servingUnit: String
        let tagName: String?
        let servingQty: Double
        let commonType: Int?
        let tagId: String?
        let photo: Photo
        let locale: String
        let nixBrandId: String?
        let brandNameItemName: String?
        let nfCalories: Double?
        let brandName: String?
        let region: Int?
        let brandType: Int?
        let nixItemId: String?
        
        // To match the JSON keys, use coding keys
        enum CodingKeys: String, CodingKey {
            case foodName = "food_name"
            case servingUnit = "serving_unit"
            case tagName = "tag_name"
            case servingQty = "serving_qty"
            case commonType = "common_type"
            case tagId = "tag_id"
            case photo
            case locale
            case nixBrandId = "nix_brand_id"
            case brandNameItemName = "brand_name_item_name"
            case nfCalories = "nf_calories"
            case brandName = "brand_name"
            case region
            case brandType = "brand_type"
            case nixItemId = "nix_item_id"
        }
    }    
}

extension Array where Element == ApiModel.FoodItem {
    func appFoodItems(foodType: AppFoodType) -> [AppFoodItem] {
        self.compactMap{ $0.appFoodItem(foodType: foodType) }
    }
}

extension ApiModel.FoodItem {
    func appFoodItem(foodType: AppFoodType) -> AppFoodItem {
        AppFoodItem(
            foodType: foodType,
            foodName: self.foodName,
            calories: self.nfCalories,
            imagePath: self.photo.thumb,
            nixItemId: self.nixItemId,
            apiFoodItem: nil
        )
    }
}
