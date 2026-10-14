//
//  GameService.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import Combine

public enum GameOrder: CaseIterable, Identifiable {
    case popular
    case topRated

    public var id: Self { self }

    public var title: String {
        switch self {
        case .popular: "Popular"
        case .topRated: "Top rated"
        }
    }
}

public protocol GameService {
    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error>
    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error>
    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error>
}

public protocol GameRepository: GameService {}

public struct GameUseCase: GameService {
    private let repository: any GameRepository

    public init(repository: any GameRepository) { self.repository = repository }

    public func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        repository.getGames(
            search: search.trimmingCharacters(in: .whitespacesAndNewlines), order: order, page: max(1, page)
        )
    }

    public func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        repository.getDetail(id: id)
    }

    public func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        repository.getScreenshots(id: id)
    }
}
