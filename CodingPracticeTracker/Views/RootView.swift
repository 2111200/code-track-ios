//
//  RootView.swift
//  Chooses between the authentication screen and the app.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var auth: AuthViewModel
    let store: ProblemStore

    var body: some View {
        if auth.isAuthenticated {
            DashboardView(store: store)
        } else {
            AuthView()
        }
    }
}
