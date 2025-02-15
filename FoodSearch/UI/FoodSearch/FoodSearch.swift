//
//  FoodSearch.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-30.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import SwiftUI
import Combine

struct FoodSearch: View {
    @Environment(\.injected) private var injected: DIContainer
    
    @State private var details: Loadable<[AppFoodType: [AppFoodItem]]>
    @State private var routingState: Routing = .init()
    
    @State private var searchText = ""
    @State private var comparative: ComparativeTypeAppEnum = .less
    @State private var calories: Int = 400
    @State private var searchFoodItem: SearchFoodInput?
    
    init(state: Loadable<[AppFoodType: [AppFoodItem]]> = .notRequested) {
        self._details = .init(initialValue: state)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(
                    text: $searchText,
                    comparative: $comparative,
                    calories: $calories,
                    onSearch: {
                        fetchFoods(donateIntent: true)
                    }
                )
                
                content
                    .navigationTitle("Food Search")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onReceive(routingUpdate) { self.routingState = $0 }
        .onChange(of: routingState.searchFoodInput, { _, input in
            guard let input else { return }
            self.searchText = input.foodName
            self.comparative = input.comparative
            self.calories = input.calories
            print("received intent update for: \(input)")
            self.fetchFoods()
            self.injected.appState[\.routing.foodSearch.searchFoodInput] = nil
        })

    }
    
    @ViewBuilder private var content: some View {
        switch details {
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
    
    private var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.foodSearch)
    }

}

// MARK: - Routing

extension FoodSearch {
    struct Routing: Equatable {
        var searchFoodInput: SearchFoodInput?
    }
}

// MARK: - Displaying Content

private extension FoodSearch {
    func defaultView() -> some View {
        Text("type something and search")
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
            self.fetchFoods()
        })
    }
    
    @ViewBuilder func loadedView(_ foods: [AppFoodType: [AppFoodItem]]) -> some View {
        if foods.isEmpty {
            Text("No food found")
        } else {
            List {
                ForEach(Array(foods.keys), id: \.self) { key in
                    Section(header: Text(key.title).font(.headline)) {
                        ForEach(foods[key]!, id: \.self) { food in
                            NavigationLink(destination: FoodDetailView(foodItem: food)) {
                                HStack {
                                    if let url = URL(string: food.imagePath) {
                                        ImageView(imageURL: url)
                                            .frame(width: 50, height: 50)
                                            .clipShape(.rect(cornerRadius: 5))
                                    }
                                    Text(food.foodName)
                                    Spacer()
                                    Text("\(food.calories ?? 0, specifier: "%.0f") kcal")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension FoodSearch {
    
    private var searchFoodInput: SearchFoodInput {
        return SearchFoodInput(
            foodName: self.searchText,
            comparative: self.comparative,
            calories: self.calories
        )
    }
    
    private func fetchFoods(donateIntent: Bool = false) {
        
        $details.load {
            if donateIntent {
                injected.interactors.foods.donateInteraction(self.searchFoodInput)
            }
            return try await injected.interactors.foods.search(searchFoodInput: self.searchFoodInput)
        }
        
    }

}

struct SearchBar: View {
    @Binding var text: String
    @Binding var comparative: ComparativeTypeAppEnum
    @Binding var calories: Int
    var onSearch: () -> Void
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            TextField("Search for food", text: $text)
                .padding(7)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            Picker("Food Category", selection: $comparative) {
               ForEach(ComparativeTypeAppEnum.allCases) { category in
                    Text(category.rawValue).tag(category)
              }
            }
            .padding(7)
            .pickerStyle(.segmented)
            TextField("calories", value: $calories, formatter: formatter)
                .padding(7)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            Button(action: onSearch) {
                Text("Search")
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
//            HStack {
//                TextField("Search for food", text: $text)
//                    .padding(7)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                
//                Button(action: onSearch) {
//                    Text("Search")
//                        .padding(.horizontal)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.trailing)
//            }
        }
    }
}

