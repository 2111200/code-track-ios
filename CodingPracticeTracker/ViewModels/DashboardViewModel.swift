//
//  DashboardViewModel.swift
//  Computes the summary statistics shown on the home screen.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published private(set) var total = 0
    @Published private(set) var solved = 0
    @Published private(set) var revisit = 0
    @Published private(set) var mostPracticedTopic = "—"
    @Published private(set) var recent: [Problem] = []

    private var cancellable: AnyCancellable?

    init(store: ProblemStore) {
        update(with: store.problems)
        cancellable = store.$problems.sink { [weak self] problems in
            self?.update(with: problems)
        }
    }

    private func update(with problems: [Problem]) {
        total = problems.count
        solved = problems.filter { $0.status == .solved }.count
        revisit = problems.filter { $0.status == .revisitLater }.count
        recent = Array(problems.sorted { $0.date > $1.date }.prefix(3))

        let counts = Dictionary(grouping: problems, by: \.topic).mapValues(\.count)
        let top = counts.max { a, b in
            a.value == b.value ? a.key.rawValue > b.key.rawValue : a.value < b.value
        }
        mostPracticedTopic = top?.key.rawValue ?? "—"
    }
}
