//
//  APIFood.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

extension ApiModel {
    // Model for the full response
    struct FoodResponse: Codable {
        let foods: [Food]
    }
    
    // Model for a food item
    struct Food: Codable, Identifiable, Equatable {
        let id: UUID = UUID()
        
        let foodName: String
        let brandName: String?
        let servingQty: Double
        let servingUnit: String
        let servingWeightGrams: Double?
        let nfCalories: Double?
        let nfTotalFat: Double?
        let nfSaturatedFat: Double?
        let nfCholesterol: Double?
        let nfSodium: Double?
        let nfTotalCarbohydrate: Double?
        let nfDietaryFiber: Double?
        let nfSugars: Double?
        let nfProtein: Double?
        let nfPotassium: Double?
        let nfP: Double?
        let fullNutrients: [FullNutrient]
        let consumedAt: String?
        let metadata: Metadata?
        let source: Int?
        let ndbNo: Int?
        let tags: FoodTags?
        let altMeasures: [AltMeasure]?
        let photo: Photo
        let subRecipe: String?
        
        // Coding keys to match the JSON keys
        enum CodingKeys: String, CodingKey {
            case foodName = "food_name"
            case brandName = "brand_name"
            case servingQty = "serving_qty"
            case servingUnit = "serving_unit"
            case servingWeightGrams = "serving_weight_grams"
            case nfCalories = "nf_calories"
            case nfTotalFat = "nf_total_fat"
            case nfSaturatedFat = "nf_saturated_fat"
            case nfCholesterol = "nf_cholesterol"
            case nfSodium = "nf_sodium"
            case nfTotalCarbohydrate = "nf_total_carbohydrate"
            case nfDietaryFiber = "nf_dietary_fiber"
            case nfSugars = "nf_sugars"
            case nfProtein = "nf_protein"
            case nfPotassium = "nf_potassium"
            case nfP = "nf_p"
            case fullNutrients = "full_nutrients"
            case consumedAt = "consumed_at"
            case metadata
            case source
            case ndbNo = "ndb_no"
            case tags
            case altMeasures = "alt_measures"
            case photo
            case subRecipe = "sub_recipe"
        }
    }
    
    // Full nutrient information
    struct FullNutrient: Codable, Equatable {
        let attrId: Int?
        let value: Double?
        
        enum CodingKeys: String, CodingKey {
            case attrId = "attr_id"
            case value
        }
    }
    
    // Metadata
    struct Metadata: Codable, Equatable {
        let isRawFood: Bool?
        
        enum CodingKeys: String, CodingKey {
            case isRawFood = "is_raw_food"
        }
    }
    
    // Tags for the food
    struct FoodTags: Codable, Equatable {
        let item: String?
        let measure: String?
        let quantity: String?
        let foodGroup: Int?
        let tagId: Int?
        
        enum CodingKeys: String, CodingKey {
            case item
            case measure
            case quantity
            case foodGroup = "food_group"
            case tagId = "tag_id"
        }
    }
    
    // Alternate measures for the food
    struct AltMeasure: Codable, Equatable {
        let servingWeight: Double?
        let measure: String?
        let seq: Int?
        let qty: Double?
        
        enum CodingKeys: String, CodingKey {
            case servingWeight = "serving_weight"
            case measure
            case seq
            case qty
        }
    }
    
    // Photo information for the food
    struct Photo: Codable, Equatable {
        let thumb: String
        let highres: String?
        let isUserUploaded: Bool?
        
        enum CodingKeys: String, CodingKey {
            case thumb
            case highres
            case isUserUploaded = "is_user_uploaded"
        }
    }
}

extension Array where Element == ApiModel.Food {
    func appFoodItems(foodType: AppFoodType) -> [AppFoodItem] {
        self.compactMap{ $0.appFoodItem(foodType: foodType) }
    }
}

extension ApiModel.Food {
    func appFoodItem(foodType: AppFoodType) -> AppFoodItem {
        AppFoodItem(
            foodType: foodType,
            foodName: self.foodName,
            calories: self.nfCalories,
            imagePath: self.photo.thumb,
            nixItemId: nil,
            apiFoodItem: self
        )
    }
}
