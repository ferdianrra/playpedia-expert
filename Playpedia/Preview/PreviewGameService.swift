//
//  PreviewGameService.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import Combine

struct PreviewGameService: GameService {
    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        let games = PreviewData.games.filter {
            search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
        }
        return Just(GamePage(next: nil, results: games)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        let game = PreviewData.games.first { $0.id == id } ?? PreviewData.games[0]
        let detail = GameDetail(
            id: game.id,
            name: game.name,
            descriptionRaw: "Explore a vast open world, take on quests, and shape your story through your choices.",
            backgroundImage: game.backgroundImage,
            released: game.released,
            rating: game.rating,
            metacritic: 92,
            playtime: 46,
            genres: game.genres,
            developers: [GameCategory(id: 1, name: "CD PROJEKT RED")],
            publishers: [GameCategory(id: 1, name: "CD PROJEKT RED")],
            platforms: [GamePlatform(platform: GameCategory(id: 4, name: "PC"))],
            website: "https://www.thewitcher.com"
        )
        return Just(detail).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
