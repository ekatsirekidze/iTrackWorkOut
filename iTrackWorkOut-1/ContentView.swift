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
                        
                    }
        } else {
            SignInView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}



    
