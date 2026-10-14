//
//  FavoriteStore.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import Foundation
import Observation
import Combine

@MainActor
@Observable
public final class FavoriteStore {
    public private(set) var games: [Game] = []
    public private(set) var errorMessage: String?
    public private(set) var isLoading = true
    public private(set) var isSaving = false
    private let useCase: FavoriteUseCase
    private var observation: AnyCancellable?
    private var mutation: AnyCancellable?

    public init(useCase: FavoriteUseCase) {
        self.useCase = useCase
        reload()
    }

    public func reload() {
        isLoading = true
        errorMessage = nil
        observation = useCase.observeGames()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.isLoading = false
                    self?.errorMessage = "Unable to read saved games. Please try again."
                }
            } receiveValue: { [weak self] in
                self?.games = $0
                self?.isLoading = false
            }
    }

    public func contains(_ game: Game) -> Bool { games.contains { $0.id == game.id } }

    public func toggle(_ game: Game) {
        guard !isSaving else { return }
        isSaving = true
        errorMessage = nil
        mutation = useCase.toggle(game)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isSaving = false
                if case .failure = completion {
                    self?.errorMessage = "Unable to save favorites. Please try again."
                }
            } receiveValue: { _ in }
    }

    public func dismissError() { errorMessage = nil }
}
