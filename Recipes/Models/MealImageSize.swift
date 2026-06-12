//
// MealImageSize.swift
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

/// A resized-thumbnail variant served by TheMealDB.
///
/// TheMealDB exposes smaller renditions of a meal thumbnail by appending
/// `/small`, `/medium`, etc. to the *full* image URL (extension included) — useful for
/// keeping list scrolling light while reserving the full image for the detail hero.
nonisolated enum MealImageSize: String, Sendable, CaseIterable {
    case small
    case medium
    case large
    case preview
}

extension URL {
    /// Returns the resized variant of a TheMealDB meal thumbnail.
    ///
    /// Given `.../meals/abc123.jpg`, `.mealThumbnail(.small)` yields `.../meals/abc123.jpg/small`.
    /// The size is appended as a path component to the full URL — the `.jpg` extension is kept,
    /// since TheMealDB serves the rendition at `<image>.jpg/<size>` (the form that omits the
    /// extension, `<image>/<size>.jpg`, 404s).
    nonisolated func mealThumbnail(_ size: MealImageSize) -> URL {
        appendingPathComponent(size.rawValue)
    }
}
