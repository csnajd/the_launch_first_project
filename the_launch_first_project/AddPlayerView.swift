//
//  AddPlayerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

// AddPlayerView.swift

import SwiftUI

struct AddPlayerView: View {
    @State private var names: [String] = ["", "", ""]
    @Binding var navigationPath: NavigationPath //Mayar Add This !
    @EnvironmentObject var playerManager: PlayerManager //Mayar Add This !
    @State private var playerName = "" //Mayar Add this !

    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
        
        VStack {
            Text("أضف ٣ لاعبين على الأقل :")
                .font(.MainText)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 24)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 18) {
                        ForEach(names.indices, id: \.self) { i in
                            HStack(spacing: 12) {
                                ZStack {
                                    Image("yellowB")
                                        .resizable()
                                        .frame(width: 274, height: 40)

                                    TextField("اسم", text: Binding(
                                        get: { names[i] },
                                        set: { names[i] = $0 }
                                    ))
                                    .multilineTextAlignment(.center)
                                    .font(.PlayerText)
                                    .foregroundColor(.black)
                                    .frame(width: 274, height: 40)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)

                                Button {
                                    if names.count > 3 {
                                        names.remove(at: i)
                                    }
                                } label: {
                                    Image("yellowC")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .overlay {
                                            Text("–")
                                                .font(.system(size: 24, weight: .bold))
                                                .foregroundColor(.black)
                                                .padding(.top, 1)
                                        }
                                        .opacity(names.count > 3 ? 1 : 0.35)
                                }
                                .buttonStyle(.plain)
                                .disabled(names.count <= 3)
                            }
                            .padding(.horizontal, 16)
                            .id(i)
                        }

                        Color.clear.frame(height: 160).id("BOTTOM")
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)
                .onChange(of: names.count) { _, newCount in
                    // Scroll to bottom when a new field is added
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(newCount - 1, anchor: .bottom)
                    }
                }
            }

            Spacer()

            VStack(spacing: 12) {
                // Add name button
                Button {
                    names.append("")
                } label: {
                    ZStack {
                        Image("blueB")
                            .resizable()
                            .frame(width: 359, height: 60)
                            .overlay(alignment: .leading) {
                                ZStack {
                                    Image("blueC")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .padding()
                                    Text("+")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                        .offset(y: -4)
                                }
                                .offset(x: 283)
                            }
                            .overlay {
                                Text("أضف اسم")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                                
                            }
                    }
                }
                .buttonStyle(.plain)

                Button {
                                        let validNames = names
                                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                            .filter { !$0.isEmpty }
                                        
                    //Mayar Add this !
                    if validNames.count >= 3 {
                        playerManager.setPlayerNames(validNames)
                        navigationPath.append("RoleView")
                    }
                                    } label: {
                                        ZStack {
                        Image("purpleBL")
                            .resizable()
                            .frame(width: 359, height: 60)
                        Text("يلا ألعب !")
                            .font(.PlayerText)
                            .foregroundColor(.white)
                    }
                }
                .disabled(names.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.count < 3)
                .buttonStyle(.plain)
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 8)
        .environment(\.layoutDirection, .rightToLeft)
        .navigationBarBackButtonHidden(true)
    }
}
}

#Preview {
    
    AddPlayerView(navigationPath: .constant(NavigationPath()))
        .environmentObject(PlayerManager()) //Mayar Add this !
}
