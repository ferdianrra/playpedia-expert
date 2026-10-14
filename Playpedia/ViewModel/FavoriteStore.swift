//
//  FavoriteStore.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import Observation
import Combine

@MainActor
@Observable
final class FavoriteStore {
    private(set) var games: [Game] = []
    private(set) var errorMessage: String?
    private(set) var isLoading = true
    private(set) var isSaving = false
    private let useCase: FavoriteUseCase
    private var observation: AnyCancellable?
    private var mutation: AnyCancellable?

    init(useCase: FavoriteUseCase) {
        self.useCase = useCase
        reload()
    }

    func reload() {
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

    func contains(_ game: Game) -> Bool { games.contains { $0.id == game.id } }

    func toggle(_ game: Game) {
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

    func dismissError() { errorMessage = nil }
}
