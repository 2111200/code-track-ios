//
//  CredentialStore.swift
//  Local manual-login storage used when Face ID is unavailable.
//  The password is stored as a salted SHA-256 hash, never in plain text.
//  (A production app would use the Keychain.)
//

import Foundation
import CryptoKit

struct CredentialStore {
    private let defaults = UserDefaults.standard
    private let userKey = "auth.username"
    private let hashKey = "auth.passwordHash"

    /// Whether a local account has already been created.
    var hasAccount: Bool { defaults.string(forKey: userKey) != nil }

    func register(username: String, password: String) {
        defaults.set(username, forKey: userKey)
        defaults.set(hash(password, salt: username), forKey: hashKey)
    }

    func verify(username: String, password: String) -> Bool {
        defaults.string(forKey: userKey) == username &&
        defaults.string(forKey: hashKey) == hash(password, salt: username)
    }

    private func hash(_ password: String, salt: String) -> String {
        SHA256.hash(data: Data((salt + password).utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
