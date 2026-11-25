//
//  ProblemListViewModel.swift
//  Search + filter + delete logic for the problem list.
//

import Foundation
import Combine

final class ProblemListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedTopic: Topic?
    @Published var selectedDifficulty: Difficulty?
    @Published var selectedStatus: SolveStatus?
    @Published private(set) var problems: [Problem] = []

    private let store: ProblemStore
    private var cancellable: AnyCancellable?

    init(store: ProblemStore, initialStatus: SolveStatus? = nil) {
        self.store = store
        self.selectedStatus = initialStatus
        self.problems = store.problems
        cancellable = store.$problems.sink { [weak self] in self?.problems = $0 }
    }

    /// Problems after applying title search and topic/difficulty/status filters.
    var filteredProblems: [Problem] {
        problems.filter { problem in
            let matchesSearch = searchText.trimmingCharacters(in: .whitespaces).isEmpty
                || problem.title.localizedCaseInsensitiveContains(searchText)
            let matchesTopic = selectedTopic == nil || problem.topic == selectedTopic
            let matchesDifficulty = selectedDifficulty == nil || problem.difficulty == selectedDifficulty
            let matchesStatus = selectedStatus == nil || problem.status == selectedStatus
            return matchesSearch && matchesTopic && matchesDifficulty && matchesStatus
        }
    }

    var hasActiveFilters: Bool {
        selectedTopic != nil || selectedDifficulty != nil || selectedStatus != nil
    }

    func clearFilters() {
        selectedTopic = nil
        selectedDifficulty = nil
        selectedStatus = nil
    }

    /// Swipe-to-delete: offsets refer to the *filtered* list.
    func delete(at offsets: IndexSet) {
        let list = filteredProblems
        store.delete(ids: offsets.map { list[$0].id })
    }
}
