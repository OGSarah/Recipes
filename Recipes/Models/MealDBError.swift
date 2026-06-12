//
// MealDBError.swift
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

/// A typed, user-presentable error for every failure the recipe layer can produce.
///
/// Underlying system errors (`URLError`, `DecodingError`) are reduced to a `String`
/// so the enum stays `Equatable` and `Sendable` — letting view-model tests assert an
/// exact case (`#expect(viewModel.error == .noResults)`).
nonisolated enum MealDBError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case transport(String)
    case badStatus(Int)
    case decoding(String)
    case noResults
    case cancelled

    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The request couldn't be built. Please try again."
            case .transport(let message):
                return "Network problem: \(message)"
            case .badStatus(let code):
                return "The server responded with status code \(code)."
            case .decoding(let message):
                return "Couldn't read the recipe data: \(message)"
            case .noResults:
                return "No recipes were found."
            case .cancelled:
                return "The request was cancelled."
        }
    }
}
