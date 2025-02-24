//
//  IntentHandler.swift
//  FoodIntent
//
//  Created by Chris Ng on 2025-01-31.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is SearchFoodIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return SearchFoodIntentHandler()
    }
}
