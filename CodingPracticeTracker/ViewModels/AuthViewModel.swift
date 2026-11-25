//
//  AuthViewModel.swift
//  Drives the launch authentication flow (Face ID first, manual login as fallback).
//

import Foundation

final class AuthViewModel: ObservableObject {
    @Published private(set) var isAuthenticated = false
    @Published private(set) var isAuthenticating = false
    @Published var showManualLogin = false
    @Published private(set) var message: String?

    private let biometric: BiometricService

    init(biometric: BiometricService = BiometricService()) {
        self.biometric = biometric
    }

    /// Attempts Face ID. Falls back to manual login when unavailable or failed.
    @MainActor
    func authenticateWithBiometrics() async {
        guard !isAuthenticated, !isAuthenticating else { return }
        guard biometric.isAvailable else {
            message = "Face ID is unavailable on this device. Please log in manually."
            showManualLogin = true
            return
        }
        isAuthenticating = true
        defer { isAuthenticating = false }
        do {
            try await biometric.authenticate(reason: "Unlock your Coding Practice Tracker")
            message = nil
            isAuthenticated = true
        } catch {
            message = "Face ID failed or was cancelled. Try again or log in manually."
            showManualLogin = true
        }
    }

    /// Called after a successful manual login.
    func loginSucceeded() {
        message = nil
        isAuthenticated = true
    }

    /// Locks the app (logout / app sent to background).
    func lock() {
        isAuthenticated = false
        showManualLogin = false
        message = nil
    }
}
