//
//  Cookbook.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import Foundation
import SwiftData

@Model
class Cookbook {
    @Relationship var recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

}
