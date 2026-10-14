//
//  GameDetailViewModelTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import XCTest
import Combine
#if SWIFT_PACKAGE
@testable import PlaypediaCore
#else
@testable import Playpedia
#endif

@MainActor
final class GameDetailViewModelTests: XCTestCase {
    func testScreenshotFailureKeepsDetailAndCanBeRetried() async {
        let service = DetailServiceStub()
        let model = GameDetailViewModel(service: service)
        model.load(id: 42)
        await waitUntil { model.screenshotError != nil && !model.isLoading }
        XCTAssertEqual(model.detail?.id, 42)
        XCTAssertNil(model.errorMessage)
        service.failScreenshots = false
        model.loadScreenshots(id: 42)
        await waitUntil { !model.screenshots.isEmpty }
        XCTAssertEqual(model.screenshots.first?.id, 1)
        XCTAssertNil(model.screenshotError)
    }

    private func waitUntil(_ condition: () -> Bool) async {
        let deadline = Date().addingTimeInterval(2)
        while !condition(), Date() < deadline { try? await Task.sleep(for: .milliseconds(10)) }
        XCTAssertTrue(condition())
    }
}

private final class DetailServiceStub: GameService {
    var failScreenshots = true

    func getGames(search: String, order: GameOrder, page: Int) -> AnyPublisher<GamePage, Error> {
        Just(GamePage(next: nil, results: [])).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getDetail(id: Int) -> AnyPublisher<GameDetail, Error> {
        let detail = GameDetail(id: id, name: "Witcher", descriptionRaw: "Description", backgroundImage: nil,
                                released: nil, rating: 4.6, metacritic: nil, playtime: nil, genres: nil,
                                developers: nil, publishers: nil, platforms: nil, website: nil)
        return Just(detail).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getScreenshots(id: Int) -> AnyPublisher<[GameScreenshot], Error> {
        if failScreenshots { return Fail(error: URLError(.timedOut)).eraseToAnyPublisher() }
        let screenshot = GameScreenshot(id: 1, image: URL(string: "https://example.com/image.jpg")!)
        return Just([screenshot]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
