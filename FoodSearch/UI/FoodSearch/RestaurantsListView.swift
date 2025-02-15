//
//  RestaurantsListView.swift
//  Food Search
//
//  Created by Chris Ng on 2025-02-07.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import SwiftUI

struct RestaurantsList: View {
    typealias RestaurantsLoadable = [String]
    
    @Environment(\.injected) private var injected: DIContainer
    
    @State private var restaurants: Loadable<RestaurantsLoadable>
    
    private var foodName: String
    
    init(
        foodName: String,
        state: Loadable<RestaurantsLoadable> = .notRequested
    ) {
        self.foodName = foodName
        self._restaurants = .init(initialValue: state)
    }
    
    var body: some View {
        content
    }
    
    
    @ViewBuilder private var content: some View {
        switch restaurants {
        case .notRequested:
            defaultView()
        case .isLoading:
            loadingView()
        case let .loaded(foods):
            loadedView(foods)
        case let .failed(error):
            failedView(error)
        }
    }
}
    
// MARK: - Displaying Content

private extension RestaurantsList {
    func defaultView() -> some View {
        Text("Searching nearyby restaurants...").onAppear {
            self.loadRestaurants()
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Button(action: {
                self.restaurants.cancelLoading()
            }, label: { Text("Cancel loading") })
        }
    }
    
    func failedView(_ error: Error) -> some View {
        
        ErrorView(error: error, retryAction: {
            self.loadRestaurants()
        })
    }
    
    @ViewBuilder func loadedView(_ restaurants: RestaurantsLoadable) -> some View {
        if restaurants.isEmpty {
            Text("No restaurants found near you")
        } else {
            VStack(alignment: .leading) {
                Text("Here is the list of nearby restaurants:")
                    .fontWeight(.bold)
                ForEach(restaurants, id: \.self) { restaurant in
                    Divider()
                    Text(restaurant)
                }
            }
        }
    }
}

private extension RestaurantsList {
    func loadRestaurants() {
        self.$restaurants.load {
            try await injected.interactors.restaurants.fetchNearbyRestaurants(food: foodName)
            
//            switch self.foodItem.foodType {
//            case .common:
//                if let foodItem = self.foodItem.apiFoodItem {
//                    return [foodItem]
//                }
//                return try await self.injected.interactors.foods.naturalNutrients(query: query)
//            case .branded:
//                if let nixItemID = self.foodItem.nixItemId {
//                    return try await self.injected.interactors.foods.searchItem(query: nixItemID)
//                }
//                throw APIError.unexpectedResponse
//            }
            
        }
    }
}
