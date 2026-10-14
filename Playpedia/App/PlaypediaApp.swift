//
//  PlaypediaApp.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import SwiftUI

@main
struct PlaypediaApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(favorites: container.favorites, service: container.games)
        }
    }
}
