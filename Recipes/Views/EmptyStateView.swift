//
//  EmptyStateView.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String

    init(title: String = "Select a recipe", subtitle: String = "Pick something delicious from the list.") {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appIconBrown)

            Text(subtitle)
                .font(.callout)
                .foregroundStyle(Color.appIconBrown.opacity(0.7))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.appIconCream.opacity(0.9))
        )
    }
}

#Preview {
    EmptyStateView()
}
