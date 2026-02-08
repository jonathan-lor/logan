//
//  FeedViewModel.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class FeedViewModel {

    private(set) var modules: [Module] = []
    private(set) var isLoadingModules = false

    func loadModules() async {
        guard !isLoadingModules else { return }
        isLoadingModules = true
        defer { isLoadingModules = false }

        do {
            let module: Module = try await APIClient.shared.getItem("/questions/random?tag=Pokemon")
            modules.append(module)
        } catch {
            print("Failed to load module: \(error)")
        }
    }
}
