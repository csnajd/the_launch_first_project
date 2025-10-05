// RoleView.swift
import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            // Intro page for current player
            if let player = currentPlayer, !showRolePage {
                VStack {
                    VStack(spacing: 20) {
                        Text(player)
                            .font(.PlayerNameText)
                            .bold()
                        Text("لا تخلي احد غيرك يشوف")
                            .font(.PlayerText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)

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
                    .padding(.bottom, 40)
                }
                .padding()
            }

            // Role page for current player
            if let player = currentPlayer, showRolePage {
                VStack {
                    VStack(spacing: 20) {
                        Text(player)
                            .font(.PlayerNameText)
                            .bold()

                        if let role = assignedRoles[player] {
                            let details = roleDetails(for: role)
                            Image(details.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 280)
                                .clipped()

                            // role title (optional)
                            Text(role)
                                .font(.PlayerText)
                                .bold()

                            // instructions (fixed text per role)
                            Text(details.instructions)
                                .font(.PlayerText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxHeight: .infinity)

                    Button(action: {
                        // move to next player
                        showRolePage = false
                        currentPlayer = nil
                        if remainingPlayers.isEmpty {
                            // all players finished — يمكنك هنا العودة للصفحة الرئيسية أو فعل آخر
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
                            Text("يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
        .onAppear {
            // assign roles once when view appears
            assignUniqueRoles()
            if remainingPlayers.isEmpty && !playerNames.isEmpty {
                remainingPlayers = playerNames
            }
            if currentPlayer == nil, let first = remainingPlayers.first {
                currentPlayer = first
                remainingPlayers.removeFirst()
                showRolePage = false
            }
        }
    }

    // assign roles such that there's one 'ولد' and one 'عجوز' and rest 'بنت'
    func assignUniqueRoles() {
        assignedRoles.removeAll()

        var shuffledPlayers = playerNames.shuffled()
        var availableRoles: [String] = []

        // ensure one boy and one old if possible
        if shuffledPlayers.count >= 2 {
            availableRoles.append("ولد")
            availableRoles.append("عجوز")
        } else if shuffledPlayers.count == 1 {
            availableRoles.append("بنت") // if only one player, give 'بنت' (or choose preferred default)
        }

        // fill remaining slots with girls
        let remainingCount = shuffledPlayers.count - availableRoles.count
        if remainingCount > 0 {
            availableRoles.append(contentsOf: Array(repeating: "بنت", count: remainingCount))
        }

        // shuffle roles to randomize which player gets which specific role
        availableRoles.shuffle()

        for (index, player) in shuffledPlayers.enumerated() {
            if index < availableRoles.count {
                assignedRoles[player] = availableRoles[index]
            } else {
                assignedRoles[player] = "بنت"
            }
        }
    }

    // single switch returns both image name and fixed instruction text
    func roleDetails(for role: String) -> (image: String, instructions: String) {
        switch role {
        case "ولد":
            return ("imBoy", "لازم تراقبين اللاعبين وتقفطين الولد عشان تحمين بناتك!")
        case "بنت":
            return ("imGirl", "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!")
        case "عجوز":
            return ("imOld", "لازم تنتبهين للولد لما يخطيك وتعلنين خطبتك!")
        default:
            return ("imBoy", "دورك غير معروف")
        }
    }
}

#Preview {
    RoleView(playerNames: ["A", "B", "C", "D"])
}
