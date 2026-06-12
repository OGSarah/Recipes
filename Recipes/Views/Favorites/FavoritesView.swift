//
// FavoritesView.swift
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

/// The Favorites tab: locally-saved recipes available offline, with swipe-to-delete.
struct FavoritesView: View {
    private let dependencies: AppDependencies
    @State private var model: FavoritesViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _model = State(initialValue: FavoritesViewModel(store: dependencies.favoritesStore))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                content
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: MealDetail.self) { detail in
                RecipeDetailView(dependencies: dependencies, source: .detail(detail))
            }
        }
        // Reloads on first appearance and whenever we pop back from a detail toggle.
        .onAppear { Task { await model.load() } }
        .refreshable { await model.load() }
    }

    @ViewBuilder private var content: some View {
        if model.isLoading && model.favorites.isEmpty {
            ProgressView()
        } else if model.favorites.isEmpty {
            EmptyStateView(
                title: "No favorites yet",
                subtitle: "Tap the heart on a recipe to save it here for offline cooking.",
                systemImage: "heart"
            )
            .padding()
        } else {
            List {
                ForEach(model.favorites) { detail in
                    NavigationLink(value: detail) {
                        MealRow(detail: detail)
                    }
                    .accessibilityAction(named: "Delete") {
                        Task { await model.remove(detail) }
                    }
                }
                .onDelete { offsets in
                    Task { await model.remove(at: offsets) }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: Previews
#Preview("Light") {
    FavoritesView(dependencies: .preview(seededFavorites: MealDetail.previewList))
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    FavoritesView(dependencies: .preview())
        .preferredColorScheme(.dark)
}
