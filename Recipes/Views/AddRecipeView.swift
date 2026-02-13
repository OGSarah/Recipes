//
//  AddRecipeView.swift
//  Recipes
//
//  Created by Sarah Clark on 2/13/26.
//

import SwiftData
import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var servings: Int = 2
    @State private var prepTimeMinutes: Int = 20
    @State private var summary: String = ""
    @State private var imageName: String = "fork.knife"
    @State private var ingredientsText: String = ""
    @State private var showValidationErrors = false

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title *", text: $title)
                if showValidationErrors && trimmedTitle.isEmpty {
                    Text("Title is required.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Stepper("Servings: \(servings)", value: $servings, in: 1...20)
                Stepper("Prep time: \(prepTimeMinutes) min", value: $prepTimeMinutes, in: 0...240, step: 5)

                Picker("Icon", selection: $imageName) {
                    ForEach(iconOptions, id: \.self) { icon in
                        Label(iconLabel(for: icon), systemImage: icon)
                            .tag(icon)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Summary *")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $summary)
                        .frame(minHeight: 80)
                    if showValidationErrors && trimmedSummary.isEmpty {
                        Text("Summary is required.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }

            Section("Ingredients *") {
                TextEditor(text: $ingredientsText)
                    .frame(minHeight: 120)
                Text("One ingredient per line.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if showValidationErrors && cleanedIngredients.isEmpty {
                    Text("Add at least one ingredient.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("New Recipe")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(.red)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    attemptSave()
                }
                .foregroundStyle(canSave ? Color.appIconLeaf : .secondary)
                .disabled(!canSave)
            }
        }
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedSummary: String {
        summary.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var cleanedImageName: String {
        let trimmed = imageName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "fork.knife" : trimmed
    }

    private let iconOptions: [String] = [
        "fork.knife",
        "flame",
        "leaf",
        "carrot",
        "takeoutbag.and.cup.and.straw",
        "birthday.cake",
        "fish",
        "cup.and.saucer",
        "mug",
        "snowflake"
    ]

    private func iconLabel(for icon: String) -> String {
        switch icon {
        case "fork.knife":
            return "Classic"
        case "flame":
            return "Spicy"
        case "leaf":
            return "Fresh"
        case "carrot":
            return "Veggie"
        case "takeoutbag.and.cup.and.straw":
            return "To-go"
        case "birthday.cake":
            return "Dessert"
        case "fish":
            return "Seafood"
        case "cup.and.saucer":
            return "Tea"
        case "mug":
            return "Coffee"
        case "snowflake":
            return "Chilled"
        default:
            return icon
        }
    }

    private var cleanedIngredients: [String] {
        ingredientsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private var validationMessages: [String] {
        var messages: [String] = []

        if trimmedTitle.isEmpty {
            messages.append("Title is required.")
        }

        if trimmedSummary.isEmpty {
            messages.append("Summary is required.")
        }

        if cleanedIngredients.isEmpty {
            messages.append("Add at least one ingredient.")
        }

        return messages
    }

    private var canSave: Bool {
        validationMessages.isEmpty
    }

    private func attemptSave() {
        if canSave {
            saveRecipe()
        } else {
            showValidationErrors = true
        }
    }

    private func saveRecipe() {
        let newRecipe = Recipe(
            title: trimmedTitle,
            servings: servings,
            prepTimeMinutes: prepTimeMinutes,
            summary: trimmedSummary,
            imageName: cleanedImageName,
            ingredients: cleanedIngredients
        )
        modelContext.insert(newRecipe)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        AddRecipeView()
            .modelContainer(for: Recipe.self, inMemory: true)
    }
}
