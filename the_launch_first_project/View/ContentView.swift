//
//  ContentView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI
import UIKit

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
    @StateObject private var viewModel = HomeViewModel()
    @State private var showHowToPlay = false
    
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
                                viewModel.handleLogoAppear()
                            }
 
                    Spacer()
                    
                    if viewModel.isButtonVisible {
                    NavigationLink(value: "AddPlayerView") {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                Text("العب")
                                    .font(.title)  
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
        .overlay(alignment: .topTrailing) {
            Button {
                showHowToPlay = true
            } label: {
                ZStack {
                    Image("yellowC")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    Text("؟")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.background)
                }
            }
            .padding(.top, 30)
            .padding(.trailing, 40)
            .accessibilityLabel("طريقة اللعب")
            .accessibilityHint("يعرض شرح طريقة اللعب")
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showHowToPlay) {
            HowToPlaySheet(isPresented: $showHowToPlay)
        }
    }
}

private struct HowToPlaySheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("طريقة اللعب")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundColor(.ppurple)
                
                // TODO: Replace placeholder with full "How to Play" instructions.
                Text(" الشرح هنا...")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    ZStack {
                        Image("purpleBS")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 227, height: 55)
                        Text("تم")
                            .font(.MainText)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)

            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    ContentView()
}
