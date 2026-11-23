import SwiftUI
import UIKit

/// ViewModel responsible for the game logic and state used by `RoleView`.
final class RoleViewModel: ObservableObject {
    
    // MARK: - Input
    
    /// Names of all players in the current game.
    let playerNames: [String]
    
    // MARK: - Published State
    
    /// Mapping between player index and the role assigned to that player.
    @Published private(set) var assignedRoles: [Int: String] = [:]
    
    /// Indices of players that have not yet seen their role.
    @Published private(set) var remainingPlayerIndices: [Int] = []
    
    /// Currently active player index.
    @Published private(set) var currentPlayerIndex: Int?
    
    /// Controls whether the role page (second screen) is visible.
    @Published var showRolePage: Bool = false
    
    /// Indicates that all players have been assigned and seen their roles.
    @Published var didFinishAssigningRoles: Bool = false
    
    // MARK: - Haptics
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Init
    
    init(playerNames: [String]) {
        self.playerNames = playerNames
    }
    
    // MARK: - Computed Properties
    
    /// Convenience accessor for the current player's name.
    var currentPlayerName: String? {
        guard let index = currentPlayerIndex, playerNames.indices.contains(index) else { return nil }
        return playerNames[index]
    }
    
    /// Convenience accessor for the current player's role.
    var currentPlayerRole: String? {
        guard let index = currentPlayerIndex else { return nil }
        return assignedRoles[index]
    }
    
    // MARK: - Public API
    
    /// Starts a new game session by assigning roles and selecting the first player.
    func startGame() {
        assignUniqueRoles()
        remainingPlayerIndices = Array(playerNames.indices).shuffled()
        nextPlayer()
    }
    
    /// Advances to the next player or marks the assignment flow as finished.
    func nextPlayer() {
        showRolePage = false
        
        if !remainingPlayerIndices.isEmpty {
            currentPlayerIndex = remainingPlayerIndices.removeFirst()
        } else {
            currentPlayerIndex = nil
            didFinishAssigningRoles = true
        }
    }
    
    /// Returns presentation details for a given role.
    func roleDetails(for role: String) -> RoleDetailsModel {
        switch role {
        case "ولد":
            return RoleDetailsModel(
                image: "imBoy",
                instructions: "مهمتك تغمز لكل البنات بدون ما تنتبه لك العجوز. وإذا قفطتك قبل ما تكمل، تخس",
                accessibilityInstructions: "مِهِمَّتَكْ تِغْمِزْ لِكُلِّ الْبَنَاتْ بِدُونْ مَا تِنْتَبِهْ لَكْ الْعَجُوزْ. وَإِذَا قفطتك قَبْلْ مَا تِكَمِّلْ، تِخْسَرْ!"
            )
        case "بنت":
            return RoleDetailsModel(
                image: "imGirl",
                instructions: "انتبهي للولد! إذا غمز لك، لا تكشفين هويته، وقولي: «انخطبت!»",
                accessibilityInstructions: "اِنْتَبِهِي لِلْوَلَدْ! إِذَا غَمَزْ لَكْ، لَا تِكْشِفِينَ هُوِيَّتَهْ، وَقُولِي: «اِنْخَطَبْتْ!»"
            )
        case "عجوز":
            return RoleDetailsModel(
                image: "imOld",
                instructions: "مهمتك تراقبين اللاعبين وتقفطين الولد قبل ما يغمز لكل البنات. وإذا قفطتيه، قولي: «قفطتك!»",
                accessibilityInstructions: "راقبي اللاعبين وحاولي تقفطين الولد قبل ما يغمز لكل البنات. وإذا قفطتيه، قولي: «قفطتك!»!»"
            )
        default:
            return RoleDetailsModel(
                image: "imBoy",
                instructions: "دورك غير معروف",
                accessibilityInstructions: "دَوْرُكْ غَيْرُ مَعْرُوفْ"
            )
        }
    }
    
    /// Accessibility label describing the image used for a given role.
    func roleImageLabel(for role: String) -> String {
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
    
    /// Triggers the appropriate haptic feedback based on the current role when VoiceOver is enabled.
    func handleRoleTapped(isVoiceOverOn: Bool) {
        guard isVoiceOverOn, let role = currentPlayerRole else { return }
        triggerHapticForRole(role)
    }
    
    /// Triggers the appropriate haptic feedback when the role page is shown while VoiceOver is running.
    func handleRolePageShown(isVoiceOverRunning: Bool) {
        guard isVoiceOverRunning, let role = currentPlayerRole else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.triggerHapticForRole(role)
        }
    }
    
    // MARK: - Private Helpers
    
    /// Assigns unique roles to all players according to the game rules.
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
    
    /// Low-level haptic feedback logic based on role.
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
}

