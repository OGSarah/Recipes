//
// MealDBEndpoint.swift
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

/// Builds URLs for the **free** V1 endpoints of TheMealDB.
///
/// All cases use the free developer test key `1`. Only endpoints available on the free
/// tier are modelled here — premium V2 features (multi-random, latest meals,
/// multi-ingredient filters) are deliberately omitted so they can't be called by accident.
nonisolated enum MealDBEndpoint: Sendable, Equatable {
    case categories
    case areas
    case mealsInCategory(String)
    case mealsInArea(String)
    case search(name: String)
    case lookup(id: String)
    case random

    /// The free V1 test key. Production/App Store use would require a paid supporter key.
    private static let apiKey = "1"
    private static let baseURLString = "https://www.themealdb.com/api/json/v1/\(apiKey)/"

    var url: URL? {
        guard var components = URLComponents(string: Self.baseURLString) else {
            return nil
        }
        switch self {
            case .categories:
                components.path += "categories.php"
            case .areas:
                components.path += "list.php"
                components.queryItems = [URLQueryItem(name: "a", value: "list")]
            case .mealsInCategory(let category):
                components.path += "filter.php"
                components.queryItems = [URLQueryItem(name: "c", value: category)]
            case .mealsInArea(let area):
                components.path += "filter.php"
                components.queryItems = [URLQueryItem(name: "a", value: area)]
            case .search(let name):
                components.path += "search.php"
                components.queryItems = [URLQueryItem(name: "s", value: name)]
            case .lookup(let id):
                components.path += "lookup.php"
                components.queryItems = [URLQueryItem(name: "i", value: id)]
            case .random:
                components.path += "random.php"
        }
        return components.url
    }
}
