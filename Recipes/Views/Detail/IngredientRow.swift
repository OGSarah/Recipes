//
// IngredientRow.swift
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

/// A single ingredient line: a bullet, the ingredient name, and its measure.
struct IngredientRow: View {
    let ingredient: Ingredient

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundStyle(Color.appIconLeaf)

            Text(ingredient.name)
                .font(.body)
                .foregroundStyle(Color.appIconBrown)

            Spacer(minLength: 8)

            if let measure = ingredient.measure {
                Text(measure)
                    .font(.subheadline)
                    .foregroundStyle(Color.appIconBrown.opacity(0.7))
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .accessibilityElement(children: .combine)
    }
}

// MARK: Previews
#Preview("Light") {
    VStack(spacing: 0) {
        IngredientRow(ingredient: Ingredient(id: 1, name: "Spaghetti", measure: "200g"))
        IngredientRow(ingredient: Ingredient(id: 2, name: "Pancetta", measure: "100g"))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    IngredientRow(ingredient: Ingredient(id: 1, name: "Parmesan", measure: "50g"))
        .padding()
        .preferredColorScheme(.dark)
}
