//
//  FoodWebRepository.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-30.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation

protocol FoodWebRepository: WebRepository {
    func naturalNutrients(query: String) async throws -> [ApiModel.Food]
    func searchInstant(query: String) async throws -> [AppFoodType: [ApiModel.FoodItem]] 
    func searchItem(query: String) async throws -> [ApiModel.Food]
}

struct RealFoodWebRepository: FoodWebRepository {

    let session: URLSession
    let baseURL: String

    init(session: URLSession) {
        self.session = session
        self.baseURL = "https://trackapi.nutritionix.com/v2"
    }
    
    func naturalNutrients(query: String) async throws -> [ApiModel.Food] {
        let response: ApiModel.FoodResponse = try await self.call(endpoint: API.neturalNutrients(query: query))
        return response.foods
    }

    func searchInstant(query: String) async throws -> [AppFoodType: [ApiModel.FoodItem]] {
        let response: ApiModel.FoodInstantResponse = try await self.call(endpoint: API.searchInstant(query: query))
        return [
            .common: response.common,
            .branded: response.branded
        ]
    }
    
    func searchItem(query: String) async throws -> [ApiModel.Food] {
        let response: ApiModel.FoodResponse = try await self.call(endpoint: API.searchItem(query: query))
        return response.foods
    }
}

// MARK: - Endpoints

extension RealFoodWebRepository {
    enum API {
        case neturalNutrients(query: String)
        case searchInstant(query: String)
        case searchItem(query: String)
    }
}

extension RealFoodWebRepository.API: APICall {
    // obtain KEY from here: https://docx.syndigo.com/developers/docs/obtaining-api-keys-and-authenticating-api
    #error("Please set your own appID and apiKey, then remove this line")
    private static let appID = "USE_YOUR_OWN_APP_ID"
    private static let apiKey = "USE_YOUR_OWN_API_KEY"
    
    private func encodeString(_ string: String) -> String {
        // Define the allowed characters for the query string (excluding characters like space, &, etc.)
        let allowedCharacters = CharacterSet.urlQueryAllowed

        // Encode the string
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            return string
        }
        return encodedString
    }
    
    var path: String {
        switch self {
        case .neturalNutrients:
            return "/natural/nutrients"
        case let .searchInstant(query):
            return "/search/instant/?query=\(self.encodeString(query))"
        case let .searchItem(query):
            return "/search/item/?nix_item_id=\(self.encodeString(query))"
        }
    }
    var method: String {
        switch self {
        case .neturalNutrients:
            return "POST"
        case .searchInstant,
                .searchItem:
            return "GET"
        }
    }
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "x-app-id": Self.appID,
            "x-app-key": Self.apiKey
        ]
    }
    func body() throws -> Data? {
        switch self {
        case let .neturalNutrients(query):
            let body = ["query": query]
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            return jsonData
        case .searchInstant,
                .searchItem:
            return nil
        }
    }
}
