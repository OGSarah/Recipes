//
// PreviewData.swift
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

#if DEBUG
import Foundation

// MARK: - Sample domain values

extension MealDetail {
    nonisolated static let preview = MealDetail(
        id: "52772",
        name: "Spaghetti Carbonara",
        category: "Pasta",
        area: "Italian",
        instructions: "Bring a large pot of salted water to a boil and cook the spaghetti "
            + "until al dente. Meanwhile, crisp the pancetta, then toss the drained pasta with "
            + "the eggs, cheese, and pancetta off the heat so the sauce stays silky.",
        thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=3AAdKl1UYZs"),
        sourceURL: URL(string: "https://www.themealdb.com"),
        tags: ["Pasta", "Comfort"],
        ingredients: [
            Ingredient(id: 1, name: "Spaghetti", measure: "200g"),
            Ingredient(id: 2, name: "Pancetta", measure: "100g"),
            Ingredient(id: 3, name: "Eggs", measure: "3 large"),
            Ingredient(id: 4, name: "Parmesan", measure: "50g"),
            Ingredient(id: 5, name: "Black Pepper", measure: "To taste")
        ]
    )

    nonisolated static let previewList = [
        MealDetail.preview,
        MealDetail(
            id: "52773",
            name: "Beef Wellington",
            category: "Beef",
            area: "British",
            instructions: "Sear the beef, coat in mushroom duxelles and prosciutto, wrap in "
                + "puff pastry, and bake until golden.",
            thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg"),
            ingredients: [Ingredient(id: 1, name: "Beef Fillet", measure: "400g")]
        )
    ]
}

extension MealSummary {
    nonisolated static let previewList = [
        MealSummary(id: "52772", name: "Spaghetti Carbonara",
                    thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg")),
        MealSummary(id: "52773", name: "Beef Wellington",
                    thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg")),
        MealSummary(id: "52774", name: "Chicken Tikka Masala",
                    thumbnailURL: URL(string: "https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg"))
    ]
}

extension MealCategory {
    nonisolated static let preview = MealCategory(
        id: "1",
        name: "Beef",
        thumbnailURL: URL(string: "https://www.themealdb.com/images/category/beef.png"),
        description: "Beef is the culinary name for meat from cattle."
    )

    nonisolated static let previewList = [
        MealCategory.preview,
        MealCategory(id: "2", name: "Seafood",
                     thumbnailURL: URL(string: "https://www.themealdb.com/images/category/seafood.png"),
                     description: "Seafood dishes from around the world."),
        MealCategory(id: "3", name: "Vegetarian",
                     thumbnailURL: URL(string: "https://www.themealdb.com/images/category/vegetarian.png"),
                     description: "Meat-free meals.")
    ]
}

extension Area {
    nonisolated static let previewList = [Area(name: "Italian"), Area(name: "Japanese"), Area(name: "Canadian")]
}

// MARK: - Preview service doubles

/// A static `RecipeProviding` returning sample data, for SwiftUI previews.
struct PreviewRecipeProvider: RecipeProviding {
    func categories() async throws -> [MealCategory] { MealCategory.previewList }
    func areas() async throws -> [Area] { Area.previewList }
    func meals(inCategory category: String) async throws -> [MealSummary] { MealSummary.previewList }
    func meals(inArea area: String) async throws -> [MealSummary] { MealSummary.previewList }
    func searchMeals(name: String) async throws -> [MealDetail] { MealDetail.previewList }
    func mealDetail(id: String) async throws -> MealDetail { .preview }
    func randomMeal() async throws -> MealDetail { .preview }
}

/// An in-memory `FavoritesStoring` for SwiftUI previews.
@MainActor
final class PreviewFavoritesStore: FavoritesStoring {
    private var storage: [MealDetail]

    init(seeded: [MealDetail] = []) {
        storage = seeded
    }

    func favorites() async throws -> [MealDetail] { storage }
    func isFavorite(id: String) async throws -> Bool { storage.contains { $0.id == id } }
    func add(_ meal: MealDetail) async throws {
        guard !storage.contains(where: { $0.id == meal.id }) else { return }
        storage.append(meal)
    }
    func remove(id: String) async throws { storage.removeAll { $0.id == id } }
}

extension AppDependencies {
    /// A fully-mocked graph for previews — no network, no SwiftData.
    @MainActor
    static func preview(seededFavorites: [MealDetail] = []) -> AppDependencies {
        AppDependencies(
            recipeProvider: PreviewRecipeProvider(),
            favoritesStore: PreviewFavoritesStore(seeded: seededFavorites),
            imageSession: .shared
        )
    }
}
#endif
