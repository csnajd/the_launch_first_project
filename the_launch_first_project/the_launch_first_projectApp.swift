//
//  the_launch_first_projectApp.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI

@main
struct YourApp: App {
    @StateObject var playerManager = PlayerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerManager)
        }
    }
}
