//
// BrowseViewModelTests.swift
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

// Note: the `@MainActor` view-model and store suites use XCTest rather than Swift Testing.
// On the current iOS 27 beta toolchain, app-hosted Swift Testing suites isolated to a global
// actor crash in `Runner._applyScopingTraits` when run in parallel; XCTest runs them serially
// on the host and is unaffected. The pure-logic suites (decoding, networking) stay on Swift
// Testing — see `MealDecodingTests` and `LiveMealDBClientTests`.

import XCTest
@testable import Recipes

final class BrowseViewModelTests: XCTestCase {
    @MainActor
    func testLoadPopulatesCategoriesAndAreas() async {
        let provider = MockRecipeProvider()
        provider.categoriesToReturn = [
            MealCategory(id: "1", name: "Beef", description: "Beef."),
            MealCategory(id: "2", name: "Seafood", description: "Seafood.")
        ]
        provider.areasToReturn = [Area(name: "Italian"), Area(name: "Japanese")]
        let model = BrowseViewModel(provider: provider)

        await model.load()

        XCTAssertEqual(model.categories.count, 2)
        XCTAssertEqual(model.areas.count, 2)
        XCTAssertFalse(model.isLoading)
        XCTAssertNil(model.error)
    }

    @MainActor
    func testLoadSurfacesError() async {
        let provider = MockRecipeProvider()
        provider.errorToThrow = .badStatus(500)
        let model = BrowseViewModel(provider: provider)

        await model.load()

        XCTAssertEqual(model.error, .badStatus(500))
        XCTAssertFalse(model.isLoading)
    }
}
