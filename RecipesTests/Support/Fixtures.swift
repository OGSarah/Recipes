//
// Fixtures.swift
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

/// Canned TheMealDB JSON payloads used across the decoding and networking tests.
enum Fixtures {
    static func data(_ json: String) -> Data { Data(json.utf8) }

    /// A `lookup.php` response exercising the flattening quirks: padded whitespace name,
    /// trailing-comma tags, a `null` source, an empty-measure ingredient, and a
    /// whitespace-only ingredient slot that must be skipped.
    static let lookup = """
    { "meals": [ {
      "idMeal": "52772",
      "strMeal": "  Teriyaki Chicken Casserole  ",
      "strCategory": "Chicken",
      "strArea": "Japanese",
      "strInstructions": "Preheat oven to 350 degrees F.",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
      "strTags": "Meat, Casserole, ",
      "strYoutube": "https://www.youtube.com/watch?v=4aZr5hZXP_s",
      "strSource": null,
      "strIngredient1": "soy sauce", "strMeasure1": "3/4 cup",
      "strIngredient2": "water", "strMeasure2": "1/2 cup",
      "strIngredient3": "   ", "strMeasure3": "ignored",
      "strIngredient4": "brown sugar", "strMeasure4": "",
      "strIngredient5": "", "strMeasure5": "",
      "strIngredient20": "", "strMeasure20": ""
    } ] }
    """

    /// A `search.php` response with two full meals.
    static let search = """
    { "meals": [
      { "idMeal": "52940", "strMeal": "Brown Stew Chicken", "strCategory": "Chicken",
        "strArea": "Jamaican", "strInstructions": "Stew it.",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/sypxpx1515365095.jpg",
        "strIngredient1": "Chicken", "strMeasure1": "1 whole" },
      { "idMeal": "53050", "strMeal": "Ayam Percik", "strCategory": "Chicken",
        "strArea": "Malaysian", "strInstructions": "Grill it.",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/020z181619788503.jpg",
        "strIngredient1": "Coconut Milk", "strMeasure1": "400ml" }
    ] }
    """

    /// A `filter.php` response — only id, name, thumbnail per meal.
    static let filter = """
    { "meals": [
      { "strMeal": "Beef and Mustard Pie", "strMealThumb": "https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg", "idMeal": "52874" },
      { "strMeal": "Beef Wellington", "strMealThumb": "https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg", "idMeal": "52803" }
    ] }
    """

    /// A `categories.php` response.
    static let categories = """
    { "categories": [
      { "idCategory": "1", "strCategory": "Beef", "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png", "strCategoryDescription": "Beef is the culinary name for meat from cattle." },
      { "idCategory": "2", "strCategory": "Chicken", "strCategoryThumb": "https://www.themealdb.com/images/category/chicken.png", "strCategoryDescription": "Chicken is a type of domesticated fowl." }
    ] }
    """

    /// A `list.php?a=list` response.
    static let areas = """
    { "meals": [ { "strArea": "American" }, { "strArea": "British" }, { "strArea": "Canadian" } ] }
    """

    /// TheMealDB's "no results" shape.
    static let noResults = """
    { "meals": null }
    """
}
