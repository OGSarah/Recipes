//
// FavoriteRecipeMappingTests.swift
// Recipes
//
// MIT License
//
// Copyright (c) 2026 SarahUniverse
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

// These tests cover the `FavoriteRecipe` ⇄ `MealDetail` mapping (the parallel-array
// ingredient flattening and reconstruction), which is the custom persistence logic.
//
// The `SwiftDataFavoritesStore` itself drives a real `ModelContainer`; that path is exercised
// end-to-end in the running app, but a SwiftData `fetch` against a `@testable`-imported
// `@Model` traps inside the app-hosted test bundle on the current iOS 27 toolchain, so the
// store's CRUD is not unit-tested here. The favorites *flow* is covered by
// `FavoritesViewModelTests` and `RecipeDetailViewModelTests` via a mock store.
//
// XCTest (not Swift Testing) is used because `FavoriteRecipe` is `@MainActor`, and an
// app-hosted Swift Testing suite isolated to a global actor crashes the runner on this toolchain.

import XCTest
@testable import Recipes

final class FavoriteRecipeMappingTests: XCTestCase {
    @MainActor
    func testMealDetailRoundTripsThroughFavoriteRecipe() {
        let meal = MealDetail(
            id: "52772",
            name: "Carbonara",
            category: "Pasta",
            area: "Italian",
            instructions: "Cook.",
            thumbnailURL: URL(string: "https://example.com/thumb.jpg"),
            youtubeURL: URL(string: "https://youtube.com/watch?v=abc"),
            sourceURL: URL(string: "https://example.com/recipe"),
            tags: ["Comfort", "Pasta"],
            ingredients: [
                Ingredient(id: 1, name: "Spaghetti", measure: "200g"),
                Ingredient(id: 2, name: "Pepper", measure: nil)
            ]
        )

        let restored = FavoriteRecipe(meal: meal).asMealDetail

        XCTAssertEqual(restored.id, "52772")
        XCTAssertEqual(restored.name, "Carbonara")
        XCTAssertEqual(restored.category, "Pasta")
        XCTAssertEqual(restored.area, "Italian")
        XCTAssertEqual(restored.thumbnailURL, meal.thumbnailURL)
        XCTAssertEqual(restored.youtubeURL, meal.youtubeURL)
        XCTAssertEqual(restored.sourceURL, meal.sourceURL)
        XCTAssertEqual(restored.tags, ["Comfort", "Pasta"])
        XCTAssertEqual(restored.ingredients.count, 2)
        XCTAssertEqual(restored.ingredients[0].name, "Spaghetti")
        XCTAssertEqual(restored.ingredients[0].measure, "200g")
    }

    @MainActor
    func testEmptyMeasureRoundTripsAsNil() {
        let meal = MealDetail(
            id: "1",
            name: "Toast",
            ingredients: [Ingredient(id: 1, name: "Bread", measure: nil)]
        )

        let restored = FavoriteRecipe(meal: meal).asMealDetail

        XCTAssertEqual(restored.ingredients.count, 1)
        XCTAssertEqual(restored.ingredients.first?.name, "Bread")
        XCTAssertNil(restored.ingredients.first?.measure)
    }

    @MainActor
    func testNilOptionalFieldsRoundTrip() {
        let meal = MealDetail(id: "9", name: "Bare")

        let restored = FavoriteRecipe(meal: meal).asMealDetail

        XCTAssertNil(restored.category)
        XCTAssertNil(restored.area)
        XCTAssertNil(restored.thumbnailURL)
        XCTAssertNil(restored.youtubeURL)
        XCTAssertNil(restored.sourceURL)
        XCTAssertTrue(restored.tags.isEmpty)
        XCTAssertTrue(restored.ingredients.isEmpty)
    }
}
