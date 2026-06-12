//
// FavoritesViewModel.swift
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
import Observation

/// Drives the Favorites tab: the locally-saved recipes, available offline.
@MainActor
@Observable
final class FavoritesViewModel {
    private let store: FavoritesStoring

    private(set) var favorites: [MealDetail] = []
    private(set) var isLoading = false
    private(set) var error: MealDBError?

    init(store: FavoritesStoring) {
        self.store = store
    }

    func load() async {
        isLoading = true
        error = nil
        do {
            favorites = try await store.favorites()
        } catch let mealError as MealDBError {
            error = mealError
        } catch {
            self.error = .transport(error.localizedDescription)
        }
        isLoading = false
    }

    func remove(_ meal: MealDetail) async {
        do {
            try await store.remove(id: meal.id)
            favorites.removeAll { $0.id == meal.id }
        } catch {
            self.error = .transport(error.localizedDescription)
        }
    }

    func remove(at offsets: IndexSet) async {
        let targets = offsets.map { favorites[$0] }
        for meal in targets {
            await remove(meal)
        }
    }
}
