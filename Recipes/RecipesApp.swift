//
//  RecipesApp.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftUI
import SwiftData

@main
struct RecipesApp: App {
    var sharedModelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        let schema = Schema([
            Cookbook.self, Recipe.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        do {
          let descriptor = FetchDescriptor<Recipe>()
          let existing = try modelContainer.mainContext.fetch(descriptor)
          for object in existing {
            modelContainer.mainContext.delete(object)
          }
        } catch {
          print("Failed to clear existing Recipe data: \(error)")
        }
        for recipe in Recipe.sampleRecipeData {
          modelContainer.mainContext.insert(recipe)
        }
        return modelContainer
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }

}
