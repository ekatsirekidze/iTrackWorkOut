//
//  HomeView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 21.05.25.
//

import SwiftUI

/// Represents the home screen of the application, showing a welcome message and task details for the day.
struct HomeView: View {
    
    /// The localized welcome title without using settings.
    private var welcomeTitle: String {
        NSLocalizedString("Welcome", comment: "Generic welcome message")
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Today").font(.title)
                
                //TaskDetailView(date: Date())
            }
            .navigationTitle(welcomeTitle)
        }
    }
    
}
#Preview {
    HomeView()
}
