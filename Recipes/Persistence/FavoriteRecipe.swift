//
// FavoriteRecipe.swift
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

/// The SwiftData record for a saved recipe.
///
/// It stores everything needed to render the detail screen **offline**, so a favorite
/// never needs to be re-fetched. Ingredients are kept as two parallel scalar arrays
/// (names + measures) rather than a child model — simple to persist and reconstruct.
/// This type is an implementation detail of `SwiftDataFavoritesStore`; nothing outside
/// that store should touch it.
///
/// The TheMealDB identifier is stored as `mealID` rather than `id`: a `@Model` already
/// supplies `id` via `Identifiable`/`persistentModelID`, and a stored property named `id`
/// collides with it inside `#Predicate`.
@Model
final class FavoriteRecipe {
    @Attribute(.unique) var mealID: String
    var name: String
    var category: String?
    var area: String?
    var instructions: String?
    var thumbnailURLString: String?
    var youtubeURLString: String?
    var sourceURLString: String?
    var tags: [String]
    var ingredientNames: [String]
    var ingredientMeasures: [String]
    var dateAdded: Date

    init(
        mealID: String,
        name: String,
        category: String?,
        area: String?,
        instructions: String?,
        thumbnailURLString: String?,
        youtubeURLString: String?,
        sourceURLString: String?,
        tags: [String],
        ingredientNames: [String],
        ingredientMeasures: [String],
        dateAdded: Date
    ) {
        self.mealID = mealID
        self.name = name
        self.category = category
        self.area = area
        self.instructions = instructions
        self.thumbnailURLString = thumbnailURLString
        self.youtubeURLString = youtubeURLString
        self.sourceURLString = sourceURLString
        self.tags = tags
        self.ingredientNames = ingredientNames
        self.ingredientMeasures = ingredientMeasures
        self.dateAdded = dateAdded
    }
}

extension FavoriteRecipe {
    /// Creates a record from a domain `MealDetail`, flattening ingredients into parallel arrays.
    convenience init(meal: MealDetail, dateAdded: Date = Date()) {
        self.init(
            mealID: meal.id,
            name: meal.name,
            category: meal.category,
            area: meal.area,
            instructions: meal.instructions,
            thumbnailURLString: meal.thumbnailURL?.absoluteString,
            youtubeURLString: meal.youtubeURL?.absoluteString,
            sourceURLString: meal.sourceURL?.absoluteString,
            tags: meal.tags,
            ingredientNames: meal.ingredients.map(\.name),
            ingredientMeasures: meal.ingredients.map { $0.measure ?? "" },
            dateAdded: dateAdded
        )
    }

    /// Reconstructs the domain `MealDetail`, rebuilding `Ingredient`s from the parallel arrays.
    var asMealDetail: MealDetail {
        let ingredients = zip(ingredientNames, ingredientMeasures).enumerated().map { index, pair in
            Ingredient(id: index + 1, name: pair.0, measure: pair.1.isEmpty ? nil : pair.1)
        }
        return MealDetail(
            id: mealID,
            name: name,
            category: category,
            area: area,
            instructions: instructions,
            thumbnailURL: thumbnailURLString.flatMap { URL(string: $0) },
            youtubeURL: youtubeURLString.flatMap { URL(string: $0) },
            sourceURL: sourceURLString.flatMap { URL(string: $0) },
            tags: tags,
            ingredients: ingredients
        )
    }
}
