//
// EmptyStateView.swift
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

/// A reusable placeholder for empty, loading-failed, and "nothing selected" states.
///
/// An optional `systemImage` adds a glyph and an optional `retry` action renders a button —
/// so the same view covers "no favorites yet", "search failed, try again", and the
/// detail-pane placeholder.
struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String?
    let retry: (() -> Void)?

    init(
        title: String = "Select a recipe",
        subtitle: String = "Pick something delicious from the list.",
        systemImage: String? = nil,
        retry: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.retry = retry
    }

    var body: some View {
        VStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 42))
                    .foregroundStyle(Color.appIconOrange)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appIconBrown)

            Text(subtitle)
                .font(.callout)
                .foregroundStyle(Color.appIconBrown.opacity(0.7))
                .multilineTextAlignment(.center)

            if let retry {
                Button("Try Again", action: retry)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.appIconOrange)
                    .padding(.top, 4)
                    .accessibilityIdentifier(AccessibilityID.StateView.retry)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.appIconCream.opacity(0.9))
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityID.StateView.empty)
    }
}

// MARK: Previews
#Preview("Light") {
    EmptyStateView(
        title: "No favorites yet",
        subtitle: "Tap the heart on a recipe to save it here.",
        systemImage: "heart"
    )
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    EmptyStateView(
        title: "Couldn't load",
        subtitle: "Something went wrong. Please try again.",
        systemImage: "exclamationmark.triangle",
        retry: {}
    )
    .padding()
    .preferredColorScheme(.dark)
}
