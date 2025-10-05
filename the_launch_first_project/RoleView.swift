import SwiftUI

struct RoleView: View {
    let playerNames: [String]
    @State private var assignedRoles: [String: String] = [:]
    @State private var remainingPlayers: [String] = []
    @State private var currentPlayer: String? = nil
    @State private var showRolePage = false

    var body: some View {
        ZStack {
            // صفحة تقديم اللاعب
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

            // صفحة الدور لكل لاعب
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
                            Text(details.instructions)
                                .font(.PlayerText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxHeight: .infinity)

                    Button(action: {
                        showRolePage = false
                        currentPlayer = nil
                        if remainingPlayers.isEmpty {
                            // الانتقال إلى الصفحة التالية هنا
                        }
                        else {
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
            assignUniqueRoles() // استخدام الدالة الجديدة
            if remainingPlayers.isEmpty && !playerNames.isEmpty {
                remainingPlayers = playerNames
            }
            if currentPlayer == nil, let firstPlayer = remainingPlayers.first {
                currentPlayer = firstPlayer
                remainingPlayers.removeFirst()
                showRolePage = false
            }
        }
    }

    // الدالة الصحيحة: تضمن أن كل دور يظهر مرة واحدة فقط
    func assignUniqueRoles() {
        assignedRoles.removeAll()
        
        var shuffledPlayers = playerNames.shuffled()
        var availableRoles: [String] = []
        
        // إضافة الأدوار الأساسية (واحد من كل نوع)
        availableRoles.append("ولد")
        availableRoles.append("عجوز")
        
        // إضافة الباقي كبنات
        let remainingCount = shuffledPlayers.count - 2
        if remainingCount > 0 {
            availableRoles.append(contentsOf: Array(repeating: "بنت", count: remainingCount))
        }
        
        // خلط الأدوار
        availableRoles.shuffle()
        
        // توزيع الأدوار على اللاعبين
        for (index, player) in shuffledPlayers.enumerated() {
            if index < availableRoles.count {
                assignedRoles[player] = availableRoles[index]
            } else {
                // في حال وجود لاعبين أكثر من المتوقع
                assignedRoles[player] = "بنت"
            }
        }
        
        // طباعة للتأكد (للتデバッグ)
        print("الأدوار الموزعة:")
        for (player, role) in assignedRoles {
            print("\(player): \(role)")
        }
    }

    // دالة واحدة تربط الدور بالصورة والنص الثابت
    func roleDetails(for role: String) -> (image: String, instructions: String) {
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
    RoleView(playerNames: ["Player1", "Player2", "Player3", "Player4"])
}
