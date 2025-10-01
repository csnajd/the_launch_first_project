import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false
    
    private let roles = ["ولد", "بنت", "عجوز"]
    var onComplete: (() -> Void)?
    
    init(playerNames: [String], onComplete: (() -> Void)? = nil) {
        self.playerNames = playerNames
        self._remainingPlayers = State(initialValue: playerNames)
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            // Player's Intro Page
            if let player = currentPlayer, let role = assignedRoles[player], !showRolePage {
                VStack {
                    // Top section - Name and text
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
                    
                    // Bottom section - Button
                    Button(action: {
                        showRolePage = true
                    }) {
                        ZStack{
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 227, height: 55)
                            
                            Text("يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }                    }
                    .padding(.bottom, 40)
                }
                .padding()
            }
            
            // Role Page
            if let player = currentPlayer, let role = assignedRoles[player], showRolePage {
                VStack {
                    // Top section - Name, image and instructions
                    VStack(spacing: 20) {
                        Text(player)
                            .font(.PlayerNameText)
                            .bold()
                        
                        Image(imageName(for: role))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)
                        
                        Text(instructions(for: role))
                            .font(.PlayerText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Bottom section - Button
                    Button(action: {
                        showRolePage = false
                        currentPlayer = nil
                        if remainingPlayers.isEmpty {
                            onComplete?()
                        } else {
                            if let nextPlayer = remainingPlayers.first {
                                currentPlayer = nextPlayer
                                remainingPlayers.removeFirst()
                            }
                        }
                    }) { ZStack{
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
            assignRandomRoles()
            if remainingPlayers.isEmpty && !playerNames.isEmpty {
                remainingPlayers = playerNames
            }
            // Start with first player's intro page immediately
            if currentPlayer == nil, let firstPlayer = remainingPlayers.first {
                currentPlayer = firstPlayer
                remainingPlayers.removeFirst()
                showRolePage = false
            }
        }
    }
    
    func assignRandomRoles() {
        var availableRoles = roles
        var shuffledPlayers = playerNames.shuffled()
        
        assignedRoles.removeAll()
        
        for player in shuffledPlayers {
            if availableRoles.isEmpty {
                availableRoles = roles
            }
            if let randomRole = availableRoles.randomElement() {
                assignedRoles[player] = randomRole
                if let index = availableRoles.firstIndex(of: randomRole) {
                    availableRoles.remove(at: index)
                }
            }
        }
    }
    
    func imageName(for role: String) -> String {
        switch role {
        case "ولد":
            return "imBoy"
        case "بنت":
            return "imGirl"
        case "عجوز":
            return "imOld"
        default:
            return "imBoy"
        }
    }
    
    func instructions(for role: String) -> String {
        switch role {
        case "ولد":
            return "لازم تراقبين اللاعبين وتقفطين الولد عشان تحمين بناتك!"
        case "بنت":
            return "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!"
        case "عجوز":
            return "لازم تنتبهين للولد لما يخطيك وتعلنين خطبتك!"
        default:
            return "دورك غير معروف"
        }
    }
}

#Preview {
    RoleView(playerNames: ["Player1", "Player2", "Player3"])
}
