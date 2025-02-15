//
//  ComparativeTypeAppEnum.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-05.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
enum ComparativeTypeAppEnum: String, AppEnum, Identifiable {
    var id: Int {
        self.hashValue
     }
    
    case more = "more than"
    case less = "less than"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Comparative")
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .more: "more than",
        .less: "less than"
    ]
}

extension ComparativeTypeAppEnum {
    var intentEnum: ComparativeType {
        switch self {
        case .more:
            return .more
        case .less:
            return .less
        }
    }
}
