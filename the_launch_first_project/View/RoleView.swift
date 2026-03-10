// RoleView.swift
import SwiftUI
import UIKit

/// View responsible only for presenting the role assignment flow UI.
/// All game logic and state are managed by `RoleViewModel`.
struct RoleView: View {
    @StateObject private var viewModel: RoleViewModel
    @Binding var navigationPath: NavigationPath
    @Environment(\.accessibilityEnabled) var isVoiceOverOn
    
    init(playerNames: [String], navigationPath: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: RoleViewModel(playerNames: playerNames))
        _navigationPath = navigationPath
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
            VStack {
                Spacer().frame(height: 100)
            
                if let player = viewModel.currentPlayerName, !viewModel.showRolePage {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            Text(player)
                                .font(.PlayerNameText)
                                .bold()
                            
                            Text("لا تخلي أحد غيرك يشوف")
                                .font(.PlayerText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                            impactGenerator.impactOccurred()
                            viewModel.showRolePage = true
                        }) {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                    .accessibilityHidden(true)
                                Text("يلا")
                                    .font(.MainText)
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("يَلَّا")
                        .accessibilityRemoveTraits(.isButton)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }

                if let player = viewModel.currentPlayerName, viewModel.showRolePage {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            Text(player)
                                .font(.PlayerNameText)
                                .bold()

                            if let role = viewModel.currentPlayerRole {
                                let details = viewModel.roleDetails(for: role)
                                
                                Image(details.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                    .accessibilityLabel(viewModel.roleImageLabel(for: role))
                                
                                VStack(spacing: 15) {
                                    Text(role)
                                        .font(.PlayerText)
                                        .bold()

                                    Text(details.instructions)
                                        .font(.PlayerText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accessibilityLabel(details.accessibilityInstructions)
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                        .onTapGesture {
                            viewModel.handleRoleTapped(isVoiceOverOn: isVoiceOverOn)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                            impactGenerator.impactOccurred()
                            viewModel.nextPlayer()
                        }) {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                    .accessibilityHidden(true)
                                Text(viewModel.remainingPlayerIndices.isEmpty ? "ابدأ اللعبة" : "يلا")
                                    .font(.MainText)
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(viewModel.remainingPlayerIndices.isEmpty ? "اِبْدَأِ اللَّعِب" : "يَلَّا")
                        .accessibilityRemoveTraits(.isButton)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .withHomeButton(navigationPath: $navigationPath)
        .onAppear {
            viewModel.startGame()
        }
        .onChange(of: viewModel.showRolePage) { _, isShowing in
            if isShowing {
                viewModel.handleRolePageShown(isVoiceOverRunning: UIAccessibility.isVoiceOverRunning)
            }
        }
        .onChange(of: viewModel.didFinishAssigningRoles) { _, didFinish in
            guard didFinish else { return }
            navigationPath.append(TimerViewData(playerNames: viewModel.playerNames))
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    RoleView(playerNames: ["أحمد", "سارة", "منى", "خالد"], navigationPath: $path)
}
