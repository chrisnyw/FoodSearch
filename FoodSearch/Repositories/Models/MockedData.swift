//
//  MockedData.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-11.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

#if DEBUG

@MainActor
extension Dictionary where Key == AppFoodType, Value == [AppFoodItem] {
    static let mockedData: [AppFoodType: [AppFoodItem]] = [
        .common: ApiModel.FoodItem.mockedCommonData.appFoodItems(foodType: .common),
        .branded: ApiModel.FoodItem.mockedBrandedData.appFoodItems(foodType: .branded)
    ]
}


@MainActor
extension ApiModel.FoodInstantResponse {
    static let mockedData: ApiModel.FoodInstantResponse = ApiModel.FoodInstantResponse(
        common: ApiModel.FoodItem.mockedCommonData,
        branded: ApiModel.FoodItem.mockedBrandedData
    )
}

@MainActor
extension ApiModel.FoodItem {
    
    static let mockedCommonData: [ApiModel.FoodItem] = [
        ApiModel.FoodItem(
            foodName: "Hamburger",
            servingUnit: "package",
            tagName: nil,
            servingQty: 1,
            commonType: nil,
            tagId: nil,
            photo: ApiModel.Photo(thumb: "https://nutritionix-api.s3.amazonaws.com/568f4b10083fff691b4b5ceb.jpeg", highres: nil, isUserUploaded: nil),
            locale: "en_US",
            nixBrandId: "53d0085ffdb35bcf368daf5f",
            brandNameItemName: "Nutrisystem Hamburger",
            nfCalories: 250,
            brandName: "Nutrisystem",
            region: 1,
            brandType: 2,
            nixItemId: "568f492249afd8157ea42853"
        )
    ]
    
    static let mockedBrandedData: [ApiModel.FoodItem] = [
        ApiModel.FoodItem(
            foodName: "Hamburger Buns, Enriched",
            servingUnit: "bun",
            tagName: nil,
            servingQty: 1,
            commonType: nil,
            tagId: nil,
            photo: ApiModel.Photo(thumb: "https://nutritionix-api.s3.amazonaws.com/536020b12ae36a5775c0a4da.jpeg", highres: nil, isUserUploaded: nil),
            locale: "en_US",
            nixBrandId: "51db37b1176fe9790a898466",
            brandNameItemName: "Great Value Hamburger Buns, Enriched",
            nfCalories: 250,
            brandName: "Great Value",
            region: 1,
            brandType: 2,
            nixItemId: "51c54cc997c3e6efadd61910"
        )
    ]
    
    static func mockFoodItem(foodName: String, calories: Double) -> ApiModel.FoodItem {
        ApiModel.FoodItem(
            foodName: foodName,
            servingUnit: "mock unit",
            tagName: nil,
            servingQty: 1,
            commonType: nil,
            tagId: nil,
            photo: ApiModel.Photo(thumb: "https://nutritionix-api.s3.amazonaws.com/536020b12ae36a5775c0a4da.jpeg", highres: nil, isUserUploaded: nil),
            locale: "en_US",
            nixBrandId: "mockBrandId",
            brandNameItemName: "mockBrandName",
            nfCalories: calories,
            brandName: "mockBrandName",
            region: 1,
            brandType: 2,
            nixItemId: "mockItemId"
        )
    }
}

@MainActor
extension ApiModel.FoodResponse {
    static let mockedData: ApiModel.FoodResponse = ApiModel.FoodResponse(
        foods: ApiModel.Food.mockedData
    )
}

@MainActor
extension ApiModel.Food {
    
    static let mockedData: [ApiModel.Food] = [
        ApiModel.Food(
            foodName: "hamburger buns",
            brandName: nil,
            servingQty: 1,
            servingUnit: "hamburger bun",
            servingWeightGrams: 46,
            nfCalories: 127.88,
            nfTotalFat: 1.73,
            nfSaturatedFat: 0.41,
            nfCholesterol: 0,
            nfSodium: 230,
            nfTotalCarbohydrate: 23.07,
            nfDietaryFiber: 0.97,
            nfSugars: 2.93,
            nfProtein: 4.54,
            nfPotassium: 58.42,
            nfP: 49.22,
            fullNutrients: [ApiModel.FullNutrient(attrId: 203, value: 4.5402),
                            ApiModel.FullNutrient(attrId: 204, value: 1.7296)],
            consumedAt: "2025-02-11T23:58:18+00:00",
            metadata: ApiModel.Metadata(isRawFood: false),
            source: 1,
            ndbNo: 18350,
            tags: ApiModel.FoodTags(item: "hamburger bun", measure: nil, quantity: "1.0", foodGroup: 5, tagId: 226),
            altMeasures: [
                ApiModel.AltMeasure(servingWeight: 44, measure: "roll 1 serving", seq: 1, qty: 1),
                ApiModel.AltMeasure(servingWeight: 28.35, measure: "oz", seq: 2, qty: 1)
            ],
            photo: ApiModel.Photo(thumb: "https://nix-tag-images.s3.amazonaws.com/226_thumb.jpg", highres: "https://nix-tag-images.s3.amazonaws.com/226_highres.jpg", isUserUploaded: false),
            subRecipe: nil
        )
    ]
    
    static func mockFood(foodName: String, calories: Double) -> ApiModel.Food {
        ApiModel.Food(
            foodName: foodName,
            brandName: nil,
            servingQty: 1,
            servingUnit: "mock unit",
            servingWeightGrams: 46,
            nfCalories: calories,
            nfTotalFat: 1.73,
            nfSaturatedFat: 0.41,
            nfCholesterol: 0,
            nfSodium: 230,
            nfTotalCarbohydrate: 23.07,
            nfDietaryFiber: 0.97,
            nfSugars: 2.93,
            nfProtein: 4.54,
            nfPotassium: 58.42,
            nfP: 49.22,
            fullNutrients: [ApiModel.FullNutrient(attrId: 203, value: 4.5402),
                            ApiModel.FullNutrient(attrId: 204, value: 1.7296)],
            consumedAt: "2025-02-11T23:58:18+00:00",
            metadata: ApiModel.Metadata(isRawFood: false),
            source: 1,
            ndbNo: 18350,
            tags: ApiModel.FoodTags(item: foodName, measure: nil, quantity: "1.0", foodGroup: 5, tagId: 226),
            altMeasures: [
                ApiModel.AltMeasure(servingWeight: 44, measure: "roll 1 serving", seq: 1, qty: 1),
                ApiModel.AltMeasure(servingWeight: 28.35, measure: "oz", seq: 2, qty: 1)
            ],
            photo: ApiModel.Photo(thumb: "https://nix-tag-images.s3.amazonaws.com/226_thumb.jpg", highres: "https://nix-tag-images.s3.amazonaws.com/226_highres.jpg", isUserUploaded: false),
            subRecipe: nil
        )
    }
    
    var foodItem: ApiModel.FoodItem {
        ApiModel.FoodItem(
            foodName: self.foodName,
            servingUnit: self.servingUnit,
            tagName: nil,
            servingQty: self.servingQty,
            commonType: nil,
            tagId: nil,
            photo: self.photo,
            locale: "en_US",
            nixBrandId: nil,
            brandNameItemName: nil,
            nfCalories: self.nfCalories,
            brandName: self.brandName,
            region: nil,
            brandType: nil,
            nixItemId: nil
        )
    }
    
}

#endif
