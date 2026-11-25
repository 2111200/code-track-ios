//
//  Problem.swift
//  Data model for a practice problem plus the enums it uses.
//

import SwiftUI

/// Difficulty level of a problem.
enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
    var id: String { rawValue }

    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

/// Solve status used for revision planning.
enum SolveStatus: String, CaseIterable, Codable, Identifiable {
    case attempted = "Attempted"
    case solved = "Solved"
    case revisitLater = "Revisit Later"
    var id: String { rawValue }

    var color: Color {
        switch self {
        case .attempted: return .blue
        case .solved: return .green
        case .revisitLater: return .purple
        }
    }

    var icon: String {
        switch self {
        case .attempted: return "pencil.circle.fill"
        case .solved: return "checkmark.circle.fill"
        case .revisitLater: return "arrow.counterclockwise.circle.fill"
        }
    }
}

/// Topic categories used for grouping and filtering.
enum Topic: String, CaseIterable, Codable, Identifiable {
    case arrays = "Arrays"
    case strings = "Strings"
    case recursion = "Recursion"
    case sorting = "Sorting"
    case collections = "Collections"
    case linkedList = "Linked List"
    case trees = "Trees"
    case graphs = "Graphs"
    case dynamicProgramming = "Dynamic Programming"
    case other = "Other"
    var id: String { rawValue }
}

/// Coding platform the problem came from.
enum Platform: String, CaseIterable, Codable, Identifiable {
    case leetCode = "LeetCode"
    case hackerRank = "HackerRank"
    case codeChef = "CodeChef"
    case codeforces = "Codeforces"
    case geeksForGeeks = "GeeksforGeeks"
    case other = "Other"
    var id: String { rawValue }
}

/// A single practice problem entry.
struct Problem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var platform: Platform
    var topic: Topic
    var difficulty: Difficulty
    var status: SolveStatus
    var date: Date
    var approachNotes: String
    /// Time taken to solve, in minutes.
    var timeTaken: Int
}
