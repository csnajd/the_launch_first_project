import SwiftUI

/// ViewModel for `AddPlayerView`, responsible for managing the dynamic list of player names.
final class AddPlayerViewModel: ObservableObject {
    
    /// Raw input names entered by the user.
    @Published var names: [String] = ["", "", ""]
    
    /// Returns the trimmed, non-empty player names used to start the game.
    var trimmedNames: [String] {
        names
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    /// Adds a new empty name field.
    func addNameField() {
        names.append("")
    }
    
    /// Removes the name at the given index if there are more than three fields.
    func removeName(at index: Int) {
        guard names.count > 3, names.indices.contains(index) else { return }
        names.remove(at: index)
    }
    
    /// Whether the user is allowed to delete a row.
    var canDeleteRow: Bool {
        names.count > 3
    }
    
    /// Whether the current trimmed list is valid for starting a game.
    var canStartGame: Bool {
        trimmedNames.count >= 3
    }
}

