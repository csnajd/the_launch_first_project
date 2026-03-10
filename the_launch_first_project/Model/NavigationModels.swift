import Foundation

/// Navigation data for the timer screen, carrying along the current player list.
struct TimerViewData: Hashable {
    let playerNames: [String]
}

/// Navigation data for the end-game screen, carrying along the current player list.
struct EndGameViewData: Hashable {
    let playerNames: [String]
}

/// Navigation data for the role-assignment screen.
struct RoleViewData: Hashable {
    let playerNames: [String]
}

