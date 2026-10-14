//
//  AppContainer.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import PlaypediaData
import PlaypediaFavoritesState
import Foundation
import Alamofire
import Swinject

@MainActor
public struct AppContainer {
    public let games: any GameService
    public let favorites: FavoriteStore

    public init(apiKey: String = AppConfiguration.rawgAPIKey, inMemory: Bool = false) {
        let container = Container()
        container.register(Session.self) { _ in
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 30
            return Session(configuration: configuration, startRequestsImmediately: false)
        }.inObjectScope(.container)
        container.register(NetworkService.self) { resolver in
            NetworkService(session: resolver.required(Session.self), apiKey: apiKey)
        }
        container.register((any GameRepository).self) { resolver in
            RemoteGameRepository(network: resolver.required(NetworkService.self))
        }
        container.register((any GameService).self) { resolver in
            GameUseCase(repository: resolver.required((any GameRepository).self))
        }
        container.register((any FavoriteRepository).self) { _ in
            CoreDataFavoriteRepository(inMemory: inMemory, legacyDefaults: inMemory ? nil : .standard)
        }.inObjectScope(.container)
        container.register(FavoriteUseCase.self) { resolver in
            FavoriteUseCase(repository: resolver.required((any FavoriteRepository).self))
        }
        container.register(FavoriteStore.self) { resolver in
            FavoriteStore(useCase: resolver.required(FavoriteUseCase.self))
        }.inObjectScope(.container)
        games = container.required((any GameService).self)
        favorites = container.required(FavoriteStore.self)
    }
}

private extension Resolver {
    func required<Service>(_ type: Service.Type) -> Service {
        guard let service = resolve(type) else {
            preconditionFailure("Missing dependency registration: \(type)")
        }
        return service
    }
}
