//
// CategoryCard.swift
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

/// A grid tile for a meal category, showing its artwork and name.
struct CategoryCard: View {
    let category: MealCategory

    var body: some View {
        VStack(spacing: 8) {
            RemoteImage(url: category.thumbnailURL, cornerRadius: 16, placeholderSymbol: "square.grid.2x2")
                .frame(height: 110)
                .frame(maxWidth: .infinity)

            Text(category.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.appIconBrown)
                .lineLimit(1)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.appIconCream.opacity(0.65))
        )
        .accessibilityElement(children: .combine)
    }
}

// MARK: Previews
#Preview("Light") {
    CategoryCard(category: .preview)
        .frame(width: 170)
        .padding()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CategoryCard(category: .preview)
        .frame(width: 170)
        .padding()
        .preferredColorScheme(.dark)
}
