//
// LiveMealDBClientTests.swift
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

/// Exercises the real decode/validate/error-mapping path of `LiveMealDBClient` against
/// canned responses replayed by `StubURLProtocol`. Serialized because the stub registry
/// is shared global state.
@Suite("LiveMealDBClient", .serialized)
struct LiveMealDBClientTests {
    private func makeClient() -> LiveMealDBClient {
        LiveMealDBClient(session: .stubbed())
    }

    @Test("Builds the categories URL and decodes the response")
    func decodesCategories() async throws {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data(Fixtures.categories), for: MealDBEndpoint.categories.url!)
        let categories = try await makeClient().categories()
        #expect(categories.count == 2)
        #expect(categories.first?.name == "Beef")
    }

    @Test("Lookup decodes the full meal with flattened ingredients")
    func lookupDecodesMeal() async throws {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data(Fixtures.lookup), for: MealDBEndpoint.lookup(id: "52772").url!)
        let meal = try await makeClient().mealDetail(id: "52772")
        #expect(meal.id == "52772")
        #expect(meal.ingredients.count == 3)
    }

    @Test("A null meals payload maps to an empty array for filter endpoints")
    func nullMealsIsEmpty() async throws {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data(Fixtures.noResults), for: MealDBEndpoint.mealsInCategory("Beef").url!)
        let meals = try await makeClient().meals(inCategory: "Beef")
        #expect(meals.isEmpty)
    }

    @Test("A null meals payload throws noResults for a single-meal lookup")
    func lookupNullThrowsNoResults() async {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data(Fixtures.noResults), for: MealDBEndpoint.lookup(id: "0").url!)
        await #expect(throws: MealDBError.noResults) {
            _ = try await makeClient().mealDetail(id: "0")
        }
    }

    @Test("A non-2xx status maps to badStatus")
    func badStatusThrows() async {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data("{}"), statusCode: 503, for: MealDBEndpoint.categories.url!)
        await #expect(throws: MealDBError.badStatus(503)) {
            _ = try await makeClient().categories()
        }
    }

    @Test("Malformed JSON maps to a decoding error")
    func malformedJSONThrowsDecoding() async {
        StubURLProtocol.reset()
        StubURLProtocol.register(Fixtures.data("definitely not json"), for: MealDBEndpoint.categories.url!)
        await #expect(throws: MealDBError.self) {
            _ = try await makeClient().categories()
        }
    }
}
