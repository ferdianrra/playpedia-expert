//
//  FavoriteUseCase.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Combine

protocol FavoriteRepository {
    func observeGames() -> AnyPublisher<[Game], Error>
    func toggle(_ game: Game) -> AnyPublisher<Void, Error>
}

struct FavoriteUseCase {
    let repository: any FavoriteRepository

    func observeGames() -> AnyPublisher<[Game], Error> { repository.observeGames() }
    func toggle(_ game: Game) -> AnyPublisher<Void, Error> { repository.toggle(game) }
}
