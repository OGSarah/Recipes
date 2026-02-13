//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: recipe.imageName)
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(Color.appIconBrown)
                .padding(18)
                .background(
                    Circle()
                        .fill(Color.appIconCream.opacity(0.95))
                )

            Text(recipe.title)
                .font(.title.weight(.semibold))
                .foregroundStyle(Color.appIconBrown)

            Text("Servings: \(recipe.servings)")
                .font(.title3)
                .foregroundStyle(Color.appIconBrown.opacity(0.75))

            Text("Prep time: \(recipe.prepTimeMinutes) min")
                .font(.headline)
                .foregroundStyle(Color.appIconBrown.opacity(0.8))

            Text(recipe.summary)
                .font(.body)
                .foregroundStyle(Color.appIconBrown.opacity(0.8))
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Ingredients")
                    .font(.headline)
                    .foregroundStyle(Color.appIconBrown)

                if recipe.ingredients.isEmpty {
                    Text("No ingredients listed.")
                        .font(.callout)
                        .foregroundStyle(Color.appIconBrown.opacity(0.7))
                } else {
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                            .font(.callout)
                            .foregroundStyle(Color.appIconBrown.opacity(0.85))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.appIconCream.opacity(0.9))
                .padding()
        )
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe.sampleRecipeData[0])
}
