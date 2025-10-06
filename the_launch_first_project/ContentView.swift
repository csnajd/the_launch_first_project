//
//  ContentView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI

// Data types للـ Navigation
struct TimerViewData: Hashable {
    let playerNames: [String]
}
struct EndGameViewData: Hashable {
    let playerNames: [String] 
}

struct RoleViewData: Hashable {
    let playerNames: [String]
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                HomeView()
            }
        }
    }
}

struct HomeView: View {
    @State private var logoOffset: CGFloat = 0
    @State private var isButtonVisible = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 450, height: 450)
                    .offset(y: logoOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1)) {
                            logoOffset = -200
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isButtonVisible = true
                            }
                        }
                    }
                    .padding(.top, 202)
                
                Spacer()
                
                if isButtonVisible {
                    NavigationLink(destination: AddPlayerView(navigationPath: $navigationPath)) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            Text("العب")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 60)
                }
            }
             .navigationDestination(for: TimerViewData.self) { data in
                TimerView(navigationPath: $navigationPath, playerNames: data.playerNames)
            }
            .navigationDestination(for: EndGameViewData.self) { data in
                EndGameView(
                    timerManager: TimerManager(),
                    navigationPath: $navigationPath,
                    playerNames: data.playerNames
                )
            }
            .navigationDestination(for: RoleViewData.self) { data in
                RoleView(
                    playerNames: data.playerNames,
                    navigationPath: $navigationPath
                )
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "AddPlayerView" {
                    AddPlayerView(navigationPath: $navigationPath)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
