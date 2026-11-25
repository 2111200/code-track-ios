//
//  ProblemListView.swift
//  Scrollable list with search (by title), filters and swipe-to-delete.
//

import SwiftUI

struct ProblemListView: View {
    @StateObject private var viewModel: ProblemListViewModel
    let store: ProblemStore
    @State private var showingAdd = false

    init(store: ProblemStore, initialStatus: SolveStatus? = nil) {
        self.store = store
        _viewModel = StateObject(wrappedValue: ProblemListViewModel(store: store, initialStatus: initialStatus))
    }

    var body: some View {
        List {
            ForEach(viewModel.filteredProblems) { problem in
                NavigationLink {
                    ProblemDetailView(store: store, problemID: problem.id)
                } label: {
                    ProblemRowView(problem: problem)
                        .padding(.vertical, 4)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .overlay {
            if viewModel.filteredProblems.isEmpty {
                ContentUnavailableView(viewModel.problems.isEmpty ? "No Problems Yet" : "No Matches",
                                       systemImage: "magnifyingglass",
                                       description: Text(viewModel.problems.isEmpty
                                                         ? "Tap + to add your first problem."
                                                         : "Try a different search or clear the filters."))
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search by title")
        .navigationTitle("Problems")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { filterMenu }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Add problem")
            }
        }
        .sheet(isPresented: $showingAdd) {
            ProblemFormView(store: store)
        }
    }

    private var filterMenu: some View {
        Menu {
            Picker("Topic", selection: $viewModel.selectedTopic) {
                Text("All Topics").tag(Topic?.none)
                ForEach(Topic.allCases) { Text($0.rawValue).tag(Topic?.some($0)) }
            }
            Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                Text("All Difficulties").tag(Difficulty?.none)
                ForEach(Difficulty.allCases) { Text($0.rawValue).tag(Difficulty?.some($0)) }
            }
            Picker("Status", selection: $viewModel.selectedStatus) {
                Text("All Statuses").tag(SolveStatus?.none)
                ForEach(SolveStatus.allCases) { Text($0.rawValue).tag(SolveStatus?.some($0)) }
            }
            if viewModel.hasActiveFilters {
                Button("Clear Filters", role: .destructive) { viewModel.clearFilters() }
            }
        } label: {
            Image(systemName: viewModel.hasActiveFilters
                  ? "line.3.horizontal.decrease.circle.fill"
                  : "line.3.horizontal.decrease.circle")
        }
        .accessibilityLabel("Filter")
    }
}
