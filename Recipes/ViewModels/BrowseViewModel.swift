//
// BrowseViewModel.swift
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

/// Drives the Browse tab: the list of categories and cuisine areas to drill into.
@MainActor
@Observable
final class BrowseViewModel {
    /// Which axis of the catalog the user is browsing.
    enum Mode: Hashable, CaseIterable, Identifiable {
        case categories
        case areas
        var id: Self { self }
        var title: String {
            switch self {
                case .categories: "Categories"
                case .areas: "Cuisines"
            }
        }
    }

    private let provider: RecipeProviding

    var mode: Mode = .categories
    private(set) var categories: [MealCategory] = []
    private(set) var areas: [Area] = []
    private(set) var isLoading = false
    private(set) var error: MealDBError?

    init(provider: RecipeProviding) {
        self.provider = provider
    }

    /// Loads whichever lists haven't been fetched yet — safe to call on every appearance.
    func loadIfNeeded() async {
        if categories.isEmpty || areas.isEmpty {
            await load()
        }
    }

    func load() async {
        isLoading = true
        error = nil
        do {
            async let fetchedCategories = provider.categories()
            async let fetchedAreas = provider.areas()
            categories = try await fetchedCategories
            areas = try await fetchedAreas
        } catch let mealError as MealDBError {
            if mealError != .cancelled { error = mealError }
        } catch {
            self.error = .transport(error.localizedDescription)
        }
        isLoading = false
    }
}
