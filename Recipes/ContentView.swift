//
//  ContentView.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @State private var recipeType: RecipeType = .all

  var body: some View {
    NavigationSplitView {
      Picker("Recipe Type", selection: $recipeType) {
        ForEach(RecipeType.allCases) { recipeType in
          Text(recipeType.rawValue)
            .tag(recipeType)
        }
      }
      .pickerStyle(SegmentedPickerStyle())

      List {
        ForEach(recipes, id: \.title) { item in
          NavigationLink {
            VStack {
              Text(item.title)
              Text("Servings: \(item.servings)")
            }
            .navigationTitle(item.title)
          } label: {
            Text(item.title)
          }
        }
        .navigationTitle("Recipes")
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
    } detail: {
      Text("Select an item")
    }
  }

}

// MARK: Previews
#Preview("Light Mode") {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .modelContainer(for: Recipe.self, inMemory: true)
        .preferredColorScheme(.dark)
}
