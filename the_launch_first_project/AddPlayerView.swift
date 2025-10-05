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
    @State private var scrollID: Int = 0

    var body: some View {
        VStack {
            Text("أضف ٣ لاعبين على الأقل :")
                .font(.title3)
                .padding(.top, 20)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 16) {
                        ForEach(names.indices, id: \.self) { i in
                            HStack(spacing: 12) {
                                ZStack {
                                    Image("yellowB")
                                        .resizable()
                                        .frame(width: 274, height: 40)
                                        .cornerRadius(8)
                                    TextField("اسم", text: Binding(
                                        get: { names[i] },
                                        set: { names[i] = $0 }
                                    ))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 240, height: 40)
                                }

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
                                        }
                                        .opacity(names.count > 3 ? 1 : 0.35)
                                }
                                .disabled(names.count <= 3)
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal)
                            .id(i)
                        }

                        Color.clear.frame(height: 160).id("BOTTOM")
                    }
                    .padding(.top, 8)
                }
                .onChange(of: names.count) { _ in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(names.count - 1, anchor: .bottom)
                    }
                }
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    names.append("")
                } label: {
                    ZStack {
                        Image("blueB")
                            .resizable()
                            .frame(width: 359, height: 60)
                        Text("أضف اسم")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)

                NavigationLink(
                    destination: RoleView(
                        playerNames: names
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                    )
                ) {
                    ZStack {
                        Image("purpleBL")
                            .resizable()
                            .frame(width: 359, height: 60)
                        Text("يلا ألعب !")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .disabled(names.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.count < 3)
                .buttonStyle(.plain)
            }
            .padding(.bottom, 20)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddPlayerView()
}

