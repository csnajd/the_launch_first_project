//
//  PlayerManager.swift
//  the_launch_first_project
//
//  Created by yumii on 05/10/2025.
//

import SwiftUI

class PlayerManager: ObservableObject {
    @Published var playerNames: [String] = []
    
    func setPlayerNames(_ names: [String]) {
        playerNames = names
    }
}
