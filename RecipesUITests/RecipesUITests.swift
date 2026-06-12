//
// RecipesUITests.swift
// RecipesUITests
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

/// End-to-end flows driven through accessibility identifiers. The app is launched with
/// `-uitest-stub`, so it runs against mocked services (no live network) for determinism.
final class RecipesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-uitest-stub"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testTabsAreReachable() throws {
        XCTAssertTrue(app.tabBars.buttons["Browse"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.tabBars.buttons["Search"].exists)
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
    }

    @MainActor
    func testSearchThenFavoriteAppearsInFavoritesTab() throws {
        // Search for a recipe.
        app.tabBars.buttons["Search"].tap()
        let field = app.searchFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        field.typeText("beef")

        // Open the first result (Spaghetti Carbonara, idMeal 52772 in the stub data).
        let row = app.descendants(matching: .any).matching(identifier: "meal.row.52772").firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 10))
        row.tap()

        // Favorite it from the detail screen.
        let favorite = app.buttons["detail.favorite.button"]
        XCTAssertTrue(favorite.waitForExistence(timeout: 10))
        favorite.tap()

        // Go back, then over to Favorites — the saved recipe should be listed.
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Favorites"].tap()

        let favoriteRow = app.descendants(matching: .any).matching(identifier: "meal.row.52772").firstMatch
        XCTAssertTrue(favoriteRow.waitForExistence(timeout: 10))
    }

    @MainActor
    func testBrowseShowsCategories() throws {
        app.tabBars.buttons["Browse"].tap()
        let beef = app.descendants(matching: .any).matching(identifier: "browse.category.Beef").firstMatch
        XCTAssertTrue(beef.waitForExistence(timeout: 10))
    }
}
