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

    var body: some View {
        VStack {
            Text("أضف ٣ لاعبين على الأقل :")
                .font(.MainText)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 24)

            ScrollView {
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
                    }
                }
                .padding()
            }

            VStack(spacing: 12) {
                Button {
                    names.append("")
                } label: {
                    ZStack {
                        Image("blueB")
                            .resizable()
                            .frame(width: 359, height: 60)
                        Text("أضف اسم")
                            .font(.PlayerText)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)

                // التنقل لصفحة RoleView مباشرة مع الأسماء المحدثة
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
                            .font(.PlayerText)
                            .foregroundColor(.white)
                    }
                }
                .disabled(names.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.count < 3)
                .buttonStyle(.plain)
            }
            .padding(.bottom)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct AddPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerView()
    }
}
#endif
