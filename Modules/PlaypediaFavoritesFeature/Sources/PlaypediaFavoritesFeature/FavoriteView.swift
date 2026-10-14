//
//  FavoriteView.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

#if os(iOS)
import PlaypediaDomain
import PlaypediaUI
import PlaypediaDetailFeature
import PlaypediaFavoritesState
import SwiftUI

public struct FavoriteView: View {
    @Environment(FavoriteStore.self) private var favorites
    private let service: any GameService

    public init(service: any GameService) { self.service = service }

    public var body: some View {
        ZStack {
            AppBackground()
            if favorites.isLoading {
                ProgressView("Loading favorites…").tint(Color.accent)
            } else if let error = favorites.errorMessage {
                StateView(symbol: "exclamationmark.triangle", title: "Unable to load favorites", message: error) {
                    favorites.reload()
                }
            } else if favorites.games.isEmpty {
                StateView(
                    symbol: "heart",
                    title: "No favorites yet",
                    message: "Tap the heart on a game’s details page to save it here."
                )
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        Text("\(favorites.games.count) saved games")
                            .font(.subheadline)
                            .foregroundStyle(Color.textSecondary)
                        ForEach(favorites.games) { game in
                            NavigationLink(value: game) { GameCard(game: game) }
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Game.self) { game in
            GameDetailView(game: game, service: service)
        }
    }
}
#endif
