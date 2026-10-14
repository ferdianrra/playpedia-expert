//
//  FavoriteRepositoryTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import XCTest
import Combine
@testable import PlaypediaData
@testable import PlaypediaDomain

final class FavoriteRepositoryTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    func testToggleEmitsSavedGameThenRemoval() {
        let repository = CoreDataFavoriteRepository(inMemory: true)
        let initial = expectation(description: "Initial favorites")
        let saved = expectation(description: "Saved favorite")
        let removed = expectation(description: "Removed favorite")
        var emissions = 0
        repository.observeGames().sink { completion in
            if case .failure(let error) = completion { XCTFail("\(error)") }
        } receiveValue: { games in
            emissions += 1
            switch emissions {
            case 1: XCTAssertTrue(games.isEmpty); initial.fulfill()
            case 2: XCTAssertEqual(games.first, sampleGame); saved.fulfill()
            case 3: XCTAssertTrue(games.isEmpty); removed.fulfill()
            default: XCTFail("Unexpected update")
            }
        }.store(in: &subscriptions)
        wait(for: [initial], timeout: 2)
        toggle(repository)
        wait(for: [saved], timeout: 2)
        toggle(repository)
        wait(for: [removed], timeout: 2)
    }

    func testLegacyFavoritesMigrateOnce() throws {
        let suite = "Playpedia.Tests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(try JSONEncoder().encode([GameDTO(game: sampleGame)]), forKey: "favoriteGames")
        let repository = CoreDataFavoriteRepository(inMemory: true, legacyDefaults: defaults)
        let migrated = expectation(description: "Legacy migration")
        repository.observeGames().prefix(1).sink { completion in
            if case .failure(let error) = completion { XCTFail("\(error)") }
        } receiveValue: { games in
            XCTAssertEqual(games, [sampleGame])
            XCTAssertNil(defaults.data(forKey: "favoriteGames"))
            migrated.fulfill()
        }.store(in: &subscriptions)
        wait(for: [migrated], timeout: 2)
    }

    private func toggle(_ repository: CoreDataFavoriteRepository) {
        repository.toggle(sampleGame).sink { completion in
            if case .failure(let error) = completion { XCTFail("\(error)") }
        } receiveValue: { _ in }.store(in: &subscriptions)
    }
}
