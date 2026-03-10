//  AddPlayerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI
import UIKit

/// View responsible for laying out the player-name input screen.
/// All dynamic state and validation is handled by `AddPlayerViewModel`.
struct AddPlayerView: View {
    @Binding var navigationPath: NavigationPath
    
    @StateObject private var viewModel = AddPlayerViewModel()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .ignoresSafeArea(.keyboard)
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            
            VStack {
                Spacer().frame(height: 100)
                
                Text("أضف ٣ لاعبين على الأقل :")
                    .font(.MainText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("يَجِبُ إِضَافَةُ ثَلَاثَةِ لَاعِبِينَ عَلَى الْأَقَل")

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 18) {
                            ForEach(viewModel.names.indices, id: \.self) { i in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Image("yellowB")
                                            .resizable()
                                            .frame(width: 274, height: 40)
                                            .accessibilityHidden(true)

                                        TextField("اسم", text: Binding(
                                            get: { viewModel.names[i] },
                                            set: { viewModel.names[i] = $0 }
                                        ))
                                        .multilineTextAlignment(.center)
                                        .font(.PlayerText)
                                        .foregroundColor(.black)
                                        .frame(width: 274, height: 40)
                                        .accessibilityLabel("اِكْتُبِ اسْمَ اللَّاعِب")
                                    }
                 

                                    Button {
                                        viewModel.removeName(at: i)
                                    } label: {
                                        Image("yellowC")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                            .accessibilityHidden(true)
                                            .overlay {
                                                Text("–")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .accessibilityHidden(true)
                                            }
                                            .opacity(viewModel.canDeleteRow ? 1 : 0.35)
                                    }
                                    .accessibilityLabel("حَذْفُ اللَّاعِب")
                                    .accessibilityAddTraits(.isButton)
                                    .disabled(!viewModel.canDeleteRow)
                                    .buttonStyle(.plain)
                                }
                                .accessibilityElement(children: .combine)
                                .id(i)
                            }
                            
                            Color.clear.frame(height: 160).id("BOTTOM")
                        }
                        .padding(.top, 8)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .frame(maxWidth: .infinity)
                    .onChange(of: viewModel.names.count) { _, newCount in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newCount - 1, anchor: .bottom)
                        }
                    }
                }

            
                Spacer()

                
                VStack(spacing: 12) {
                    Button {
                        viewModel.addNameField()
                    } label: {
                        ZStack {
                            Image("blueB")
                                .resizable()
                                .frame(width: 359, height: 60)
                                .contentShape(Rectangle())
                            Text("أضف اسم")
                                .font(.PlayerText).font(.system(.title3, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(
                        destination: RoleView(
                            playerNames: viewModel.trimmedNames,
                            navigationPath: $navigationPath
                        )
                    ) {
                        ZStack {
                            Image("purpleBL")
                                .resizable()
                                .frame(width: 359, height: 60)
                            Text("يلا ألعب !")
                                .font(.PlayerText)
                                .foregroundColor(.white).shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("اِبْدَأِ اللَّعِب")
                        .accessibilityAddTraits(.isButton)
                    }
                    .disabled(!viewModel.canStartGame)
                    .buttonStyle(.plain)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            if viewModel.canStartGame {
                                let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                                impactGenerator.impactOccurred()
                            }
                        }
                    )
                }
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 8)
        }
        .ignoresSafeArea(.keyboard)
        .environment(\.layoutDirection, .rightToLeft)
        .navigationBarBackButtonHidden(true)
        .withHomeButton(navigationPath: $navigationPath)
    }
}
#Preview {
    AddPlayerView(navigationPath: .constant(NavigationPath()))
}
