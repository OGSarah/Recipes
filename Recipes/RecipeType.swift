//
//  RecipeType.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import Foundation

enum RecipeType: String, CaseIterable, Codable, Identifiable {
    case all = "All"
    var id: String { self.rawValue }
}
