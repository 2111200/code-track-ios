//
//  Badges.swift
//  Small reusable UI pieces.
//

import SwiftUI

struct DifficultyBadge: View {
    let difficulty: Difficulty
    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(difficulty.color.opacity(0.15), in: Capsule())
            .foregroundStyle(difficulty.color)
    }
}

struct StatusBadge: View {
    let status: SolveStatus
    var body: some View {
        Label(status.rawValue, systemImage: status.icon)
            .font(.caption.bold())
            .foregroundStyle(status.color)
    }
}

struct FieldErrorText: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(.red)
    }
}
