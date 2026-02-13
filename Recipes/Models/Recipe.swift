//
//  Recipes.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import Foundation
import SwiftData

@Model
class Recipe {
    var title: String
    var servings: Int

    init(title: String, servings: Int) {
        self.title = title
        self.servings = servings
    }

    @MainActor static let sampleRecipeData = [
        Recipe(title: "Spaghetti Carbonara", servings: 4),
        Recipe(title: "Chicken Tikka Masala", servings: 6),
        Recipe(title: "Beef Wellington", servings: 8),
    ]

}
