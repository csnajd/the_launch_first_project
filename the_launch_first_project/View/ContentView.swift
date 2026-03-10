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
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("طريقة اللعب")
                        .font(.MainText)
                        .foregroundColor(.ppurple)
                        .padding(.top, 40)
                        .accessibilityLabel("طريقة اللعب")
                        .accessibilityAddTraits(.isHeader)
                    
                    // الأدوار
                    HStack(spacing: 12) {
                        ForEach([("imBoy", "الولد"), ("imGirl", "البنت"), ("imOld", "العجوز")], id: \.1) { imageName, name in
                            VStack(spacing: 6) {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Text(name)
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                Image("yellowC")
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipShape(Circle())
                            .accessibilityLabel("دور \(name)")
                            .accessibilityElement(children: .combine)
                        }
                    }
                    .padding(.horizontal)
                    .accessibilityLabel("أدوار اللعبة")

                    // القواعد - كل دور لحاله
                    VStack(spacing: 16) {
                        
                        // الولد
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 10) {
                                Image("imBoy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                Text("الولد")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text("يغمز للبنات بدون ما يشوفه أحد")
                                .font(.PlayerText)
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            HStack(spacing: 6) {
                                Text("يفوز لو غمز لكل البنات بدون ما ينقفط!")
                                    .font(.PlayerText)
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Image("blueB").resizable().scaledToFill())
                        .cornerRadius(14)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("الولد: يغمز للبنات بدون ما يشوفه أحد. يفوز لو غمز لكل البنات بدون ما ينقفط")

                        // البنت
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 10) {
                                Image("imGirl")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                Text("البنت")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text("تستقبل الغمزة بهدوء بدون ما تعلم مين هو الولد ")
                                .font(.PlayerText)
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            HStack(spacing: 6) {
                                Text("إذا انخطبت لازم تقول بصوت عالٍ «انخطبت!»")
                                    .font(.PlayerText)
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Image("blueB").resizable().scaledToFill())
                        .cornerRadius(14)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("البنت: تستقبل الغمزة بهدوء بدون ما تعلم مين هو الولد. إذا انخبطت لازم تقول بصوت عالٍ انخبطت")

                        // العجوز
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 10) {
                                Image("imOld")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                Text("العجوز")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text("تراقب الولد طول الوقت")
                                .font(.PlayerText)
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            HStack(spacing: 6) {
                                Text("تفوز لو قفطت الولد قبل ما يكمّل على الكل!")
                                    .font(.PlayerText)
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Image("blueB").resizable().scaledToFill())
                        .cornerRadius(14)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("العجوز: تراقب الولد طول الوقت. تفوز لو قفطت الولد قبل ما يكمّل على الكل")

                        // السرية
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack(spacing: 10) {
                                Text("🤫")
                                    .font(.system(size: 28))
                                Text("السرية")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Text("السرية أساس اللعبة — لا تعلم أحد دورك!")
                                .font(.PlayerText)
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Image("blueB").resizable().scaledToFill())
                        .cornerRadius(14)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("السرية: أساس اللعبة — لا تعلم أحد دورك")
                    }
                    .padding(.horizontal)
                    
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
                    .accessibilityLabel("تم")
                    .accessibilityHint("يغلق شرح طريقة اللعب")
                    .accessibilityAddTraits(.isButton)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
