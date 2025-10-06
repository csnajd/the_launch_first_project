// RoleView.swift
import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @Binding var navigationPath: NavigationPath
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if let player = currentPlayer, !showRolePage {
                // صفحة تقديم اللاعب - UI ثابت
                VStack {
                    Spacer()
                    
                    VStack(spacing: 30) {
                        Text(player)
                            .font(.PlayerNameText)
                            .bold()
                        
                        Text("لا تخلي احد غيرك يشوف")
                            .font(.PlayerText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                     Button(action: { showRolePage = true }) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            Text("يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 60) // مسافة ثابتة من الأسفل
                }
                .padding()
            }

            // صفحة الدور لكل لاعب - UI ثابت
            if let player = currentPlayer, showRolePage {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 30) {
                        Text(player)
                            .font(.PlayerNameText)
                            .bold()

                        if let role = assignedRoles[player] {
                            let details = roleDetails(for: role)
                            
                            Image(details.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                            
                            VStack(spacing: 15) {
                                Text(role)
                                    .font(.PlayerText)
                                    .bold()

                                Text(details.instructions)
                                    .font(.PlayerText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .fixedSize(horizontal: false, vertical: true) // نص ثابت
                            }
                        }
                    }
                    
                    Spacer()
                    
                     Button(action: nextPlayer) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            Text(remainingPlayers.isEmpty ? "ابدأ اللعبة" : "يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 60)  
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: startGame)
    }

    // بدء اللعبة
    private func startGame() {
        assignUniqueRoles()
        remainingPlayers = playerNames.shuffled()
        nextPlayer()
    }

    // الانتقال للاعب التالي
    private func nextPlayer() {
        showRolePage = false
        
        if !remainingPlayers.isEmpty {
            currentPlayer = remainingPlayers.removeFirst()
        } else {
            // خلصنا كل اللاعبين - روح للتايمر
            currentPlayer = nil
            navigationPath.append(TimerViewData(playerNames: playerNames))
        }
    }

    // توزيع الأدوار
    private func assignUniqueRoles() {
        assignedRoles.removeAll()
        var shuffledPlayers = playerNames.shuffled()
        var roles: [String] = []

        if shuffledPlayers.count >= 2 {
            roles.append("ولد")
            roles.append("عجوز")
        } else if shuffledPlayers.count == 1 {
            roles.append("بنت")
        }

        let remainingCount = shuffledPlayers.count - roles.count
        if remainingCount > 0 {
            roles.append(contentsOf: Array(repeating: "بنت", count: remainingCount))
        }

        roles.shuffle()

        for (index, player) in shuffledPlayers.enumerated() {
            assignedRoles[player] = index < roles.count ? roles[index] : "بنت"
        }
    }

    // ربط الدور بالصورة والتعليمات
    private func roleDetails(for role: String) -> (image: String, instructions: String) {
        switch role {
        case "ولد":
            return ("imBoy", "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!")
        case "بنت":
            return ("imGirl", "لازم تنتبهين للولد لما يخطيك وتعلنين خطبتك!")
        case "عجوز":
            return ("imOld", "لازم تراقبين اللاعبين وتقفطين الولد عشان تحمين بناتك!")
        default:
            return ("imBoy", "دورك غير معروف")
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    RoleView(playerNames: ["أحمد", "سارة", "منى", "خالد"], navigationPath: $path)
}
