//
// AccessibilityIdentifiers.swift
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

/// Stable accessibility identifiers shared by the app's views and its UI test suite.
///
/// Keeping them in one namespace (compiled into both targets) means a renamed identifier
/// is a compile error in the tests rather than a silent runtime miss.
enum AccessibilityID {
    enum Browse {
        static let modePicker = "browse.modePicker"
        static func categoryCell(_ name: String) -> String { "browse.category.\(name)" }
        static func areaCell(_ name: String) -> String { "browse.area.\(name)" }
    }

    enum Meal {
        static func row(_ id: String) -> String { "meal.row.\(id)" }
    }

    enum Detail {
        static let title = "detail.title"
        static let favoriteButton = "detail.favorite.button"
        static let youtubeLink = "detail.youtube.link"
        static let sourceLink = "detail.source.link"
    }

    enum StateView {
        static let empty = "state.empty"
        static let retry = "state.error.retry"
    }
}
