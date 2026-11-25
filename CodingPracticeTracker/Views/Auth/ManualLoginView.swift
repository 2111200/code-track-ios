//
//  ManualLoginView.swift
//  Local username/password form with validation on every field.
//

import SwiftUI

struct ManualLoginView: View {
    @StateObject private var viewModel = ManualLoginViewModel()
    let onSuccess: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.isRegistering ? "Create a local account" : "Sign in")
                .font(.headline)

            TextField("Username", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
            if let error = viewModel.usernameError { FieldErrorText(message: error) }

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            if let error = viewModel.passwordError { FieldErrorText(message: error) }

            if viewModel.isRegistering {
                SecureField("Confirm password", text: $viewModel.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                if let error = viewModel.confirmError { FieldErrorText(message: error) }
            }

            if let error = viewModel.formError { FieldErrorText(message: error) }

            Button {
                if viewModel.submit() { onSuccess() }
            } label: {
                Text(viewModel.isRegistering ? "Create Account & Continue" : "Log In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
