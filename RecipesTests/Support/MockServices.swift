//
// MockServices.swift
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

import Foundation
@testable import Recipes

/// A configurable `RecipeProviding` double for view-model tests — no networking.
final class MockRecipeProvider: RecipeProviding, @unchecked Sendable {
    var categoriesToReturn: [MealCategory] = []
    var areasToReturn: [Area] = []
    var summariesToReturn: [MealSummary] = []
    var searchToReturn: [MealDetail] = []
    var detailToReturn: MealDetail?
    var errorToThrow: MealDBError?

    private(set) var searchCallCount = 0
    private(set) var lastSearchName: String?
    private(set) var lastCategory: String?
    private(set) var lastArea: String?
    private(set) var lastLookupID: String?

    private func failIfNeeded() throws {
        if let errorToThrow { throw errorToThrow }
    }

    func categories() async throws -> [MealCategory] {
        try failIfNeeded()
        return categoriesToReturn
    }

    func areas() async throws -> [Area] {
        try failIfNeeded()
        return areasToReturn
    }

    func meals(inCategory category: String) async throws -> [MealSummary] {
        lastCategory = category
        try failIfNeeded()
        return summariesToReturn
    }

    func meals(inArea area: String) async throws -> [MealSummary] {
        lastArea = area
        try failIfNeeded()
        return summariesToReturn
    }

    func searchMeals(name: String) async throws -> [MealDetail] {
        searchCallCount += 1
        lastSearchName = name
        try failIfNeeded()
        return searchToReturn
    }

    func mealDetail(id: String) async throws -> MealDetail {
        lastLookupID = id
        try failIfNeeded()
        guard let detailToReturn else { throw MealDBError.noResults }
        return detailToReturn
    }

    func randomMeal() async throws -> MealDetail {
        try failIfNeeded()
        guard let detailToReturn else { throw MealDBError.noResults }
        return detailToReturn
    }
}

/// An in-memory `FavoritesStoring` double for view-model tests.
@MainActor
final class MockFavoritesStore: FavoritesStoring {
    private(set) var items: [MealDetail]
    var errorToThrow: MealDBError?

    init(seeded: [MealDetail] = []) {
        items = seeded
    }

    private func failIfNeeded() throws {
        if let errorToThrow { throw errorToThrow }
    }

    func favorites() async throws -> [MealDetail] {
        try failIfNeeded()
        return items
    }

    func isFavorite(id: String) async throws -> Bool {
        items.contains { $0.id == id }
    }

    func add(_ meal: MealDetail) async throws {
        try failIfNeeded()
        guard !items.contains(where: { $0.id == meal.id }) else { return }
        items.append(meal)
    }

    func remove(id: String) async throws {
        try failIfNeeded()
        items.removeAll { $0.id == id }
    }
}

/// A few shared sample values for tests.
extension MealDetail {
    static func sample(id: String, name: String = "Sample") -> MealDetail {
        MealDetail(
            id: id,
            name: name,
            category: "Chicken",
            area: "Italian",
            instructions: "Cook it.",
            thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/abc.jpg"),
            youtubeURL: URL(string: "https://youtube.com/watch?v=abc"),
            sourceURL: nil,
            tags: ["Tasty"],
            ingredients: [Ingredient(id: 1, name: "Salt", measure: "1 tsp")]
        )
    }
}
