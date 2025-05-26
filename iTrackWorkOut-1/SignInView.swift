//
//  SignInView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 26.05.25.
//


import SwiftUI
import GoogleSignInSwift

struct SignInView: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Welcome to iTrackWorkOut")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Sign in to get started with your fitness journey")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            GoogleSignInButton(action: {
                AuthService.shared.loginWithGoogle { result in
                    switch result {
                    case .success(let user):
                        print("Login successful! User: \(user)")
                        isLoggedIn = true
                    case .failure(let error):
                        print("Login failed with error: \(error.localizedDescription)")
                    }
                }
            })
            .frame(width: 240, height: 80)
        }
    }
}
