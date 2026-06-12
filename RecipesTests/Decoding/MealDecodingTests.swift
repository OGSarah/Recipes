//
// MealDecodingTests.swift
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

import Testing
import Foundation
@testable import Recipes

@Suite("Meal decoding")
struct MealDecodingTests {
    private func decodeMeal(_ json: String) throws -> MealDetail {
        struct Envelope: Decodable { let meals: [MealDetail] }
        return try JSONDecoder().decode(Envelope.self, from: Fixtures.data(json)).meals[0]
    }

    @Test("Flattens 20 ingredient slots, skipping empty and whitespace-only ones")
    func flattensIngredients() throws {
        let meal = try decodeMeal(Fixtures.lookup)
        #expect(meal.ingredients.count == 3)
        #expect(meal.ingredients.map(\.id) == [1, 2, 4])
        #expect(meal.ingredients[0].name == "soy sauce")
        #expect(meal.ingredients[0].measure == "3/4 cup")
    }

    @Test("An empty measure collapses to nil")
    func emptyMeasureBecomesNil() throws {
        let meal = try decodeMeal(Fixtures.lookup)
        let brownSugar = try #require(meal.ingredients.first { $0.name == "brown sugar" })
        #expect(brownSugar.measure == nil)
    }

    @Test("Trims the name and splits tags, dropping the trailing empty tag")
    func trimsNameAndSplitsTags() throws {
        let meal = try decodeMeal(Fixtures.lookup)
        #expect(meal.name == "Teriyaki Chicken Casserole")
        #expect(meal.tags == ["Meat", "Casserole"])
    }

    @Test("A null source decodes to nil; present URLs decode")
    func handlesURLsAndNull() throws {
        let meal = try decodeMeal(Fixtures.lookup)
        #expect(meal.sourceURL == nil)
        #expect(meal.youtubeURL != nil)
        #expect(meal.thumbnailURL?.absoluteString.hasSuffix("wvpsxx1468256321.jpg") == true)
    }

    @Test("A meal missing its id fails to decode")
    func missingIDThrows() {
        #expect(throws: DecodingError.self) {
            try decodeMeal(#"{ "meals": [ { "strMeal": "No ID" } ] }"#)
        }
    }

    @Test("filter.php summaries decode their three fields")
    func decodesSummaries() throws {
        struct Envelope: Decodable { let meals: [MealSummary] }
        let meals = try JSONDecoder().decode(Envelope.self, from: Fixtures.data(Fixtures.filter)).meals
        #expect(meals.count == 2)
        #expect(meals[0].id == "52874")
        #expect(meals[0].name == "Beef and Mustard Pie")
        #expect(meals[0].thumbnailURL != nil)
    }

    @Test("categories.php decodes name, thumbnail, and description")
    func decodesCategories() throws {
        struct Envelope: Decodable { let categories: [MealCategory] }
        let categories = try JSONDecoder().decode(Envelope.self, from: Fixtures.data(Fixtures.categories)).categories
        #expect(categories.count == 2)
        #expect(categories[0].name == "Beef")
        #expect(categories[0].description.isEmpty == false)
    }

    @Test("list.php areas decode their names")
    func decodesAreas() throws {
        struct Envelope: Decodable { let meals: [Area] }
        let areas = try JSONDecoder().decode(Envelope.self, from: Fixtures.data(Fixtures.areas)).meals
        #expect(areas.map(\.name) == ["American", "British", "Canadian"])
    }
}
