//
//  SearchFood.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-01.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct SearchFood: AppIntent, CustomIntentMigratedAppIntent, PredictableIntent {
    static let intentClassName = "SearchFoodIntent"

    static var title: LocalizedStringResource = "Search Food custom intent"
    static var description = IntentDescription("Search foods or meals from Syndigo food database")
    
    static var openAppWhenRun: Bool = true
    static var isDiscoverable: Bool = true

    @Parameter(title: "Food Name", requestValueDialog: "What food are you looking for?")
    var foodName: String

    @Parameter(title: "more or less?", requestValueDialog: "Are you looking for more or less than?")
    var comparative: ComparativeTypeAppEnum

    @Parameter(title: "Calories", requestValueDialog: "How many calories expected?")
    var calories: Int
    
    @Dependency
    private var injected: DIContainer

    static var parameterSummary: some ParameterSummary {
        Summary("Search '\(\.$foodName)' with \(\.$comparative) \(\.$calories) calories")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$foodName, \.$comparative, \.$calories)) { foodName, comparative, calories in
            DisplayRepresentation(
                title: "\(foodName) with \(comparative) \(calories) calories",
                subtitle: "prediction configuration subtitle"
            )
        }
    }

    func perform() async throws -> some IntentResult {
        print("perform action with searching food: \(foodName) with \(comparative) \(calories) calories")
        
        injected.appState[\.routing.foodSearch.searchFoodInput] = SearchFoodInput(from: self)
        
        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
fileprivate extension IntentDialog {
    static func responseSuccess(food: String) -> Self {
        "search \(food) success"
    }
    static func responseFailure(food: String) -> Self {
        "search \(food) failed"
    }
}
