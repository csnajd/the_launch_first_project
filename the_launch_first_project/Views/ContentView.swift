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
        .onChange(of: navigationPath.count) { oldCount, newCount in
            if oldCount > 0 && newCount == 0 {
                timerManager.reset()
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
    @State private var selectedRole = 0

    private let roles: [(name: String, image: String, description: String)] = [
        ("العجوز", "imOld", "راقبي اللاعبين وحاولي تقفطين الولد قبل ما يغمز لكل البنات. وإذا قفطتيه، قولي: «قفطتك!»"),
        ("الولد", "imBoy", "حاول تغمز لكل البنات بدون ما تنتبه لك العجوز. انتبه تقفطك!"),
        ("البنت", "imGirl", "إذا غمز لك الولد، لا تكشفينه، وقولي: «انخطبت!»")
    ]
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("طريقة اللعب")
                        .font(.MainText)
                        .foregroundColor(.ppurple)
                        .accessibilityAddTraits(.isHeader)

                    Text("تعرّف على الأدوار وطريقة الفوز")
                        .font(.PlayerText)
                        .foregroundColor(.ppurple.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Text("لا تكشف دورك لأحد. السرية أساس اللعبة!")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.ppurple.opacity(0.85))
                        .multilineTextAlignment(.center)

                }
                .padding(.top, 24)
                .padding(.horizontal, 16)


                GeometryReader { geometry in
                    TabView(selection: $selectedRole) {
                        ForEach(roles.indices, id: \.self) { index in
                            rolePage(roles[index], availableHeight: geometry.size.height)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .environment(\.layoutDirection, .rightToLeft)
                }

                HStack(spacing: 8) {
                    ForEach(roles.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == selectedRole ? Color.ppurple : Color.ppurple.opacity(0.28))
                            .frame(width: index == selectedRole ? 22 : 8, height: 8)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.top, 4)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("الصفحة \(selectedRole + 1) من ٣")

                Spacer(minLength: 10)


                    Button {
                        isPresented = false
                    } label: {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                                .accessibilityHidden(true)
                            Text("تم")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .accessibilityLabel("تم")
                    .accessibilityHint("يغلق شرح طريقة اللعب")
                    .accessibilityAddTraits(.isButton)
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 24)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    private func rolePage(
        _ role: (name: String, image: String, description: String),
        availableHeight: CGFloat
    ) -> some View {
        let illustrationHeight = min(215, max(105, availableHeight * 0.34))

        return VStack(spacing: 12) {
            Text(role.name)
                .font(.system(size: 42, weight: .heavy))
                .foregroundColor(.ppurple)
                .multilineTextAlignment(.center)

            Image(role.image)
                .resizable()
                .scaledToFit()
                .frame(height: illustrationHeight)
                .accessibilityLabel(role.name)
                .accessibilityAddTraits(.isImage)

            Text(role.description)
                .font(.PlayerText)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 8)
        .environment(\.layoutDirection, .rightToLeft)
        .accessibilityElement(children: .contain)
    }

#Preview {
    ContentView()
}
