//
//  AuthView.swift
//  Launch screen: Face ID first, manual login if unavailable or failed.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var auth: AuthViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .font(.system(size: 72))
                    .foregroundStyle(.tint)
                    .padding(.top, 60)

                Text("Coding Practice Tracker")
                    .font(.title.bold())
                Text("Unlock to continue")
                    .foregroundStyle(.secondary)

                if let message = auth.message {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task { await auth.authenticateWithBiometrics() }
                } label: {
                    Label("Unlock with Face ID", systemImage: "faceid")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(auth.isAuthenticating)

                if auth.showManualLogin {
                    ManualLoginView { auth.loginSucceeded() }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                } else {
                    Button("Use manual login instead") { auth.showManualLogin = true }
                }
            }
            .padding()
        }
        .task { await auth.authenticateWithBiometrics() }   // prompt automatically on launch
    }
}
