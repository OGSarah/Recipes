//
// MealDetail.swift
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

/// A single ingredient line, pairing a name with its (optional) measure.
nonisolated struct Ingredient: Identifiable, Hashable, Sendable {
    /// The 1-based slot index from TheMealDB (`strIngredient1`...`strIngredient20`); stable for `ForEach`.
    let id: Int
    let name: String
    let measure: String?

    init(id: Int, name: String, measure: String? = nil) {
        self.id = id
        self.name = name
        self.measure = measure
    }
}

/// A full recipe from `lookup.php` / `search.php` / `random.php`.
///
/// TheMealDB encodes ingredients as 20 flat, numbered field pairs
/// (`strIngredient1`/`strMeasure1` ... `strIngredient20`/`strMeasure20`), padded with
/// empty strings and `null`. The custom `init(from:)` flattens those into a clean
/// `[Ingredient]`, trimming whitespace and dropping empty slots — the single place this
/// quirk is handled, and the focus of `MealDetailDecodingTests`.
nonisolated struct MealDetail: Identifiable, Hashable, Sendable, Decodable {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnailURL: URL?
    let youtubeURL: URL?
    let sourceURL: URL?
    let tags: [String]
    let ingredients: [Ingredient]

    init(
        id: String,
        name: String,
        category: String? = nil,
        area: String? = nil,
        instructions: String? = nil,
        thumbnailURL: URL? = nil,
        youtubeURL: URL? = nil,
        sourceURL: URL? = nil,
        tags: [String] = [],
        ingredients: [Ingredient] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.area = area
        self.instructions = instructions
        self.thumbnailURL = thumbnailURL
        self.youtubeURL = youtubeURL
        self.sourceURL = sourceURL
        self.tags = tags
        self.ingredients = ingredients
    }

    /// A coding key that can represent any of TheMealDB's arbitrarily-named string fields,
    /// so the 20 numbered ingredient/measure slots can be read in a loop.
    private struct DynamicKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        init(_ stringValue: String) { self.stringValue = stringValue }
        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)

        /// Reads a string field, trimming whitespace and collapsing empty/`null` to `nil`.
        func string(_ key: String) -> String? {
            guard let raw = try? container.decodeIfPresent(String.self, forKey: DynamicKey(key)) else {
                return nil
            }
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }

        guard let id = string("idMeal"), let name = string("strMeal") else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "A meal is missing its required idMeal or strMeal."
                )
            )
        }

        self.id = id
        self.name = name
        category = string("strCategory")
        area = string("strArea")
        instructions = string("strInstructions")
        thumbnailURL = string("strMealThumb").flatMap { URL(string: $0) }
        youtubeURL = string("strYoutube").flatMap { URL(string: $0) }
        sourceURL = string("strSource").flatMap { URL(string: $0) }
        tags = string("strTags")?
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty } ?? []

        var collected: [Ingredient] = []
        for slot in 1...20 {
            guard let ingredientName = string("strIngredient\(slot)") else { continue }
            collected.append(Ingredient(id: slot, name: ingredientName, measure: string("strMeasure\(slot)")))
        }
        ingredients = collected
    }
}
