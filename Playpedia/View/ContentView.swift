//
//  ContentView.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var favorites: FavoriteStore
    private let service: any GameService

    init(favorites: FavoriteStore, service: any GameService) {
        _favorites = State(initialValue: favorites)
        self.service = service
    }

    var body: some View {
        TabView {
            NavigationStack {
                GameListView(service: service)
            }
            .tabItem { Label("Home", systemImage: "gamecontroller.fill") }

            NavigationStack {
                FavoriteView(service: service)
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }

            NavigationStack {
                AboutView()
            }
            .tabItem { Label("About", systemImage: "person.fill") }
        }
        .environment(favorites)
        .environment(\.locale, Locale(identifier: "en_US"))
        .tint(Color.accent)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView(favorites: PreviewData.favoriteStore(), service: PreviewGameService())
}
