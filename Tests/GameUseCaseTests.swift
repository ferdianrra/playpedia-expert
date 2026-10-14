//
//  GameUseCaseTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import XCTest
import Combine
@testable import PlaypediaDomain

final class GameUseCaseTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    func testSearchTrimsWhitespaceAndClampsPage() {
        let repository = GameRepositoryStub()
        let useCase = GameUseCase(repository: repository)
        useCase.getGames(search: "  Witcher \n", order: .topRated, page: 0)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
        XCTAssertEqual(repository.search, "Witcher")
        XCTAssertEqual(repository.page, 1)
        XCTAssertEqual(repository.order, .topRated)
    }

    func testRepositoryFailureReachesCaller() {
        let repository = GameRepositoryStub()
        let completed = expectation(description: "Repository error")
        GameUseCase(repository: repository).getDetail(id: 42)
            .sink { completion in
                guard case .failure(let error) = completion else {
                    return XCTFail("Expected failure")
                }
                XCTAssertTrue(error is StubError)
                completed.fulfill()
            } receiveValue: { _ in XCTFail("Unexpected detail") }
            .store(in: &subscriptions)
        wait(for: [completed], timeout: 1)
        XCTAssertEqual(repository.detailID, 42)
    }

    func testScreenshotRequestUsesSelectedGameID() {
        let repository = GameRepositoryStub()
        GameUseCase(repository: repository).getScreenshots(id: 7)
            .sink(receiveCompletion: { _ in }, receiveValue: { XCTAssertTrue($0.isEmpty) })
            .store(in: &subscriptions)
        XCTAssertEqual(repository.screenshotID, 7)
    }

    func testFavoriteUseCasePublishesUpdatesAndDelegatesToggle() {
        let repository = FavoriteRepositoryStub()
        let useCase = FavoriteUseCase(repository: repository)
        var observed: [[Game]] = []
        useCase.observeGames().sink(receiveCompletion: { _ in }, receiveValue: { observed.append($0) })
            .store(in: &subscriptions)
        let game = sampleGame
        useCase.toggle(game).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
        XCTAssertEqual(observed.map(\.count), [0, 1])
        XCTAssertEqual(repository.toggledID, game.id)
    }
}

private enum StubError: Error { case unavailable }

private final class GameRepositoryStub: GameRepository {
    var search: String?
    var page: Int?
    var order: GameOrder?
    var detailID: Int?
    var screenshotID: Int?

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        self.search = search
        self.order = order
        self.page = page
        return Just(GamePage(next: nil, results: [])).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        detailID = id
        return Fail(error: StubError.unavailable).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        screenshotID = id
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

private final class FavoriteRepositoryStub: FavoriteRepository {
    let games = CurrentValueSubject<[Game], Error>([])
    var toggledID: Int?

    func observeGames() -> AnyPublisher<[Game], Error> { games.eraseToAnyPublisher() }
    func toggle(_ game: Game) -> AnyPublisher<Void, Error> {
        toggledID = game.id
        games.send([game])
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

let sampleGame = Game(id: 42, name: "Witcher", released: "2015-05-18",
                      backgroundImage: nil, rating: 4.6, ratingsCount: 10, genres: [])
