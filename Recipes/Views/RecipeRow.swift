//
//  RecipeRow.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.appIconLeaf)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.appIconCream, lineWidth: 2)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundStyle(Color.appIconBrown)

                Text("Servings: \(recipe.servings)")
                    .font(.subheadline)
                    .foregroundStyle(Color.appIconBrown.opacity(0.7))
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// MARK: Previews
#Preview("Light") {
    RecipeRow(recipe: Recipe.sampleRecipeData[0])
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    RecipeRow(recipe: Recipe.sampleRecipeData[0])
        .preferredColorScheme(.dark)
}
