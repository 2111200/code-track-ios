//
//  CodingPracticeTrackerApp.swift
//  Entry point. Owns the two app-wide objects: authentication state and the problem store.
//

import SwiftUI

@main
struct CodingPracticeTrackerApp: App {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var store = ProblemStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
                .environmentObject(auth)
                // Re-lock the app whenever it goes to the background.
                .onChange(of: scenePhase) { _, phase in
                    if phase == .background { auth.lock() }
                }
        }
    }
}
