//
// MealListViewModel.swift
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

/// Drives the drill-down list of meals for a chosen category or cuisine area.
///
/// `filter.php` returns only lightweight `MealSummary` values; the full recipe is fetched
/// later by `RecipeDetailViewModel` when a row is opened.
@MainActor
@Observable
final class MealListViewModel {
    /// The browse axis this list was opened for.
    enum Filter: Hashable, Sendable {
        case category(String)
        case area(String)

        var title: String {
            switch self {
                case .category(let name): name
                case .area(let name): name
            }
        }
    }

    private let provider: RecipeProviding
    let filter: Filter

    private(set) var meals: [MealSummary] = []
    private(set) var isLoading = false
    private(set) var error: MealDBError?

    init(provider: RecipeProviding, filter: Filter) {
        self.provider = provider
        self.filter = filter
    }

    func loadIfNeeded() async {
        guard meals.isEmpty else { return }
        await load()
    }

    func load() async {
        isLoading = true
        error = nil
        do {
            switch filter {
                case .category(let name): meals = try await provider.meals(inCategory: name)
                case .area(let name): meals = try await provider.meals(inArea: name)
            }
        } catch let mealError as MealDBError {
            if mealError != .cancelled { error = mealError }
        } catch {
            self.error = .transport(error.localizedDescription)
        }
        isLoading = false
    }
}
