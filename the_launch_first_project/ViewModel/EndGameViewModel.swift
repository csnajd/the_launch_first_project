import SwiftUI

/// ViewModel for the end-of-round summary screen.
/// Owns the interactions that occur when the round has finished.
final class EndGameViewModel: ObservableObject {
    
    
    private let timerManager: TimerManager
    let playerNames: [String]
    
    init(timerManager: TimerManager, playerNames: [String]) {
        self.timerManager = timerManager
        self.playerNames = playerNames
    }
    
    
    /// Called when the view appears to ensure any playing alarms are stopped.
    func onAppear() {
        timerManager.stopAlarm()
    }
    
    
    /// Starts another round with the same players.
    func playAnotherRound(navigationPath: Binding<NavigationPath>) {
        timerManager.reset()
        navigationPath.wrappedValue.removeLast(navigationPath.wrappedValue.count)
        let roleViewData = RoleViewData(playerNames: playerNames)
        navigationPath.wrappedValue.append(roleViewData)
    }
    
    /// Navigates back to the add-players screen to select different players.
    func changePlayers(navigationPath: Binding<NavigationPath>) {
        navigationPath.wrappedValue.removeLast(navigationPath.wrappedValue.count)
        navigationPath.wrappedValue.append("AddPlayerView")
    }
}

