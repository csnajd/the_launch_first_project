// RoleView.swift
import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @Binding var navigationPath: NavigationPath //Mayar Add this !
    @EnvironmentObject var playerManager: PlayerManager //Mayar Add This !
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            // صفحة تقديم اللاعب
            if let player = currentPlayer, !showRolePage {
                VStack {
                    Text(player)
                        .font(.title)
                        .bold()
                    Text("لا تخلي احد غيرك يشوف")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()

                    Button(action: { showRolePage = true }) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            Text("يلا")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding()
            }

            // صفحة الدور لكل لاعب
            if let player = currentPlayer, showRolePage {
                VStack {
                    Text(player)
                        .font(.title)
                        .bold()

                    if let role = assignedRoles[player] {
                        let details = roleDetails(for: role)
                        Image(details.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)

                        Text(role)
                            .font(.headline)
                            .bold()

                        Text(details.instructions)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                    
                    
                    //Mayar Add This!
                    Button(action: {
                        showRolePage = false
                        currentPlayer = nil
                        
                        // التحقق إذا كان هذا آخر لاعب
                        if remainingPlayers.isEmpty {
                            // إذا كان آخر لاعب، اذهب لـ TimerView
                            navigationPath.append("TimerView")
                        } else {
                            currentPlayer = remainingPlayers.first
                            remainingPlayers.removeFirst()
                        }
                    }) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            Text(remainingPlayers.isEmpty ? "ابدأ اللعبة" : "التالي")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
        //
        .onAppear {
                   
                   assignUniqueRoles()
                   if remainingPlayers.isEmpty && !playerManager.playerNames.isEmpty {
                       remainingPlayers = playerManager.playerNames
                   }
                   if currentPlayer == nil, let first = remainingPlayers.first {
                       currentPlayer = first
                       remainingPlayers.removeFirst()
                       showRolePage = false
                   }
               }
           }

    // توزيع الأدوار: 1 ولد، 1 عجوز، والباقي بنات
    private func assignUniqueRoles() {
        assignedRoles.removeAll()
        
        var shuffledPlayers = playerManager.playerNames.shuffled()
        var availableRoles: [String] = []
        
        // ensure one boy and one old if possible
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
        RoleView(playerNames: ["A", "B", "C", "D"], navigationPath: .constant(NavigationPath()))
            .environmentObject(PlayerManager()) //Mayar Add this !

    }
}
#endif
