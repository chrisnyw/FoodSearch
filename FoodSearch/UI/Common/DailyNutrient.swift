//
//  DailyNutrient.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-04.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

// Enum representing the daily nutrient values
enum DailyNutrient: String {
    case totalFat = "Total Fat"
    case saturatedFat = "Saturated Fat"
    case cholesterol = "Cholesterol"
    case sodium = "Sodium"
    case potassium = "Potassium"
    case totalCarbohydrates = "Total Carbohydrates"
    case dietaryFiber = "Dietary Fiber"
    case totalSugars = "Total Sugars"
    case addedSugars = "Added Sugars"
    case protein = "Protein"
    case vitaminD = "Vitamin D"
    case calcium = "Calcium"
    case iron = "Iron"
    case vitaminC = "Vitamin C"
    case vitaminA = "Vitamin A"
    case folate = "Folate"
    
    private static let percentageFormatter: NumberFormatter = {
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.minimumFractionDigits = 0 // Adjust the decimal precision
        percentageFormatter.maximumFractionDigits = 0 // Adjust the decimal precision
        return percentageFormatter
    }()
    
    // Method to get the daily value for each nutrient based on a 2000-calorie diet
    var dailyValue: Double {
        switch self {
        case .totalFat:
            return 65.0  // in grams
        case .saturatedFat:
            return 20.0  // in grams
        case .cholesterol:
            return 300.0 // in milligrams
        case .sodium:
            return 2300.0 // in milligrams
        case .potassium:
            return 4700.0 // in milligrams
        case .totalCarbohydrates:
            return 300.0  // in grams
        case .dietaryFiber:
            return 25.0  // in grams
        case .totalSugars:
            return 0.0   // Typically not given a daily value, but could be calculated
        case .addedSugars:
            return 50.0  // in grams (recommended limit for added sugars)
        case .protein:
            return 50.0  // in grams
        case .vitaminD:
            return 20.0  // in micrograms (mcg)
        case .calcium:
            return 1000.0 // in milligrams
        case .iron:
            return 18.0  // in milligrams
        case .vitaminC:
            return 90.0  // in milligrams
        case .vitaminA:
            return 900.0 // in micrograms (mcg)
        case .folate:
            return 400.0 // in micrograms (mcg)
        }
    }
    
    // Method to get the unit for each nutrient
    var unit: String {
        switch self {
        case .totalFat, .saturatedFat, .totalCarbohydrates, .dietaryFiber, .protein:
            return "g"  // grams
        case .cholesterol, .sodium, .potassium, .calcium, .iron, .vitaminC:
            return "mg"  // milligrams
        case .vitaminD, .vitaminA, .folate:
            return "mcg"  // micrograms
        case .totalSugars, .addedSugars:
            return "g"  // grams
        }
    }
    
    func dailyValuePercentage(with input: Double) -> Double {
        return input / self.dailyValue
    }
    
    func dailyValuePercentageStringOutput(with input: Double?) -> String? {
        guard let input else { return nil }
        return DailyNutrient.percentageFormatter
            .string(
                from: NSNumber(
                    value: self.dailyValuePercentage(with: input)
                )
            )
    }
    
    // A method to print the nutrient name and its daily value
    func printDailyValue() {
        print("\(self.rawValue): \(dailyValue) \(unit)")
    }
}
