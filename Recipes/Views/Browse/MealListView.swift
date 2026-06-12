//
// MealListView.swift
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

/// A drill-down list of meals for a chosen category or cuisine area.
struct MealListView: View {
    private let dependencies: AppDependencies
    @State private var model: MealListViewModel

    init(dependencies: AppDependencies, filter: MealListViewModel.Filter) {
        self.dependencies = dependencies
        _model = State(initialValue: MealListViewModel(provider: dependencies.recipeProvider, filter: filter))
    }

    var body: some View {
        ZStack {
            AppBackground()
            content
        }
        .navigationTitle(model.filter.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await model.loadIfNeeded() }
    }

    @ViewBuilder private var content: some View {
        if model.isLoading && model.meals.isEmpty {
            ProgressView()
        } else if let error = model.error, model.meals.isEmpty {
            EmptyStateView(
                title: "Couldn't load recipes",
                subtitle: error.localizedDescription,
                systemImage: "exclamationmark.triangle",
                retry: { Task { await model.load() } }
            )
            .padding()
        } else if model.meals.isEmpty {
            EmptyStateView(
                title: "No recipes",
                subtitle: "Nothing here yet. Try a different category.",
                systemImage: "fork.knife"
            )
            .padding()
        } else {
            List(model.meals) { meal in
                NavigationLink(value: meal) {
                    MealRow(summary: meal)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: Previews
#Preview("Light") {
    NavigationStack {
        MealListView(dependencies: .preview(), filter: .category("Beef"))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        MealListView(dependencies: .preview(), filter: .area("Italian"))
    }
    .preferredColorScheme(.dark)
}
