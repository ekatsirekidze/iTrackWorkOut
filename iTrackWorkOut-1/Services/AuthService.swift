//
//  AuthService.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 17.05.25.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import UIKit

final class AuthService {
    static let shared = AuthService()
    private var idToken: String?
    private var accessToken: String?
    private var currentUser: User?

    private init() {
        refreshUser()
    }

    func loginWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return completion(.failure(NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing clientID"]
            )))
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let presentingVC = UIViewController.getRootViewController() else {
            return completion(.failure(NSError(
                domain: "AuthService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "No root view controller"]
            )))
        }

        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { [weak self] googleUser, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard
                let user = googleUser,
                let idTokenStr = user.authentication.idToken
            else {
                return completion(.failure(NSError(
                    domain: "AuthService",
                    code: -3,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get Google auth tokens"]
                )))
            }

            let authentication = user.authentication
            self?.idToken = idTokenStr
            self?.accessToken = authentication.accessToken

            let credential = GoogleAuthProvider.credential(
                withIDToken: idTokenStr,
                accessToken: authentication.accessToken
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    return completion(.failure(error))
                }

                guard let firebaseUser = authResult?.user else {
                    return completion(.failure(NSError(
                        domain: "AuthService",
                        code: -4,
                        userInfo: [NSLocalizedDescriptionKey: "No Firebase user returned"]
                    )))
                }

                self?.currentUser = firebaseUser
                completion(.success(firebaseUser))
            }
        }
    }

    func getCurrentUser() -> User? {
        return currentUser
    }

    func getIDToken() -> String? {
        return idToken
    }

    func getAccessToken() -> String? {
        return accessToken
    }

    func refreshUser() {
        currentUser = Auth.auth().currentUser
    }

    func signOut() throws {
        try Auth.auth().signOut()
        idToken = nil
        accessToken = nil
        currentUser = nil
    }
}

private extension UIViewController {
    static func getRootViewController() -> UIViewController? {
        return UIViewController()
    }
}
