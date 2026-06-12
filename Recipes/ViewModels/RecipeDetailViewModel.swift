//
// RecipeDetailViewModel.swift
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

/// Drives the recipe detail screen and its favorite toggle.
///
/// It is built one of two ways: from a `MealSummary` (the Browse path), where the full
/// recipe must be looked up; or from a `MealDetail` already in hand (Search / Favorites),
/// where no fetch is needed.
@MainActor
@Observable
final class RecipeDetailViewModel {
    /// How the screen was entered, which determines whether a lookup is required.
    enum Source: Hashable {
        case summary(MealSummary)
        case detail(MealDetail)

        var id: String {
            switch self {
                case .summary(let summary): summary.id
                case .detail(let detail): detail.id
            }
        }

        var name: String {
            switch self {
                case .summary(let summary): summary.name
                case .detail(let detail): detail.name
            }
        }
    }

    private let provider: RecipeProviding
    private let store: FavoritesStoring
    private let source: Source

    private(set) var detail: MealDetail?
    private(set) var isLoading = false
    private(set) var error: MealDBError?
    private(set) var isFavorite = false

    /// A title to show immediately, even before a lookup resolves.
    var title: String { detail?.name ?? source.name }

    init(source: Source, provider: RecipeProviding, store: FavoritesStoring) {
        self.provider = provider
        self.store = store
        self.source = source
        if case .detail(let meal) = source {
            detail = meal
        }
    }

    func load() async {
        await loadDetailIfNeeded()
        await refreshFavoriteState()
    }

    private func loadDetailIfNeeded() async {
        guard detail == nil, case .summary(let summary) = source else { return }
        isLoading = true
        error = nil
        do {
            detail = try await provider.mealDetail(id: summary.id)
        } catch let mealError as MealDBError {
            if mealError != .cancelled { error = mealError }
        } catch {
            self.error = .transport(error.localizedDescription)
        }
        isLoading = false
    }

    private func refreshFavoriteState() async {
        isFavorite = (try? await store.isFavorite(id: source.id)) ?? false
    }

    func toggleFavorite() async {
        guard let detail else { return }
        do {
            if isFavorite {
                try await store.remove(id: detail.id)
                isFavorite = false
            } else {
                try await store.add(detail)
                isFavorite = true
            }
        } catch {
            self.error = .transport(error.localizedDescription)
        }
    }
}
