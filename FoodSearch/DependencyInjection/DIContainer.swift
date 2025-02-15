//
//  DIContainer.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-30.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import SwiftUI
import SwiftData

struct DIContainer: @unchecked Sendable {

    let appState: Store<AppState>
    let interactors: Interactors

    init(appState: Store<AppState> = .init(AppState()), interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }

    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
}

extension DIContainer {
    struct WebRepositories {
        let images: ImagesWebRepository
        let foods: FoodWebRepository
        let restaurants: RestaurantsWebRepository
    }
    struct DBRepositories {
    }
    struct Interactors {
        let images: ImagesInteractor
        let foods: FoodsInteractor
        let restaurants: RestaurantInteractor

        static var stub: Self {
            .init(
                images: StubImagesInteractor(),
                foods: StubFoodsInteractor(),
                restaurants: StubRestaurantInteractor()
            )
        }
    }
}

extension EnvironmentValues {
    @Entry var injected: DIContainer = DIContainer(appState: AppState(), interactors: .stub)
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
