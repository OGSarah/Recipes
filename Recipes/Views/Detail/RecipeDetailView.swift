//
// RecipeDetailView.swift
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

/// The full recipe screen: hero image, ingredients, instructions, external links, and a
/// favorite toggle. Works whether opened from a lightweight summary (Browse) or a full
/// detail already in hand (Search / Favorites).
struct RecipeDetailView: View {
    @State private var model: RecipeDetailViewModel

    init(dependencies: AppDependencies, source: RecipeDetailViewModel.Source) {
        _model = State(
            initialValue: RecipeDetailViewModel(
                source: source,
                provider: dependencies.recipeProvider,
                store: dependencies.favoritesStore
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = model.detail {
                    detailContent(detail)
                } else if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                } else if let error = model.error {
                    EmptyStateView(
                        title: "Couldn't load recipe",
                        subtitle: error.localizedDescription,
                        systemImage: "exclamationmark.triangle",
                        retry: { Task { await model.load() } }
                    )
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await model.toggleFavorite() }
                } label: {
                    Image(systemName: model.isFavorite ? "heart.fill" : "heart")
                }
                .tint(Color.appIconOrange)
                .disabled(model.detail == nil)
                .accessibilityIdentifier(AccessibilityID.Detail.favoriteButton)
                .accessibilityLabel(model.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
        .task { await model.load() }
    }

    @ViewBuilder private func detailContent(_ detail: MealDetail) -> some View {
        RemoteImage(url: detail.thumbnailURL, cornerRadius: 20)
            .frame(height: 240)
            .frame(maxWidth: .infinity)

        Text(detail.name)
            .font(.title.bold())
            .foregroundStyle(Color.appIconBrown)
            .accessibilityIdentifier(AccessibilityID.Detail.title)

        HStack(spacing: 8) {
            if let category = detail.category { chip(category, systemImage: "tag") }
            if let area = detail.area { chip(area, systemImage: "globe") }
        }

        if !detail.ingredients.isEmpty {
            sectionHeader("Ingredients")
            VStack(spacing: 0) {
                ForEach(detail.ingredients) { ingredient in
                    IngredientRow(ingredient: ingredient)
                    if ingredient.id != detail.ingredients.last?.id {
                        Divider().padding(.leading, 14)
                    }
                }
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.appIconCream.opacity(0.6)))
        }

        if let instructions = detail.instructions {
            sectionHeader("Instructions")
            Text(instructions)
                .font(.body)
                .foregroundStyle(Color.appIconBrown.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }

        VStack(alignment: .leading, spacing: 12) {
            if let youtube = detail.youtubeURL {
                Link(destination: youtube) {
                    Label("Watch on YouTube", systemImage: "play.rectangle.fill")
                }
                .tint(Color.appIconOrange)
                .accessibilityIdentifier(AccessibilityID.Detail.youtubeLink)
            }
            if let source = detail.sourceURL {
                Link(destination: source) {
                    Label("View Original Recipe", systemImage: "link")
                }
                .tint(Color.appIconOrange)
                .accessibilityIdentifier(AccessibilityID.Detail.sourceLink)
            }
        }
        .padding(.top, 4)
    }

    private func chip(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.appIconBrown)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.appIconAmber.opacity(0.4)))
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(Color.appIconOrange)
            .padding(.top, 8)
    }
}

// MARK: Previews
#Preview("Light") {
    NavigationStack {
        RecipeDetailView(dependencies: .preview(), source: .detail(.preview))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        RecipeDetailView(dependencies: .preview(), source: .detail(.preview))
    }
    .preferredColorScheme(.dark)
}
