//
//  GameService.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import Combine

enum GameOrder: CaseIterable, Identifiable {
    case popular
    case topRated

    var id: Self { self }

    var title: String {
        switch self {
        case .popular: "Popular"
        case .topRated: "Top rated"
        }
    }
}

protocol GameService {
    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error>
    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error>
    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error>
}

protocol GameRepository: GameService {}

struct GameUseCase: GameService {
    let repository: any GameRepository

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        repository.getGames(
            search: search.trimmingCharacters(in: .whitespacesAndNewlines), order: order, page: max(1, page)
        )
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        repository.getDetail(id: id)
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        repository.getScreenshots(id: id)
    }
}
