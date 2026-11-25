//
//  ProblemDetailViewModel.swift
//  Keeps the detail screen in sync with the store (so edits show immediately).
//

import Foundation

final class ProblemDetailViewModel: ObservableObject {
    @Published private(set) var problem: Problem?
    private let store: ProblemStore
    private let problemID: UUID

    init(store: ProblemStore, problemID: UUID) {
        self.store = store
        self.problemID = problemID
        self.problem = store.problems.first { $0.id == problemID }
        store.$problems
            .map { list in list.first { $0.id == problemID } }
            .assign(to: &$problem)
    }

    /// Quick status change (e.g. move to Solved after revisiting).
    func setStatus(_ status: SolveStatus) {
        guard var current = problem else { return }
        current.status = status
        store.update(current)
    }

    func delete() {
        store.delete(ids: [problemID])
    }
}
