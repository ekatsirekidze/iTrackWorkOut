//
//  ContentView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 14.05.25.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false
    var body: some View {
        if isLoggedIn {
            TabView {
                ProjectsView()
                    .tabItem{
                        Image(systemName: "book.fill")
                        Text("Projects")
                    }
    
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("calendar")
                    }
                ActivityListView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Summary")
                    }
                NavigationStack {
                    SettingsView()
                        }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
        } else {
            SignInView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}




