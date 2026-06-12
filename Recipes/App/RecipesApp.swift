//
// RecipesApp.swift
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

/// The composition root. Builds the live dependency graph once and hands it to the UI;
/// SwiftData and `URLSession` stay encapsulated behind the injected services.
@main
struct RecipesApp: App {
    @State private var dependencies = RecipesApp.makeDependencies()

    var body: some Scene {
        WindowGroup {
            RootTabView(dependencies: dependencies)
        }
    }

    /// Selects the dependency graph for this launch. UI tests pass `-uitest-stub` to run
    /// hermetically against mocked services; when the app is merely hosting a unit-test
    /// bundle, it also uses the in-memory graph so it never touches the network or disk.
    private static func makeDependencies() -> AppDependencies {
        #if DEBUG
        let process = ProcessInfo.processInfo
        let isRunningUnitTests = process.environment["XCTestConfigurationFilePath"] != nil
        if isRunningUnitTests || process.arguments.contains("-uitest-stub") {
            return .preview()
        }
        #endif
        return .live()
    }
}
