//
//  AppSchema.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-31.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import SwiftData

enum DBModel { }

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
        ], version: actualVersion)
    }
}
