//
// AppDependencies.swift
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

/// The application's dependency graph — the idiomatic "container" assembled once at the
/// composition root and passed down through view initializers.
///
/// Main-actor isolated, since it holds the main-actor favorites store and is only ever
/// built and read from the UI. It carries protocol abstractions (plus the image
/// `URLSession`) so previews and tests can substitute mocks.
struct AppDependencies {
    let recipeProvider: RecipeProviding
    let favoritesStore: FavoritesStoring
    /// The session whose `URLCache` backs `AsyncImage` thumbnail caching across the app.
    let imageSession: URLSession

    /// Builds the production graph: the live MealDB client, a SwiftData-backed favorites
    /// store, and an image session with a generous memory/disk cache.
    static func live() -> AppDependencies {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: FavoriteRecipe.self)
        } catch {
            fatalError("Could not create the favorites ModelContainer: \(error)")
        }

        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 32 * 1024 * 1024,
            diskCapacity: 128 * 1024 * 1024
        )

        return AppDependencies(
            recipeProvider: LiveMealDBClient(),
            favoritesStore: SwiftDataFavoritesStore(container: container),
            imageSession: URLSession(configuration: configuration)
        )
    }
}
