//
// RootTabView.swift
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

/// The app shell: a three-tab layout (Browse / Search / Favorites), each its own
/// navigation stack. Installs the shared image-caching `URLSession` for every `AsyncImage`
/// in the subtree.
struct RootTabView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            Tab("Browse", systemImage: "square.grid.2x2") {
                BrowseView(dependencies: dependencies)
            }

            Tab("Search", systemImage: "magnifyingglass") {
                SearchView(dependencies: dependencies)
            }

            Tab("Favorites", systemImage: "heart") {
                FavoritesView(dependencies: dependencies)
            }
        }
        .tint(Color.appIconOrange)
        .asyncImageURLSession(dependencies.imageSession)
    }
}

// MARK: Previews
#Preview("Light") {
    RootTabView(dependencies: .preview())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    RootTabView(dependencies: .preview())
        .preferredColorScheme(.dark)
}
