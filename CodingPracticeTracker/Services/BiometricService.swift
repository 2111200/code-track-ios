//
//  BiometricService.swift
//  Thin wrapper around LocalAuthentication for Face ID.
//

import LocalAuthentication

struct BiometricService {

    /// True when the device supports and has enrolled biometrics.
    var isAvailable: Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Prompts for Face ID. Throws if the user cancels or authentication fails.
    func authenticate(reason: String) async throws {
        let context = LAContext()
        context.localizedFallbackTitle = ""   // hide system passcode fallback; we offer our own manual login
        _ = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                             localizedReason: reason)
    }
}
