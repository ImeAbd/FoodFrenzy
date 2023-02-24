//
//  AuthenticationState.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-24.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationState: ObservableObject {
    @Published var user: User?
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        registerStateListener()
    }

    deinit {
        unregisterStateListener()
    }

    private func registerStateListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            self.user = user
        }
    }

    private func unregisterStateListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Successfully signed out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

