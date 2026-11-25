//
//  ProblemStore.swift
//  Single source of truth for problems. Persists to a JSON file in the Documents folder
//  so data survives app restarts. All ViewModels observe `problems`.
//

import Foundation

final class ProblemStore: ObservableObject {
    @Published private(set) var problems: [Problem] = []
    private let fileURL: URL

    init(fileName: String = "problems.json") {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent(fileName)
        load()
    }

    // MARK: - CRUD

    /// Adds a new problem; it appears in every list immediately.
    func add(_ problem: Problem) {
        problems.insert(problem, at: 0)
        save()
    }

    /// Replaces an existing problem that has the same id.
    func update(_ problem: Problem) {
        guard let index = problems.firstIndex(where: { $0.id == problem.id }) else { return }
        problems[index] = problem
        save()
    }

    /// Deletes problems by id.
    func delete(ids: [UUID]) {
        problems.removeAll { ids.contains($0.id) }
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            problems = Self.sampleData        // first launch: seed demo data
            save()
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            problems = try JSONDecoder().decode([Problem].self, from: data)
        } catch {
            problems = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(problems)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Failed to save problems: \(error)")
        }
    }

    // MARK: - Sample data

    private static var sampleData: [Problem] {
        let day: TimeInterval = 86_400
        let now = Date()
        return [
            Problem(title: "Two Sum", platform: .leetCode, topic: .arrays, difficulty: .easy, status: .solved,
                    date: now, approachNotes: "Use a hash map to store value -> index. One pass, O(n).", timeTaken: 15),
            Problem(title: "Valid Anagram", platform: .leetCode, topic: .strings, difficulty: .easy, status: .solved,
                    date: now - day, approachNotes: "Count characters with a dictionary and compare.", timeTaken: 10),
            Problem(title: "Merge Intervals", platform: .leetCode, topic: .sorting, difficulty: .medium, status: .revisitLater,
                    date: now - 2 * day, approachNotes: "Sort by start, then merge overlapping ranges. Edge cases need rework.", timeTaken: 40),
            Problem(title: "Generate Parentheses", platform: .geeksForGeeks, topic: .recursion, difficulty: .medium, status: .attempted,
                    date: now - 3 * day, approachNotes: "Backtracking with open/close counters.", timeTaken: 35),
            Problem(title: "Word Break", platform: .leetCode, topic: .dynamicProgramming, difficulty: .hard, status: .revisitLater,
                    date: now - 4 * day, approachNotes: "DP over prefixes. Could not finish independently.", timeTaken: 60),
            Problem(title: "Binary Tree Level Order", platform: .hackerRank, topic: .trees, difficulty: .medium, status: .solved,
                    date: now - 5 * day, approachNotes: "BFS with a queue.", timeTaken: 25)
        ]
    }
}
