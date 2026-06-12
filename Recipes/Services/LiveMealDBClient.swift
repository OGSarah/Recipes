//
// LiveMealDBClient.swift
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

/// `{ "meals": [...] }` envelope. TheMealDB returns `{ "meals": null }` for no results,
/// which decodes to `nil` and is mapped to an empty array by the client.
private nonisolated struct MealsResponse<Element: Decodable & Sendable>: Decodable, Sendable {
    let meals: [Element]?
}

/// `{ "categories": [...] }` envelope from `categories.php`.
private nonisolated struct CategoriesResponse: Decodable, Sendable {
    let categories: [MealCategory]
}

/// The live `RecipeProviding` implementation backed by `URLSession`.
///
/// `nonisolated` and `Sendable` (its only stored property, `URLSession`, is `Sendable`),
/// so requests and JSON decoding run off the main actor and never block UI. All transport,
/// status, decoding, and cancellation failures are funnelled into `MealDBError`.
nonisolated final class LiveMealDBClient: RecipeProviding {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func categories() async throws -> [MealCategory] {
        let response: CategoriesResponse = try await get(.categories)
        return response.categories
    }

    func areas() async throws -> [Area] {
        let response: MealsResponse<Area> = try await get(.areas)
        return response.meals ?? []
    }

    func meals(inCategory category: String) async throws -> [MealSummary] {
        let response: MealsResponse<MealSummary> = try await get(.mealsInCategory(category))
        return response.meals ?? []
    }

    func meals(inArea area: String) async throws -> [MealSummary] {
        let response: MealsResponse<MealSummary> = try await get(.mealsInArea(area))
        return response.meals ?? []
    }

    func searchMeals(name: String) async throws -> [MealDetail] {
        let response: MealsResponse<MealDetail> = try await get(.search(name: name))
        return response.meals ?? []
    }

    func mealDetail(id: String) async throws -> MealDetail {
        let response: MealsResponse<MealDetail> = try await get(.lookup(id: id))
        guard let meal = response.meals?.first else { throw MealDBError.noResults }
        return meal
    }

    func randomMeal() async throws -> MealDetail {
        let response: MealsResponse<MealDetail> = try await get(.random)
        guard let meal = response.meals?.first else { throw MealDBError.noResults }
        return meal
    }

    /// Performs the request, validates the response, and decodes it — mapping every
    /// failure mode to a typed `MealDBError`.
    private func get<Response: Decodable & Sendable>(_ endpoint: MealDBEndpoint) async throws -> Response {
        guard let url = endpoint.url else { throw MealDBError.invalidURL }
        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse else {
                throw MealDBError.transport("The server returned an unexpected response.")
            }
            guard (200..<300).contains(http.statusCode) else {
                throw MealDBError.badStatus(http.statusCode)
            }
            do {
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                throw MealDBError.decoding(error.localizedDescription)
            }
        } catch let error as MealDBError {
            throw error
        } catch is CancellationError {
            throw MealDBError.cancelled
        } catch let urlError as URLError {
            if urlError.code == .cancelled { throw MealDBError.cancelled }
            throw MealDBError.transport(urlError.localizedDescription)
        } catch {
            throw MealDBError.transport(error.localizedDescription)
        }
    }
}
