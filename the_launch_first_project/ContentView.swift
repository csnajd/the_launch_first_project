//
//  ContentView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                
                HomeView()
                AddPlayerView()
                RoleView()
                TimeView()
                TimerView()
                EndGameView()
            }
            .padding()
        }

     }
}

#Preview {
    ContentView()
}
