//
//  ContentView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI
import UIKit

struct TimerViewData: Hashable {
    let playerNames: [String]
}
struct EndGameViewData: Hashable {
    let playerNames: [String]
}

struct RoleViewData: Hashable {
    let playerNames: [String]
}

extension View {
    func withHomeButton(navigationPath: Binding<NavigationPath>) -> some View {
        self.overlay(alignment: .topLeading) {
            Button(action: {
                let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                impactGenerator.impactOccurred()
                navigationPath.wrappedValue = NavigationPath()
            }) {
                ZStack {
                    Image("yellowC")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                       
                    Image(systemName: "house.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.background)
                }
            }
            .accessibilityLabel("العودة للرئيسية")
            .accessibilityHint("يعيدك إلى شاشة البداية")
            .accessibilityAddTraits(.isButton)
            .accessibilitySortPriority(-1)
            .padding(.top, 30)
            .padding(.leading, 20)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                HomeView(navigationPath: $navigationPath)
            }
            .navigationDestination(for: TimerViewData.self) { data in
                TimerView(
                    timerManager: timerManager,
                    navigationPath: $navigationPath,
                    playerNames: data.playerNames
                )
                .withHomeButton(navigationPath: $navigationPath)
            }
            .navigationDestination(for: EndGameViewData.self) { data in
                EndGameView(
                    timerManager: timerManager,
                    navigationPath: $navigationPath,
                    playerNames: data.playerNames
                )
                .withHomeButton(navigationPath: $navigationPath)
            }
            .navigationDestination(for: RoleViewData.self) { data in
                RoleView(
                    playerNames: data.playerNames,
                    navigationPath: $navigationPath
                )
                .withHomeButton(navigationPath: $navigationPath)
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "AddPlayerView" {
                    AddPlayerView(navigationPath: $navigationPath)
                }
            }
        }
    }
}

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var isButtonVisible = false
    @Environment(\.accessibilityEnabled) var isVoiceOverOn
    
    var body: some View {
            ZStack {
                Color.background 
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 100)
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 450, height: 450)
                            .accessibilityLabel("لُوقُو قَفْطَتَك")
                            .onAppear {
                                let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
                                hapticGenerator.prepare()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    hapticGenerator.impactOccurred()
                                    withAnimation {
                                        isButtonVisible = true
                                    }
                                }
                            }
 
                    Spacer()
                    
                    if isButtonVisible {
                    NavigationLink(value: "AddPlayerView") {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                Text("العب")
                                    .font(.title) // to be Dynamic Type
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityLabel("بدء اللعبة")
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 60)
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                                impactGenerator.impactOccurred()
                            }
                        )
                    }
                }
            }
        }
    }


#Preview {
    ContentView()
}
