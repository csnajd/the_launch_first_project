// RoleView.swift
import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false
    @State private var navigateToTimer = false

    var body: some View {
        NavigationStack {
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

                        Spacer()

                        Button(action: nextPlayer) {
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

                // NavigationLink مخفي للانتقال للتايمر بعد آخر لاعب
                NavigationLink(destination: TimerView(), isActive: $navigateToTimer) {
                    EmptyView()
                }
            }
            .onAppear(perform: startGame)
        }
    }

    // بدء اللعبة
    private func startGame() {
        assignUniqueRoles()
        remainingPlayers = playerNames.shuffled()
        nextPlayer()
    }

    // الانتقال للاعب التالي
    private func nextPlayer() {
        if !remainingPlayers.isEmpty {
            currentPlayer = remainingPlayers.removeFirst()
            showRolePage = false
        } else {
            currentPlayer = nil
            navigateToTimer = true
        }
    }

    // توزيع الأدوار: 1 ولد، 1 عجوز، والباقي بنات
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

#if DEBUG
struct RoleView_Previews: PreviewProvider {
    static var previews: some View {
        RoleView(playerNames: ["أحمد", "سارة", "منى", "خالد"])
    }
}
#endif
