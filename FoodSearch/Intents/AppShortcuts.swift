//
//  AppShortcuts.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-01.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import AppIntents

// MARK: - App Shortcuts
struct AppShortcuts: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SearchFood(),
            phrases: [
                "Open \(.applicationName) with input"
            ],
            shortTitle: "Find Food Nutrition Info",
            systemImageName: "fork.knife"
        )
    }
    
}
