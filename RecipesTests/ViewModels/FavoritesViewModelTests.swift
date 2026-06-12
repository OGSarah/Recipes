//
// FavoritesViewModelTests.swift
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

final class FavoritesViewModelTests: XCTestCase {
    @MainActor
    func testLoadFetchesFavorites() async {
        let store = MockFavoritesStore(seeded: [.sample(id: "1"), .sample(id: "2")])
        let model = FavoritesViewModel(store: store)

        await model.load()

        XCTAssertEqual(model.favorites.count, 2)
        XCTAssertNil(model.error)
    }

    @MainActor
    func testRemoveDeletesFromStoreAndList() async {
        let store = MockFavoritesStore(seeded: [.sample(id: "1"), .sample(id: "2")])
        let model = FavoritesViewModel(store: store)
        await model.load()

        await model.remove(model.favorites[0])

        XCTAssertEqual(model.favorites.count, 1)
        XCTAssertEqual(store.items.count, 1)
    }
}
