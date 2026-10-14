//
//  GameListViewModelTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import XCTest
import Combine
#if SWIFT_PACKAGE
@testable import PlaypediaCore
#else
@testable import Playpedia
#endif

@MainActor
final class GameListViewModelTests: XCTestCase {
    func testPaginationKeepsExistingGamesWithoutDuplicates() async {
        let service = ListServiceStub()
        let model = GameListViewModel(service: service)
        model.loadGames()
        await waitUntil { !model.isLoading }
        XCTAssertEqual(model.games, [sampleGame])
        XCTAssertTrue(model.hasNextPage)
        model.loadNextPage()
        await waitUntil { !model.isLoadingMore }
        XCTAssertEqual(model.games.map(\.id), [42, 7])
        XCTAssertFalse(model.hasNextPage)
        XCTAssertFalse(model.isLoadingMore)
    }

    func testSearchDebounceRequestsOnlyLatestTerm() async {
        let service = ListServiceStub()
        let model = GameListViewModel(service: service)
        model.searchText = "W"
        model.searchText = "Witch"
        model.searchText = "Witcher"
        model.searchText = "Witcher"
        await waitUntil { !model.isLoading }
        XCTAssertEqual(service.searchRequests, ["Witcher"])
        XCTAssertEqual(model.games, [sampleGame])
    }
    func testQueryChangeCancelsOldRequestAndIgnoresItsResult() async {
        let service = ControlledListService()
        let model = GameListViewModel(service: service)
        model.searchText = "old"
        await waitUntil { service.requests["old"] != nil }
        model.searchText = "new"
        XCTAssertEqual(service.cancelled, ["old"])
        service.requests["old"]?.send(GamePage(next: nil, results: [sampleGame]))
        await waitUntil { service.requests["new"] != nil }
        service.requests["new"]?.send(GamePage(next: nil, results: []))
        await waitUntil { !model.isLoading }
        XCTAssertTrue(model.games.isEmpty)
        XCTAssertNil(model.errorMessage)
    }

    func testFailedRequestCanBeRetriedWithoutEndingSearchStream() async {
        let service = ControlledListService()
        let model = GameListViewModel(service: service)
        model.loadGames()
        await waitUntil { service.requests[""] != nil }
        service.requests[""]?.send(completion: .failure(URLError(.notConnectedToInternet)))
        await waitUntil { model.errorMessage != nil }
        XCTAssertFalse(model.isLoading)
        model.loadGames()
        await waitUntil { service.requestCount == 2 }
        service.requests[""]?.send(GamePage(next: nil, results: [sampleGame]))
        await waitUntil { !model.isLoading }
        XCTAssertEqual(model.games, [sampleGame])
        XCTAssertNil(model.errorMessage)
    }

    private func waitUntil(_ condition: () -> Bool) async {
        let deadline = Date().addingTimeInterval(2)
        while !condition(), Date() < deadline { try? await Task.sleep(for: .milliseconds(10)) }
        XCTAssertTrue(condition())
    }

}

private final class ListServiceStub: GameService {
    var searchRequests: [String] = []

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        searchRequests.append(search)
        let other = Game(id: 7, name: "Another game", released: nil, backgroundImage: nil,
                         rating: 4, ratingsCount: nil, genres: nil)
        let result = GamePage(next: page == 1 ? URL(string: "https://example.com/page2") : nil,
                              results: page == 1 ? [sampleGame] : [sampleGame, other])
        return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

private final class ControlledListService: GameService {
    var requests: [String: PassthroughSubject<GamePage, Error>] = [:]
    var cancelled: [String] = []
    var requestCount = 0

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        requestCount += 1
        let subject = PassthroughSubject<GamePage, Error>()
        requests[search] = subject
        return subject.handleEvents(receiveCancel: { [weak self] in self?.cancelled.append(search) })
            .eraseToAnyPublisher()
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
