//
// RecipeDetailViewModelTests.swift
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

import XCTest
@testable import Recipes

final class RecipeDetailViewModelTests: XCTestCase {
    @MainActor
    func testSummarySourceLooksUpDetail() async {
        let provider = MockRecipeProvider()
        provider.detailToReturn = .sample(id: "52772", name: "Looked Up")
        let model = RecipeDetailViewModel(
            source: .summary(MealSummary(id: "52772", name: "Stub")),
            provider: provider,
            store: MockFavoritesStore()
        )

        await model.load()

        XCTAssertEqual(provider.lastLookupID, "52772")
        XCTAssertEqual(model.detail?.name, "Looked Up")
    }

    @MainActor
    func testDetailSourceSkipsLookup() async {
        let provider = MockRecipeProvider()
        let model = RecipeDetailViewModel(
            source: .detail(.sample(id: "1", name: "In Hand")),
            provider: provider,
            store: MockFavoritesStore()
        )

        await model.load()

        XCTAssertNil(provider.lastLookupID)
        XCTAssertEqual(model.detail?.name, "In Hand")
    }

    @MainActor
    func testToggleFavoriteAddsThenRemoves() async {
        let store = MockFavoritesStore()
        let model = RecipeDetailViewModel(
            source: .detail(.sample(id: "1")),
            provider: MockRecipeProvider(),
            store: store
        )
        await model.load()
        XCTAssertFalse(model.isFavorite)

        await model.toggleFavorite()
        XCTAssertTrue(model.isFavorite)
        XCTAssertTrue(store.items.contains { $0.id == "1" })

        await model.toggleFavorite()
        XCTAssertFalse(model.isFavorite)
        XCTAssertTrue(store.items.isEmpty)
    }
}
