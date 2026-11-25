//
//  DashboardView.swift
//  Home screen: summary cards and navigation entry to the rest of the app.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @StateObject private var viewModel: DashboardViewModel
    let store: ProblemStore
    @State private var showingAdd = false

    init(store: ProblemStore) {
        self.store = store
        _viewModel = StateObject(wrappedValue: DashboardViewModel(store: store))
    }

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        NavigationLink { ProblemListView(store: store) } label: {
                            StatCard(title: "Total Problems", value: "\(viewModel.total)",
                                     icon: "list.bullet.rectangle", color: .blue)
                        }
                        NavigationLink { ProblemListView(store: store, initialStatus: .solved) } label: {
                            StatCard(title: "Solved", value: "\(viewModel.solved)",
                                     icon: "checkmark.seal.fill", color: .green)
                        }
                        NavigationLink { ProblemListView(store: store, initialStatus: .revisitLater) } label: {
                            StatCard(title: "Revisit Later", value: "\(viewModel.revisit)",
                                     icon: "arrow.counterclockwise.circle.fill", color: .purple)
                        }
                        StatCard(title: "Most Practised", value: viewModel.mostPracticedTopic,
                                 icon: "flame.fill", color: .orange)
                    }

                    HStack(spacing: 12) {
                        NavigationLink { ProblemListView(store: store) } label: {
                            Label("All Problems", systemImage: "list.bullet")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Button { showingAdd = true } label: {
                            Label("Add Problem", systemImage: "plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .controlSize(.large)

                    if !viewModel.recent.isEmpty {
                        Text("Recent Practice").font(.headline)
                        ForEach(viewModel.recent) { problem in
                            NavigationLink {
                                ProblemDetailView(store: store, problemID: problem.id)
                            } label: {
                                ProblemRowView(problem: problem)
                                    .padding()
                                    .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { auth.lock() } label: { Image(systemName: "lock.fill") }
                        .accessibilityLabel("Lock app")
                }
            }
            .sheet(isPresented: $showingAdd) {
                ProblemFormView(store: store)
            }
        }
    }
}
