// RoleView.swift
import SwiftUI
import UIKit

struct RoleView: View {
    let playerNames: [String]
    @Binding var navigationPath: NavigationPath
    @State private var assignedRoles: [Int: String] = [:]
    @State private var remainingPlayerIndices: [Int] = []
    @State private var currentPlayerIndex: Int? = nil
    @State private var showRolePage = false
    @Environment(\.accessibilityEnabled) var isVoiceOverOn
    
    // Haptic
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private func triggerHapticForRole(_ role: String) {
        switch role {
        case "بنت":
            notificationGenerator.notificationOccurred(.success)
        case "عجوز":
            heavyImpactGenerator.impactOccurred()
        case "ولد":
            lightImpactGenerator.impactOccurred()
        default:
            break
        }
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .accessibilityHidden(true)
            
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
                        
                        Button(action: {
                            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                            impactGenerator.impactOccurred()
                            showRolePage = true
                        }) {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                    .accessibilityHidden(true)
                                Text("يلا")
                                    .font(.MainText)
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("يَلَّا")
                        .accessibilityRemoveTraits(.isButton)
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
                                    .accessibilityLabel(roleImageLabel(for: role))
                                
                                VStack(spacing: 15) {
                                    Text(role)
                                        .font(.PlayerText)
                                        .bold()

                                    Text(details.instructions)
                                        .font(.PlayerText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accessibilityLabel(details.accessibilityInstructions)
                                }
                                .accessibilityElement(children: .combine)
                            }
                        }
                        .onTapGesture {
                            if isVoiceOverOn, let role = currentPlayerRole {
                                triggerHapticForRole(role)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let impactGenerator = UIImpactFeedbackGenerator(style: .light)
                            impactGenerator.impactOccurred()
                            nextPlayer()
                        }) {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 227, height: 55)
                                    .accessibilityHidden(true)
                                Text(remainingPlayerIndices.isEmpty ? "ابدأ اللعبة" : "يلا")
                                    .font(.MainText)
                                    .foregroundColor(.white)
                            }
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(remainingPlayerIndices.isEmpty ? "اِبْدَأِ اللَّعِب" : "يَلَّا")
                        .accessibilityRemoveTraits(.isButton)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .withHomeButton(navigationPath: $navigationPath)
        .onAppear {
            startGame()
        }
        .onChange(of: showRolePage) { _, isShowing in
            if isShowing {
                if UIAccessibility.isVoiceOverRunning, let role = currentPlayerRole {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        triggerHapticForRole(role)
                    }
                }
            }
        }
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

    private func roleDetails(for role: String) -> (image: String, instructions: String, accessibilityInstructions: String) {
        switch role {
        case "ولد":
            return ("imBoy", "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!", "لَازِمْ تَحَاوِلْ تَعْرِفْ مِينْ الْبَنَاتْ عَشَانْ تَخْطِبْهُمْ وَانْتَبِهْ مِنَ الْعَجُوزْ لَا تَقْفُطْكْ!")
        case "بنت":
            return ("imGirl", "لازم تنتبهين للولد لما يخطبك وتعلنين خطبتك!", "لَازِمْ تَنْتَبِهِينَ لِلْوَلَدْ لَمَّا يَخْطِبْكِ وَتُعْلِنِينَ خِطْبَتِكِ!")
        case "عجوز":
            return ("imOld", "لازم تراقبين اللاعبين وتقفطين الولد عشان تحمين بناتك!", "لَازِمْ تُرَاقِبِينَ اللَّاعِبِينَ وَتُقْفِطِينَ الْوَلَدْ عَشَانْ تَحْمِينَ بَنَاتِكِ!")
        default:
            return ("imBoy", "دورك غير معروف", "دَوْرُكْ غَيْرُ مَعْرُوفْ")
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
    
    private func roleImageLabel(for role: String) -> String {
        switch role {
        case "ولد":
            return "صورة ولد"
        case "بنت":
            return "صورة بنت"
        case "عجوز":
            return "صورة عجوز"
        default:
            return "صورة شخصية"
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    RoleView(playerNames: ["أحمد", "سارة", "منى", "خالد"], navigationPath: $path)
}
