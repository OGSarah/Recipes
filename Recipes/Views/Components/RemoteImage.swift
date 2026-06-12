//
// RemoteImage.swift
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

/// A cached, rounded remote image with branded loading and failure placeholders.
///
/// Uses the iOS 27 `AsyncImage(request:)` initializer with `.returnCacheDataElseLoad`, so
/// thumbnails are served from the `URLCache` supplied via `.asyncImageURLSession(_:)` at
/// the app root instead of re-downloading on every scroll.
struct RemoteImage: View {
    let url: URL?
    var cornerRadius: CGFloat = 12
    var placeholderSymbol: String = "fork.knife"

    var body: some View {
        Group {
            if let url {
                AsyncImage(
                    request: URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
                ) { phase in
                    switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        case .failure:
                            placeholder
                        case .empty:
                            loading
                        @unknown default:
                            placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        ZStack {
            Rectangle().fill(Color.appIconCream)
            Image(systemName: placeholderSymbol)
                .font(.title)
                .foregroundStyle(Color.appIconOrange.opacity(0.55))
        }
    }

    private var loading: some View {
        ZStack {
            Rectangle().fill(Color.appIconCream)
            ProgressView()
        }
    }
}

/// A meal thumbnail that requests the resized TheMealDB variant for the given `size`.
struct MealThumbnail: View {
    let url: URL?
    var size: MealImageSize = .small
    var cornerRadius: CGFloat = 12

    var body: some View {
        RemoteImage(
            url: url?.mealThumbnail(size),
            cornerRadius: cornerRadius,
            placeholderSymbol: "fork.knife"
        )
    }
}
