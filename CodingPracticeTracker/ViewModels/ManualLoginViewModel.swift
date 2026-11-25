//
//  ManualLoginViewModel.swift
//  Validation + login/registration logic for the manual fallback.
//

import Foundation

final class ManualLoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published private(set) var usernameError: String?
    @Published private(set) var passwordError: String?
    @Published private(set) var confirmError: String?
    @Published private(set) var formError: String?

    private let store = CredentialStore()

    /// First run: the user creates a local account. Afterwards: plain login.
    var isRegistering: Bool { !store.hasAccount }

    /// Validates every field. Returns true when login/registration succeeded.
    func submit() -> Bool {
        let name = username.trimmingCharacters(in: .whitespaces)
        usernameError = validateUsername(name)
        passwordError = validatePassword(password)
        confirmError = isRegistering && confirmPassword != password ? "Passwords do not match." : nil
        formError = nil

        guard usernameError == nil, passwordError == nil, confirmError == nil else { return false }

        if isRegistering {
            store.register(username: name, password: password)
            return true
        }
        guard store.verify(username: name, password: password) else {
            formError = "Incorrect username or password."
            return false
        }
        return true
    }

    // MARK: - Validation

    private func validateUsername(_ value: String) -> String? {
        if value.isEmpty { return "Username is required." }
        if value.count < 3 || value.count > 20 { return "Username must be 3–20 characters." }
        if value.range(of: "^[A-Za-z0-9_]+$", options: .regularExpression) == nil {
            return "Use only letters, numbers and underscore."
        }
        return nil
    }

    private func validatePassword(_ value: String) -> String? {
        if value.isEmpty { return "Password is required." }
        if value.count < 6 { return "Password must be at least 6 characters." }
        if value.rangeOfCharacter(from: .letters) == nil || value.rangeOfCharacter(from: .decimalDigits) == nil {
            return "Password must contain a letter and a number."
        }
        return nil
    }
}
