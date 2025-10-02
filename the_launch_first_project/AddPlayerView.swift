//
//  AddPlayerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct AddPlayerView: View {
    @State private var names: [String] = ["", "", ""]
    @State private var navigateToRole = false
    @State private var selectedPlayers: [String] = []

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text("أضف ٣ لاعبين على الأقل :")
                    .font(.MainText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

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

                                    // زر الحذف
                                    Button {
                                        if names.count > 3 { names.remove(at: i) }
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
                        .padding(.top, 4)
                    }
                }
            }

            VStack {
                Spacer()
                VStack(spacing: 12) {
                    Button {
                        let newIndex = names.count
                        names.append("")
                    } label: {
                        ZStack {
                            Image("blueB")
                                .resizable()
                                .frame(width: 361, height: 60)
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
                                    .offset(x: 295)
                                }
                                .overlay {
                                    Text("أضف اسم")
                                        .font(.PlayerText)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    .buttonStyle(.plain)

                    NavigationLink(
                        destination: RoleView(playerNames: names.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }),
                        isActive: $navigateToRole
                    ) {
                        Button {
                            let valid = names
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .filter { !$0.isEmpty }
                            selectedPlayers = valid
                            navigateToRole = true
                        } label: {
                            ZStack {
                                Image("purpleBL")
                                    .resizable()
                                    .frame(width: 361, height: 55)
                                Text("يلا ألعب !")
                                    .font(.PlayerText)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(names.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count < 3)
                    }
                }
                .padding(.bottom)
            }
            .environment(\.layoutDirection, .rightToLeft)
            .navigationBarBackButtonHidden(true)
        }
     }
}

#Preview {
    AddPlayerView()
}
