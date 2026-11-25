//
//  ProblemRowView.swift
//  One problem card/row: title, topic, difficulty and solve status.
//

import SwiftUI

struct ProblemRowView: View {
    let problem: Problem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(problem.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                StatusBadge(status: problem.status)
            }
            HStack(spacing: 10) {
                Label(problem.topic.rawValue, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                DifficultyBadge(difficulty: problem.difficulty)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
