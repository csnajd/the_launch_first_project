

import SwiftUI

  struct AddPlayerView: View {
    @State private var names: [String] = ["", "", ""]
    @Binding var navigationPath: NavigationPath
    
    struct GameData: Hashable {
        let playerNames: [String]
    }
// هنا تعديل الكيبورد 
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all, edges: .top)

            VStack {
                Text("أضف ٣ لاعبين على الأقل :")
                    .font(.MainText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                ScrollViewReader { proxy in
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
                                .id(i)
                            }
                            
                            Color.clear.frame(height: 160).id("BOTTOM")
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: names.count) { _, newCount in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newCount - 1, anchor: .bottom)
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
                                .font(.PlayerText)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink(
                        destination: RoleView(
                            playerNames: names
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .filter { !$0.isEmpty },
                            navigationPath: $navigationPath
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
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 8)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddPlayerView(navigationPath: .constant(NavigationPath()))
}

 
