//
// BrowseView.swift
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

/// The Browse tab: a grid of meal categories and a list of cuisine areas to drill into.
struct BrowseView: View {
    private let dependencies: AppDependencies
    @State private var model: BrowseViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _model = State(initialValue: BrowseViewModel(provider: dependencies.recipeProvider))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                content
            }
            .navigationTitle("Browse")
            .navigationDestination(for: MealListViewModel.Filter.self) { filter in
                MealListView(dependencies: dependencies, filter: filter)
            }
            .navigationDestination(for: MealSummary.self) { summary in
                RecipeDetailView(dependencies: dependencies, source: .summary(summary))
            }
        }
        .task { await model.loadIfNeeded() }
    }

    @ViewBuilder private var content: some View {
        if model.isLoading && model.categories.isEmpty {
            ProgressView()
        } else if let error = model.error, model.categories.isEmpty {
            EmptyStateView(
                title: "Couldn't load",
                subtitle: error.localizedDescription,
                systemImage: "exclamationmark.triangle",
                retry: { Task { await model.load() } }
            )
            .padding()
        } else {
            ScrollView {
                Picker("Browse mode", selection: $model.mode) {
                    ForEach(BrowseViewModel.Mode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])
                .accessibilityIdentifier(AccessibilityID.Browse.modePicker)

                switch model.mode {
                    case .categories: categoryGrid
                    case .areas: areaList
                }
            }
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(model.categories) { category in
                NavigationLink(value: MealListViewModel.Filter.category(category.name)) {
                    CategoryCard(category: category)
                        .accessibilityIdentifier(AccessibilityID.Browse.categoryCell(category.name))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }

    private var areaList: some View {
        LazyVStack(spacing: 12) {
            ForEach(model.areas) { area in
                NavigationLink(value: MealListViewModel.Filter.area(area.name)) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundStyle(Color.appIconOrange)
                            .accessibilityHidden(true)
                        Text(area.name)
                            .font(.headline)
                            .foregroundStyle(Color.appIconBrown)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundStyle(Color.appIconBrown.opacity(0.4))
                            .accessibilityHidden(true)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.appIconCream.opacity(0.7)))
                    .accessibilityIdentifier(AccessibilityID.Browse.areaCell(area.name))
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

// MARK: Previews
#Preview("Light") {
    BrowseView(dependencies: .preview())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    BrowseView(dependencies: .preview())
        .preferredColorScheme(.dark)
}
