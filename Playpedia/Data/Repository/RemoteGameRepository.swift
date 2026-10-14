//
//  RemoteGameRepository.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import Combine

struct RemoteGameRepository: GameRepository {
    let network: NetworkService

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        var query = [URLQueryItem(name: "page_size", value: "20"),
                     URLQueryItem(name: "page", value: String(page)),
                     URLQueryItem(name: "ordering", value: orderingParameter(for: order))]
        if !search.isEmpty { query.append(URLQueryItem(name: "search", value: search)) }
        let response: AnyPublisher<GamePageDTO, Error> = network.fetch(path: "games", query: query)
        return response.map { GamePage(next: $0.next, results: $0.results.map { $0.domain }) }
            .eraseToAnyPublisher()
    }

    private func orderingParameter(for order: GameOrder) -> String {
        switch order {
        case .popular: "-added"
        case .topRated: "-rating"
        }
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        let response: AnyPublisher<GameDetailDTO, Error> = network.fetch(path: "games/\(id)")
        return response.map(\.domain).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        let response: AnyPublisher<ScreenshotPageDTO, Error> = network.fetch(path: "games/\(id)/screenshots")
        return response.map { $0.results.map { GameScreenshot(id: $0.id, image: $0.image) } }
            .eraseToAnyPublisher()
    }
}

extension GameCategoryDTO {
    var domain: GameCategory { GameCategory(id: id, name: name) }
}

extension GameDTO {
    var domain: Game {
        Game(id: id, name: name, released: released, backgroundImage: backgroundImage,
             rating: rating, ratingsCount: ratingsCount, genres: genres?.map(\.domain))
    }

    init(game: Game) {
        id = game.id
        name = game.name
        released = game.released
        backgroundImage = game.backgroundImage
        rating = game.rating
        ratingsCount = game.ratingsCount
        genres = game.genres?.map { GameCategoryDTO(id: $0.id, name: $0.name) }
    }
}

extension GameDetailDTO {
    var domain: GameDetail {
        GameDetail(id: id, name: name, descriptionRaw: descriptionRaw, backgroundImage: backgroundImage,
                   released: released, rating: rating, metacritic: metacritic, playtime: playtime,
                   genres: genres?.map(\.domain), developers: developers?.map(\.domain),
                   publishers: publishers?.map(\.domain),
                   platforms: platforms?.map { GamePlatform(platform: $0.platform.domain) }, website: website)
    }
}
