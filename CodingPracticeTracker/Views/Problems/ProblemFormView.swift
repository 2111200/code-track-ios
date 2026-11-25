//
//  ProblemFormView.swift
//  Add / Edit form (same screen, driven by whether a problem is passed in).
//

import SwiftUI

struct ProblemFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProblemFormViewModel

    init(store: ProblemStore, problem: Problem? = nil) {
        _viewModel = StateObject(wrappedValue: ProblemFormViewModel(store: store, problem: problem))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Problem") {
                    TextField("Title", text: $viewModel.title)
                    if let error = viewModel.titleError { FieldErrorText(message: error) }

                    Picker("Platform", selection: $viewModel.platform) {
                        ForEach(Platform.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Topic", selection: $viewModel.topic) {
                        ForEach(Topic.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Difficulty", selection: $viewModel.difficulty) {
                        ForEach(Difficulty.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    Picker("Status", selection: $viewModel.status) {
                        ForEach(SolveStatus.allCases) { Text($0.rawValue).tag($0) }
                    }
                    DatePicker("Date", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
                }

                Section("Time Taken (minutes)") {
                    TextField("e.g. 25", text: $viewModel.timeTaken)
                        .keyboardType(.numberPad)
                    if let error = viewModel.timeError { FieldErrorText(message: error) }
                }

                Section("Approach Notes") {
                    TextEditor(text: $viewModel.approachNotes)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Problem" : "Add Problem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { if viewModel.save() { dismiss() } }
                }
            }
        }
    }
}
