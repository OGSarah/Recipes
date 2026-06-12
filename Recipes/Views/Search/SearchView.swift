//
// SearchView.swift
// Recipes
//
// MIT License
//
// Copyright (c) 2026 SarahUniverse
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import SwiftUI

/// The Search tab: debounced search of TheMealDB by recipe name.
struct SearchView: View {
    private let dependencies: AppDependencies
    @State private var model: SearchViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _model = State(initialValue: SearchViewModel(provider: dependencies.recipeProvider))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                content
            }
            .navigationTitle("Search")
            .navigationDestination(for: MealDetail.self) { detail in
                RecipeDetailView(dependencies: dependencies, source: .detail(detail))
            }
            .searchable(text: $model.query, prompt: "Search recipes by name")
            .task(id: model.query) { await model.search() }
        }
    }

    @ViewBuilder private var content: some View {
        if model.isLoading {
            ProgressView()
        } else if let error = model.error {
            EmptyStateView(
                title: "Search failed",
                subtitle: error.localizedDescription,
                systemImage: "exclamationmark.triangle"
            )
            .padding()
        } else if model.results.isEmpty && model.hasSearched {
            EmptyStateView(
                title: "No matches",
                subtitle: "No recipes matched your search.",
                systemImage: "magnifyingglass"
            )
            .padding()
        } else if model.results.isEmpty {
            EmptyStateView(
                title: "Find a recipe",
                subtitle: "Search TheMealDB by name to get cooking.",
                systemImage: "magnifyingglass"
            )
            .padding()
        } else {
            List(model.results) { detail in
                NavigationLink(value: detail) {
                    MealRow(detail: detail)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: Previews
#Preview("Light") {
    SearchView(dependencies: .preview())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    SearchView(dependencies: .preview())
        .preferredColorScheme(.dark)
}
