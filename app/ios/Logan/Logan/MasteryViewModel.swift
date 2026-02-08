//
//  MasteryViewModel.swift
//  Logan
//
//  Created by jon on 2/8/26.
//

import Foundation

@MainActor @Observable
final class MasteryViewModel {
    private(set) var scores: [String: Int] = [:]
    private(set) var recentModules: [String: [Module]] = [:]

    func recordResult(module: Module, correct: Bool) {
        for tag in module.tags {
            let key = tag.titleCased
            if correct {
                scores[key, default: 0] += 1
            } else {
                let current = scores[key, default: 0]
                scores[key] = max(current - 1, 0)
            }
            var list = recentModules[key, default: []]
            list.insert(module, at: 0)
            if list.count > 5 { list = Array(list.prefix(5)) }
            recentModules[key] = list
        }
    }
}

private extension String {
    var titleCased: String {
        self.lowercased()
            .split(separator: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}
