//
//  GameDetailViewModel.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PlaypediaDomain
import PlaypediaUI
import Foundation
import Combine
import Observation

@MainActor
@Observable
public final class GameDetailViewModel {
    public private(set) var detail: GameDetail?
    public private(set) var screenshots: [GameScreenshot] = []
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?
    public private(set) var screenshotError: String?
    private let service: any GameService
    private var detailSubscription: AnyCancellable?
    private var screenshotSubscription: AnyCancellable?
    private var requestID = UUID()
    private var screenshotRequestID = UUID()

    public init(service: any GameService) { self.service = service }

    public func load(id: Int) {
        guard detail == nil, !isLoading else { return }
        requestID = UUID()
        let currentID = requestID
        isLoading = true
        errorMessage = nil
        detailSubscription = service.getDetail(id: id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self, currentID == requestID else { return }
                isLoading = false
                if case .failure(let error) = completion { errorMessage = ErrorMessage.message(for: error) }
            } receiveValue: { [weak self] detail in
                guard let self, currentID == requestID else { return }
                self.detail = detail
                loadScreenshots(id: id)
            }
    }

    public func loadScreenshots(id: Int) {
        screenshotRequestID = UUID()
        let currentID = screenshotRequestID
        screenshotError = nil
        screenshotSubscription = service.getScreenshots(id: id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self, currentID == screenshotRequestID else { return }
                if case .failure = completion { screenshotError = "Unable to load screenshots." }
            } receiveValue: { [weak self] in
                guard let self, currentID == screenshotRequestID else { return }
                screenshots = $0
            }
    }
}
