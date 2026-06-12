//
// FavoritesStoring.swift
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

/// The persistence seam for saved recipes. It speaks only in domain `MealDetail` values,
/// so SwiftData never leaks past the live implementation — view models stay free of any
/// persistence framework and can be tested against an in-memory mock.
///
/// Main-actor isolated: the favorites set is small, the live store wraps SwiftData's
/// main `ModelContext`, and the only callers are main-actor view models — so there's no
/// reason to leave the main actor. (Network reads, by contrast, run off-main via the
/// `nonisolated` `RecipeProviding`.)
@MainActor
protocol FavoritesStoring {
    func favorites() async throws -> [MealDetail]
    func isFavorite(id: String) async throws -> Bool
    func add(_ meal: MealDetail) async throws
    func remove(id: String) async throws
}
