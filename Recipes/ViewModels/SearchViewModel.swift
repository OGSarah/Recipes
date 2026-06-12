//
// SearchViewModel.swift
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

/// Drives the Search tab: debounced, cancellable name search against TheMealDB.
///
/// The view binds `query` and runs `search()` in a `.task(id: query)`, so each keystroke
/// cancels the in-flight task; the debounce `Task.sleep` then absorbs rapid typing before
/// any request is made.
@MainActor
@Observable
final class SearchViewModel {
    private let provider: RecipeProviding
    private let debounce: Duration
    private let minimumQueryLength: Int

    var query: String = ""
    private(set) var results: [MealDetail] = []
    private(set) var isLoading = false
    private(set) var error: MealDBError?
    private(set) var hasSearched = false

    init(provider: RecipeProviding, debounce: Duration = .milliseconds(300), minimumQueryLength: Int = 2) {
        self.provider = provider
        self.debounce = debounce
        self.minimumQueryLength = minimumQueryLength
    }

    /// Debounced search keyed off the current `query`. Cancellation (a new keystroke)
    /// aborts during the debounce sleep, before any network work begins.
    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= minimumQueryLength else {
            results = []
            error = nil
            hasSearched = false
            isLoading = false
            return
        }

        do {
            try await Task.sleep(for: debounce)
        } catch {
            return // superseded by a newer query during the debounce window
        }

        isLoading = true
        error = nil
        do {
            let meals = try await provider.searchMeals(name: trimmed)
            results = meals
            hasSearched = true
        } catch let mealError as MealDBError {
            if mealError != .cancelled {
                error = mealError
                results = []
            }
        } catch is CancellationError {
            // superseded; leave state for the newer task to own
        } catch {
            self.error = .transport(error.localizedDescription)
            results = []
        }
        isLoading = false
    }
}
