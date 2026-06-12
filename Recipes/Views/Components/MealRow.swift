//
// MealRow.swift
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

/// A compact list row showing a meal's thumbnail, name, and optional subtitle.
struct MealRow: View {
    let id: String
    let name: String
    let subtitle: String?
    let thumbnailURL: URL?

    var body: some View {
        HStack(spacing: 12) {
            MealThumbnail(url: thumbnailURL, size: .small, cornerRadius: 10)
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(Color.appIconBrown)
                    .lineLimit(2)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.appIconBrown.opacity(0.7))
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(AccessibilityID.Meal.row(id))
    }
}

extension MealRow {
    init(summary: MealSummary) {
        self.init(id: summary.id, name: summary.name, subtitle: nil, thumbnailURL: summary.thumbnailURL)
    }

    init(detail: MealDetail) {
        self.init(id: detail.id, name: detail.name, subtitle: detail.category, thumbnailURL: detail.thumbnailURL)
    }
}

// MARK: Previews
#Preview("Light") {
    List {
        MealRow(detail: .preview)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    List {
        MealRow(detail: .preview)
    }
    .preferredColorScheme(.dark)
}
