// RoleView.swift
import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @Binding var navigationPath: NavigationPath
    @State private var assignedRoles: [Int: String] = [:]
    @State private var remainingPlayerIndices: [Int] = []
    @State private var currentPlayerIndex: Int? = nil
    @State private var showRolePage = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 100)
            
                if let player = currentPlayerName, !showRolePage {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            Text(player)
                                .font(.PlayerNameText)
                                .bold()
                            
                            Text("لا تخلي أحد غيرك يشوف")
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
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }

                if let player = currentPlayerName, showRolePage {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            Text(player)
                                .font(.PlayerNameText)
                                .bold()

                            if let role = currentPlayerRole {
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
                                        .fixedSize(horizontal: false, vertical: true)
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
                                Text(remainingPlayerIndices.isEmpty ? "ابدأ اللعبة" : "يلا")
                                    .font(.MainText)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .withHomeButton(navigationPath: $navigationPath)
        .onAppear(perform: startGame)
    }

    private func startGame() {
        assignUniqueRoles()
        remainingPlayerIndices = Array(playerNames.indices).shuffled()
        nextPlayer()
    }

    private func nextPlayer() {
        showRolePage = false
        
        if !remainingPlayerIndices.isEmpty {
            currentPlayerIndex = remainingPlayerIndices.removeFirst()
        } else {
            currentPlayerIndex = nil
            navigationPath.append(TimerViewData(playerNames: playerNames))
        }
    }

    private func assignUniqueRoles() {
        assignedRoles.removeAll()
        var shuffledIndices = Array(playerNames.indices).shuffled()
        var roles: [String] = []

        if shuffledIndices.count >= 2 {
            roles.append("ولد")
            roles.append("عجوز")
        } else if shuffledIndices.count == 1 {
            roles.append("بنت")
        }

        let remainingCount = shuffledIndices.count - roles.count
        if remainingCount > 0 {
            roles.append(contentsOf: Array(repeating: "بنت", count: remainingCount))
        }

        roles.shuffle()

        for (index, playerIndex) in shuffledIndices.enumerated() {
            assignedRoles[playerIndex] = index < roles.count ? roles[index] : "بنت"
        }
    }

    private func roleDetails(for role: String) -> (image: String, instructions: String) {
        switch role {
        case "ولد":
            return ("imBoy", "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!")
        case "بنت":
            return ("imGirl", "لازم تنتبهين للولد لما يخطبك وتعلنين خطبتك!")
        case "عجوز":
            return ("imOld", "لازم تراقبين اللاعبين وتقفطين الولد عشان تحمين بناتك!")
        default:
            return ("imBoy", "دورك غير معروف")
        }
    }
    
    private var currentPlayerName: String? {
        guard let index = currentPlayerIndex, playerNames.indices.contains(index) else { return nil }
        return playerNames[index]
    }
    
    private var currentPlayerRole: String? {
        guard let index = currentPlayerIndex else { return nil }
        return assignedRoles[index]
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    RoleView(playerNames: ["أحمد", "سارة", "منى", "خالد"], navigationPath: $path)
}
