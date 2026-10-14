//
//  AppContainerTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import XCTest
import Combine
@testable import PlaypediaComposition
@testable import PlaypediaFavoritesState
@testable import PlaypediaDomain
@testable import PlaypediaData

@MainActor
final class AppContainerTests: XCTestCase {
    func testSwinjectResolvesGameAndFavoriteDependencies() async throws {
        let app = AppContainer(apiKey: "", inMemory: true)
        var configurationError = false
        let subscription = app.games.getGames(search: "", order: .popular, page: 1)
            .sink { completion in
                if case .failure(let error) = completion,
                   case .missingAPIKey = error as? NetworkError {
                    configurationError = true
                }
            } receiveValue: { _ in XCTFail("Missing key should fail") }
        XCTAssertTrue(configurationError)
        withExtendedLifetime(subscription) {}

        try await waitUntil { !app.favorites.isLoading }
        XCTAssertTrue(app.favorites.games.isEmpty)
        app.favorites.toggle(sampleGame)
        try await waitUntil { app.favorites.contains(sampleGame) }
        XCTAssertNil(app.favorites.errorMessage)
    }

    private func waitUntil(_ condition: () -> Bool) async throws {
        let deadline = Date().addingTimeInterval(2)
        while !condition(), Date() < deadline { try await Task.sleep(for: .milliseconds(10)) }
        XCTAssertTrue(condition(), "Resolved favorite repository did not update the UI state")
    }
}
