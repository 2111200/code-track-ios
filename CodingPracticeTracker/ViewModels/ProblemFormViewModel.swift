//
//  ProblemFormViewModel.swift
//  Shared by the Add and Edit screens: holds form state, validates and saves.
//

import Foundation

final class ProblemFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var platform: Platform = .leetCode
    @Published var topic: Topic = .arrays
    @Published var difficulty: Difficulty = .easy
    @Published var status: SolveStatus = .attempted
    @Published var date = Date()
    @Published var approachNotes = ""
    @Published var timeTaken = ""

    @Published private(set) var titleError: String?
    @Published private(set) var timeError: String?

    private let store: ProblemStore
    private let existing: Problem?

    var isEditing: Bool { existing != nil }

    /// Pass a problem to edit it, or nil to add a new one.
    init(store: ProblemStore, problem: Problem? = nil) {
        self.store = store
        self.existing = problem
        if let problem {
            title = problem.title
            platform = problem.platform
            topic = problem.topic
            difficulty = problem.difficulty
            status = problem.status
            date = problem.date
            approachNotes = problem.approachNotes
            timeTaken = String(problem.timeTaken)
        }
    }

    /// Validates and saves. Returns true on success so the view can dismiss.
    func save() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        titleError = trimmedTitle.count < 3 ? "Title must be at least 3 characters." : nil

        let minutes = Int(timeTaken.trimmingCharacters(in: .whitespaces))
        if let minutes, (1...600).contains(minutes) {
            timeError = nil
        } else {
            timeError = "Enter time in minutes (1–600)."
        }

        guard titleError == nil, timeError == nil, let minutes else { return false }

        var problem = existing ?? Problem(title: trimmedTitle, platform: platform, topic: topic,
                                          difficulty: difficulty, status: status, date: date,
                                          approachNotes: "", timeTaken: minutes)
        problem.title = trimmedTitle
        problem.platform = platform
        problem.topic = topic
        problem.difficulty = difficulty
        problem.status = status
        problem.date = date
        problem.approachNotes = approachNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        problem.timeTaken = minutes

        if isEditing { store.update(problem) } else { store.add(problem) }
        return true
    }
}
