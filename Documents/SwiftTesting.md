# Using the latest Swift Testing framework to run unit tests

## Introduction

The Swift Testing Framework introduces a more structured and expressive way to define and organize tests. Unlike XCTest, it does not require subclassing XCTestCase, making it more Swift-friendly. It improves upon XCTest by making tests **simpler, faster, and easier to read**.

## Prerequisites
- Xcode 16 or later
- Swift 6 or later
- iOS 18 or later

## Summary of Swift Testing Annotations
This the summary of the annotations in the latest Swift Testing framework
| Annotation     | Purpose |
|---------------|---------|
| `@Suite`      | Defines a test suite (group of related tests). |
| `@Test`       | Marks a function as a test case. |

## Demostration
Refernce to [FoodsInteractorTests](../UnitTests/Mocks/Interactors/FoodsInteractorTests.swift) for the sample usages of the Swift Testing basic `@Suite` and `@Test` annotations. There are serveral unit tests to demonstrate how to mock the data and services to test out the functions written in `FoodsInteractorTests`.

Here is one sample from the unit tests class:
```swift
final class NaturalNutrientsFoodsListTests: FoodsInteractorTests {

    @Test func happyPath() async throws {
        let foods = ApiModel.Food.mockedData
        let queryFood = foods.first!.foodName
        self.mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        self.mockedWebRepo.foodsResponses = [.success(foods)]
        let result = try await self.sut.naturalNutrients(query: queryFood)
        #expect(result == foods)
        self.mockedWebRepo.verify()
    }

    @Test func webFailure() async throws {
        let queryFood = "pizza"
        mockedWebRepo.actions = .init(expected: [
            .naturalNutrients(queryFood)
        ])
        let error = NSError.test
        mockedWebRepo.foodsResponses = [.failure(error)]
        await #expect(throws: error) {
            try await sut.naturalNutrients(query: queryFood)
        }
        mockedWebRepo.verify()
    }
}
```

## References
- [Swift Testing Framework](https://developer.apple.com/documentation/testing)
- [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)
