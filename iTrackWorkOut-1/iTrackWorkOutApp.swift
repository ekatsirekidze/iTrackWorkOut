//
//  iTrackWorkOut_1App.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 14.05.25.
//

import SwiftUI
import Firebase

@main
struct iTrackWorkOutApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
