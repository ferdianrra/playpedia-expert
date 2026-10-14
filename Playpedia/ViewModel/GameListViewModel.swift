//
//  GameListViewModel.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import Foundation
import Combine
import Observation

@MainActor
@Observable
final class GameListViewModel {
    var searchText = "" { didSet { if oldValue != searchText { startLoad(debounce: true) } } }
    var order = GameOrder.popular { didSet { if oldValue != order { startLoad(debounce: false) } } }
    private(set) var games: [Game] = []
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var hasNextPage = false
    private(set) var errorMessage: String?
    private let service: any GameService
    private var page = 1
    private var requestID = UUID()
    private let loads = PassthroughSubject<LoadRequest, Never>()
    private var listSubscription: AnyCancellable?
    private var pageSubscription: AnyCancellable?

    init(service: any GameService) {
        self.service = service
        listSubscription = loads
            .map { request in
                Just(request)
                    .delay(for: request.debounce ? .milliseconds(350) : .zero, scheduler: RunLoop.main)
                    .flatMap { query in
                        service.getGames(search: query.search, order: query.order, page: 1)
                            .map { Result<GamePage, Error>.success($0) }
                            .catch { Just(Result<GamePage, Error>.failure($0)) }
                    }
                    .map { (request.id, $0) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink { [weak self] id, result in
                guard let self, id == requestID else { return }
                isLoading = false
                switch result {
                case .success(let result):
                    games = result.results
                    hasNextPage = result.next != nil
                    page = 1
                case .failure(let error):
                    errorMessage = ErrorMessage.message(for: error)
                }
            }
    }

    func loadGames() { startLoad(debounce: false) }

    private func startLoad(debounce: Bool) {
        requestID = UUID()
        pageSubscription?.cancel()
        isLoading = true
        isLoadingMore = false
        errorMessage = nil
        hasNextPage = false
        games = []
        loads.send(LoadRequest(id: requestID, search: searchText, order: order, debounce: debounce))
    }

    func loadMoreIfNeeded(after game: Game) {
        guard errorMessage == nil, games.suffix(3).contains(where: { $0.id == game.id }) else { return }
        loadNextPage()
    }

    func loadNextPage() {
        guard hasNextPage, !isLoading, !isLoadingMore else { return }
        let currentID = requestID
        isLoadingMore = true
        errorMessage = nil
        pageSubscription = service.getGames(search: searchText, order: order, page: page + 1)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self, currentID == requestID else { return }
                isLoadingMore = false
                if case .failure(let error) = completion { errorMessage = ErrorMessage.message(for: error) }
            } receiveValue: { [weak self] result in
                guard let self, currentID == requestID else { return }
                var existingIDs = Set(games.map(\.id))
                games.append(contentsOf: result.results.filter { existingIDs.insert($0.id).inserted })
                page += 1
                hasNextPage = result.next != nil
            }
    }
}

private struct LoadRequest {
    let id: UUID
    let search: String
    let order: GameOrder
    let debounce: Bool
}
