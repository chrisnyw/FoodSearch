//
//  FoodDetailView.swift
//  FoodSearch
//
//  Created by Chris Ng on 2025-02-04.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import SwiftUI

struct FoodDetailView: View {
    //    • Food detail:
    //    • Nutrition info/label
    //    • Ingredients
    //    • Nearby restaurants (if any) in mapview or listview
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var restaurants: [String]?
    @State private var details: Loadable<[ApiModel.Food]>
    
    private let foodItem: AppFoodItem
    
    init(foodItem: AppFoodItem, details: Loadable<[ApiModel.Food]> = .notRequested) {
        self.foodItem = foodItem
        self._details = .init(initialValue: details)
    }
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        switch details {
        case .notRequested:
            defaultView()
        case .isLoading:
            loadingView()
        case let .loaded(foods):
            if let food = foods.first {
                loadedView(food)
            } else {
                failedView(APIError.unexpectedResponse)
            }
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Displaying Content

private extension FoodDetailView {
    func defaultView() -> some View {
        Text("").onAppear {
            loadFoodDetails(query: self.foodItem.foodName)
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Button(action: {
                self.details.cancelLoading()
            }, label: { Text("Cancel loading") })
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.loadFoodDetails(query: self.foodItem.foodName)
        })
    }
    
    func loadedView(_ food: ApiModel.Food) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(food.foodName)
                    .font(.title)
                    .bold()
                
                if let url = URL(string: food.photo.thumb) {
                    ImageView(imageURL: url)
                        .clipShape(.rect(cornerRadius: 5))
                }
                
                Spacer()
                
                NutritionFactsView(food: food)
                
                HStack {
                    Text("Ingradients:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(String(describing: food.subRecipe))")
                }
                
                RestaurantsList(foodName: food.foodName)
            }
            .padding()
            .navigationTitle("Food Details")
        }
    }
}

private extension FoodDetailView {
    func loadFoodDetails(query: String) {
        self.$details.load {
            switch self.foodItem.foodType {
            case .common:
                if let foodItem = self.foodItem.apiFoodItem {
                    return [foodItem]
                }
                return try await self.injected.interactors.foods.naturalNutrients(query: query)
            case .branded:
                if let nixItemID = self.foodItem.nixItemId {
                    return try await self.injected.interactors.foods.searchItem(query: nixItemID)
                }
                throw APIError.unexpectedResponse
            }
            
        }
    }
}

struct NutritionFactsView: View {
    let food: ApiModel.Food
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Nutrition Facts")
                .font(.largeTitle)
                .fontWeight(.bold)

            Divider().frame(height: 1).overlay(.black)
            Divider().frame(height: 20).overlay(.black)

            VStack(alignment: .leading) {
                Text("Amount Per Serving:")
                HStack {
                    Text("Calories").font(.title).fontWeight(.bold)
                    Spacer()
                    Text(food.nfCalories.toString).font(.largeTitle).fontWeight(.bold)
                }
            }

            Divider().frame(height: 10).overlay(.black)

            VStack(alignment: .leading, spacing: 4) {
                NutritionRow(title: "", value: "", dailyValue: "% Daily Value *")
                NutritionRow(dailyNutrient: .totalFat, value: food.nfTotalFat)
                NutritionRow(indent: true, dailyNutrient: .saturatedFat, value: food.nfSaturatedFat)
                NutritionRow(dailyNutrient: .cholesterol, value: food.nfCholesterol)
                NutritionRow(dailyNutrient: .sodium, value: food.nfSodium)
                NutritionRow(dailyNutrient: .totalCarbohydrates, value: food.nfTotalCarbohydrate)
                NutritionRow(indent: true, dailyNutrient: .dietaryFiber, value: food.nfDietaryFiber)
                NutritionRow(indent: true, dailyNutrient: .addedSugars, value: food.nfSugars)
                NutritionRow(dailyNutrient: .protein, value: food.nfProtein)
            }

            Divider().frame(height: 10).overlay(.black)

            VStack(alignment: .leading, spacing: 4) {
                NutritionRow(dailyNutrient: .potassium, value: food.nfPotassium)
            }

            Divider().frame(height: 10).overlay(.black)

            Text("*The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2000 calories a day is used for general nutrition advice.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 8)
                .fixedSize(horizontal: false, vertical: true)
                
        }
        .padding()
    }
}

struct NutritionRow: View {
    private let indent: Bool
    private let title: String
    private let value: String
    private let dailyValue: String?

    init(indent: Bool = false, title: String, value: String, dailyValue: String? = nil) {
        self.indent = indent
        self.title = title
        self.value = value
        self.dailyValue = dailyValue
    }
    
    init(indent: Bool = false, dailyNutrient: DailyNutrient, value: Double?) {
        self.indent = indent
        self.title = dailyNutrient.rawValue
        let unit = value != nil ? dailyNutrient.unit : ""
        self.value = "\(value.toString)\(unit)"
        self.dailyValue = dailyNutrient.dailyValuePercentageStringOutput(with: value)
    }
    
    var body: some View {
        HStack {
            if self.indent {
                Spacer()
                    .frame(width: 16)
            }
            Text(self.title)
                .fontWeight(self.indent ? .regular : .bold)
            Text(self.value)
            Spacer()
            if let dailyValue = self.dailyValue {
                Text(dailyValue)
                    .foregroundColor(.gray)
            }
        }
        .font(.body)
    }
}

extension Optional where Wrapped == Double {
    var toString: String {
        guard let unwrappedValue = self else {
            return ""
        }
        return "\(unwrappedValue)"
    }
}
