//
// RecipeProviding.swift
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

/// The network seam for reading recipes. View models depend on this protocol — never on
/// `URLSession` or any concrete client — so tests inject a mock with zero networking.
///
/// `Sendable` and `nonisolated` so callers can run requests off the main actor.
nonisolated protocol RecipeProviding: Sendable {
    func categories() async throws -> [MealCategory]
    func areas() async throws -> [Area]
    func meals(inCategory category: String) async throws -> [MealSummary]
    func meals(inArea area: String) async throws -> [MealSummary]
    func searchMeals(name: String) async throws -> [MealDetail]
    func mealDetail(id: String) async throws -> MealDetail
    func randomMeal() async throws -> MealDetail
}
