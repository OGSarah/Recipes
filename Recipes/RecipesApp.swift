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
            if existing.isEmpty {
                for recipe in Recipe.sampleRecipeData {
                    modelContainer.mainContext.insert(recipe)
                }
            }
        } catch {
            print("Failed to seed Recipe data: \(error)")
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
