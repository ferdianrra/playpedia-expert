//
//  PreviewData.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import PlaypediaFavoritesState
import Combine

enum PreviewData {
    static let games = [
        Game(
            id: 3328,
            name: "The Witcher 3: Wild Hunt",
            released: "2015-05-18",
            backgroundImage: nil,
            rating: 4.6,
            ratingsCount: 7200,
            genres: [GameCategory(id: 4, name: "Action"), GameCategory(id: 5, name: "RPG")]
        ),
        Game(
            id: 3498,
            name: "Grand Theft Auto V",
            released: "2013-09-17",
            backgroundImage: nil,
            rating: 4.5,
            ratingsCount: 6900,
            genres: [GameCategory(id: 4, name: "Action")]
        )
    ]

    @MainActor
    static func favoriteStore(filled: Bool = true) -> FavoriteStore {
        FavoriteStore(useCase: FavoriteUseCase(repository: PreviewFavoriteRepository(games: filled ? games : [])))
    }
}

private final class PreviewFavoriteRepository: FavoriteRepository {
    private let games: CurrentValueSubject<[Game], Error>

    init(games: [Game]) { self.games = CurrentValueSubject(games) }

    func observeGames() -> AnyPublisher<[Game], Error> { games.eraseToAnyPublisher() }

    func toggle(_ game: Game) -> AnyPublisher<Void, Error> {
        var updated = games.value
        if updated.contains(where: { $0.id == game.id }) {
            updated.removeAll { $0.id == game.id }
        } else {
            updated.insert(game, at: 0)
        }
        games.send(updated)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
