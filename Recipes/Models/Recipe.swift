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
    var prepTimeMinutes: Int = 0
    var summary: String = ""
    var imageName: String = "fork.knife"
    var ingredients: [String] = []

    init(
        title: String,
        servings: Int,
        prepTimeMinutes: Int,
        summary: String,
        imageName: String,
        ingredients: [String]
    ) {
        self.title = title
        self.servings = servings
        self.prepTimeMinutes = prepTimeMinutes
        self.summary = summary
        self.imageName = imageName
        self.ingredients = ingredients
    }

    @MainActor static let sampleRecipeData = [
        Recipe(
            title: "Spaghetti Carbonara",
            servings: 4,
            prepTimeMinutes: 25,
            summary: "Silky, peppery pasta with pancetta and a rich egg sauce.",
            imageName: "fork.knife",
            ingredients: [
                "Spaghetti",
                "Pancetta",
                "Eggs",
                "Parmesan",
                "Black pepper"
            ]
        ),
        Recipe(
            title: "Chicken Tikka Masala",
            servings: 6,
            prepTimeMinutes: 45,
            summary: "Charred chicken simmered in a creamy tomato-spice sauce.",
            imageName: "flame",
            ingredients: [
                "Chicken thighs",
                "Yogurt",
                "Tomatoes",
                "Garam masala",
                "Cream"
            ]
        ),
        Recipe(
            title: "Beef Wellington",
            servings: 8,
            prepTimeMinutes: 90,
            summary: "Herb-coated beef wrapped in mushroom duxelles and pastry.",
            imageName: "leaf",
            ingredients: [
                "Beef tenderloin",
                "Mushrooms",
                "Prosciutto",
                "Puff pastry",
                "Dijon mustard"
            ]
        ),
    ]

}
