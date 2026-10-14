//
//  FavoriteUseCase.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Combine

public protocol FavoriteRepository {
    func observeGames() -> AnyPublisher<[Game], Error>
    func toggle(_ game: Game) -> AnyPublisher<Void, Error>
}

public struct FavoriteUseCase {
    private let repository: any FavoriteRepository

    public init(repository: any FavoriteRepository) { self.repository = repository }

    public func observeGames() -> AnyPublisher<[Game], Error> { repository.observeGames() }
    public func toggle(_ game: Game) -> AnyPublisher<Void, Error> { repository.toggle(game) }
}
