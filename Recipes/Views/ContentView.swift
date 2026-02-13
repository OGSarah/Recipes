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
    @State private var isShowingAddRecipe = false
    @State private var searchText = ""
    @AppStorage("recipes.sortOption") private var sortOptionRawValue = SortOption.title.rawValue

    var body: some View {
        NavigationSplitView {
            ZStack {
                appIconBackground

                VStack(spacing: 16) {
                    headerView

                    if recipes.isEmpty {
                        EmptyStateView(
                            title: "No recipes yet",
                            subtitle: "Tap + to add your first recipe."
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
                    } else if filteredRecipes.isEmpty {
                        EmptyStateView(
                            title: "No matches",
                            subtitle: "Try a different search."
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
                    } else {
                        List {
                            ForEach(filteredRecipes, id: \.persistentModelID) { item in
                                NavigationLink {
                                    RecipeDetailView(recipe: item)
                                } label: {
                                    RecipeRow(recipe: item)
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.appIconCream.opacity(0.9))
                                )
                            }
                            .onDelete(perform: requestDelete)
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddRecipe = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                    .tint(Color.appIconLeaf)

                    Menu {
                        Picker("Sort", selection: $sortOptionRawValue) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.title).tag(option.rawValue)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    .tint(Color.appIconLeaf)

                    if !recipes.isEmpty {
                        EditButton()
                            .tint(Color.appIconLeaf)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search recipes")
            .sheet(isPresented: $isShowingAddRecipe) {
                NavigationStack {
                    AddRecipeView()
                }
            }
        } detail: {
            ZStack {
                appIconBackground
                EmptyStateView()
            }
        }
    }

    private func requestDelete(at offsets: IndexSet) {
        deleteRecipes(at: offsets)
    }

    private func deleteRecipes(at offsets: IndexSet) {
        let targets: [Recipe] = offsets.compactMap { index in
            guard filteredRecipes.indices.contains(index) else { return nil }
            return filteredRecipes[index]
        }

        for recipe in targets {
            modelContext.delete(recipe)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete recipe: \(error)")
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("A place to store your family recipes.")
                .font(Font.callout)
                .foregroundStyle(Color.appIconBrown.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var filteredRecipes: [Recipe] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = trimmedSearch.isEmpty
            ? recipes
            : recipes.filter { recipe in
                let haystack = [
                    recipe.title,
                    recipe.summary,
                    recipe.ingredients.joined(separator: " ")
                ]
                .joined(separator: " ")
                .lowercased()
                return haystack.contains(trimmedSearch.lowercased())
            }

        return filtered.sorted { lhs, rhs in
            switch resolvedSortOption {
            case .title:
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            case .prepTime:
                return lhs.prepTimeMinutes < rhs.prepTimeMinutes
            case .servings:
                return lhs.servings < rhs.servings
            }
        }
    }

    private var resolvedSortOption: SortOption {
        SortOption(rawValue: sortOptionRawValue) ?? .title
    }

    private var appIconBackground: some View {
        LinearGradient(
            colors: [
                Color.appIconGold.opacity(0.95),
                Color.appIconAmber.opacity(0.85),
                Color.appIconOrange.opacity(0.75)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private enum SortOption: String, CaseIterable, Identifiable {
    case title
    case prepTime
    case servings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .title:
            return "Title"
        case .prepTime:
            return "Prep time"
        case .servings:
            return "Servings"
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
