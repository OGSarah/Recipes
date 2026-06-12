//
// Color+Extensions.swift
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

import SwiftUI

// The theme is mapped onto standard iOS system colors. These are tuned by the
// system for legibility and adapt to light/dark mode automatically, so content
// stays readable everywhere. The names are kept for their semantic roles
// (primary text, surface, accent, etc.) so call sites don't have to change.
extension Color {
    /// Decorative accent. System yellow.
    static let appIconGold = Color.yellow

    /// Soft fill used for chips and pills. Neutral system fill.
    static let appIconAmber = Color(uiColor: .secondarySystemFill)

    /// Primary accent / tint. System orange keeps the warm recipe identity.
    static let appIconOrange = Color.orange

    /// Primary text color. System label — high contrast in light and dark.
    static let appIconBrown = Color.primary

    /// Surface / card fill. Standard secondary grouped background.
    static let appIconCream = Color(uiColor: .secondarySystemGroupedBackground)

    /// Confirmation color (e.g. ingredient checkmarks). System green.
    static let appIconLeaf = Color.green
}
