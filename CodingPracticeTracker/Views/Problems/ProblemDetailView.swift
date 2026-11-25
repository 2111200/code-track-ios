//
//  ProblemDetailView.swift
//  Full information about one problem, with Edit, status change and Delete.
//

import SwiftUI

struct ProblemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProblemDetailViewModel
    let store: ProblemStore
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false

    init(store: ProblemStore, problemID: UUID) {
        self.store = store
        _viewModel = StateObject(wrappedValue: ProblemDetailViewModel(store: store, problemID: problemID))
    }

    var body: some View {
        Group {
            if let problem = viewModel.problem {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(problem.title).font(.title2.bold())
                            HStack {
                                DifficultyBadge(difficulty: problem.difficulty)
                                StatusBadge(status: problem.status)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Details") {
                        LabeledContent("Platform", value: problem.platform.rawValue)
                        LabeledContent("Topic", value: problem.topic.rawValue)
                        LabeledContent("Difficulty", value: problem.difficulty.rawValue)
                        LabeledContent("Date", value: problem.date.formatted(date: .abbreviated, time: .omitted))
                        LabeledContent("Time Taken", value: "\(problem.timeTaken) min")
                        LabeledContent("Status", value: problem.status.rawValue)
                    }

                    Section("Approach Notes") {
                        Text(problem.approachNotes.isEmpty ? "No notes recorded." : problem.approachNotes)
                            .foregroundStyle(problem.approachNotes.isEmpty ? .secondary : .primary)
                    }

                    Section {
                        Button(role: .destructive) { showingDeleteAlert = true } label: {
                            Label("Delete Problem", systemImage: "trash")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            ForEach(SolveStatus.allCases) { status in
                                Button(status.rawValue, systemImage: status.icon) {
                                    viewModel.setStatus(status)
                                }
                            }
                        } label: { Image(systemName: "checkmark.circle") }
                            .accessibilityLabel("Change status")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") { showingEdit = true }
                    }
                }
                .sheet(isPresented: $showingEdit) {
                    ProblemFormView(store: store, problem: problem)
                }
                .alert("Delete this problem?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        viewModel.delete()
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This cannot be undone.")
                }
            } else {
                ContentUnavailableView("Problem not found", systemImage: "questionmark.folder")
            }
        }
        .navigationTitle("Problem Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
