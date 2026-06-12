//
// SwiftDataFavoritesStore.swift
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
import SwiftData

/// The live `FavoritesStoring` implementation backed by SwiftData.
///
/// Main-actor isolated (and therefore `Sendable`), it owns the `ModelContext` and maps
/// `FavoriteRecipe` ⇄ `MealDetail` at the boundary so no `@Model` object ever escapes.
@MainActor
final class SwiftDataFavoritesStore: FavoritesStoring {
    private let modelContext: ModelContext

    init(container: ModelContainer) {
        modelContext = container.mainContext
    }

    func favorites() async throws -> [MealDetail] {
        let descriptor = FetchDescriptor<FavoriteRecipe>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map(\.asMealDetail)
    }

    func isFavorite(id: String) async throws -> Bool {
        try existing(mealID: id) != nil
    }

    func add(_ meal: MealDetail) async throws {
        guard try existing(mealID: meal.id) == nil else { return }
        modelContext.insert(FavoriteRecipe(meal: meal))
        try modelContext.save()
    }

    func remove(id: String) async throws {
        guard let record = try existing(mealID: id) else { return }
        modelContext.delete(record)
        try modelContext.save()
    }

    private func existing(mealID: String) throws -> FavoriteRecipe? {
        // Filtered in Swift rather than via `#Predicate`: the favorites set is small, and a
        // string-equality `#Predicate` fetch traps at runtime on the current iOS 27 toolchain.
        try modelContext.fetch(FetchDescriptor<FavoriteRecipe>()).first { $0.mealID == mealID }
    }
}
