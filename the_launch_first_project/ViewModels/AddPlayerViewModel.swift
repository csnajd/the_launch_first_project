import SwiftUI

/// One editable name field with a stable identity, independent of its array position.
struct PlayerInput: Identifiable {
    let id = UUID()
    var name: String = ""
}

/// ViewModel for `AddPlayerView`, responsible for managing the dynamic list of player names.
final class AddPlayerViewModel: ObservableObject {

    private static let savedNamesKey = "qaffatek.savedPlayerNames"

    /// Player inputs are saved locally after every edit, addition, or deletion.
    @Published var players: [PlayerInput] {
        didSet {
            UserDefaults.standard.set(players.map(\.name), forKey: Self.savedNamesKey)
        }
    }

    init() {
        let savedNames = UserDefaults.standard.stringArray(forKey: Self.savedNamesKey) ?? []
        players = savedNames.map { PlayerInput(name: $0) }
        while players.count < 3 {
            players.append(PlayerInput())
        }
    }

    /// Returns the trimmed, non-empty player names used to start the game.
    var trimmedNames: [String] {
        players
            .map { $0.name.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// Adds a new empty name field.
    func addNameField() {
        players.append(PlayerInput())
    }

    /// Removes the selected field by stable identity if more than three fields remain.
    func removeName(id: UUID) {
        guard players.count > 3 else { return }
        players.removeAll { $0.id == id }
    }

    /// Whether the user is allowed to delete a row.
    var canDeleteRow: Bool {
        players.count > 3
    }

    /// Whether the current trimmed list is valid for starting a game.
    var canStartGame: Bool {
        trimmedNames.count >= 3
    }
}
