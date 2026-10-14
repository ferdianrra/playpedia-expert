//
//  NetworkServiceTests.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import XCTest
import Combine
import Alamofire
#if SWIFT_PACKAGE
@testable import PlaypediaCore
#else
@testable import Playpedia
#endif

final class NetworkServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions.removeAll()
        NetworkURLProtocol.handler = nil
        NetworkURLProtocol.onStop = nil
        super.tearDown()
    }

    func testDecodesResponseAndPreservesQuery() {
        NetworkURLProtocol.handler = { request in
            let url = try XCTUnwrap(request.url)
            let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
            XCTAssertEqual(query.first { $0.name == "search" }?.value, "The Witcher")
            XCTAssertEqual(query.first { $0.name == "key" }?.value, "test-key")
            XCTAssertEqual(url.path, "/api/games")
            return (200, Data(#"{"next":null,"results":[{"id":42,"name":"Witcher","rating":4.6}]}"#.utf8))
        }
        let response: AnyPublisher<GamePageDTO, Error> = network().fetch(
            path: "games", query: [URLQueryItem(name: "search", value: "The Witcher")]
        )
        let decoded = expectation(description: "Decoded RAWG response")
        response.sink { completion in
            if case .failure(let error) = completion { XCTFail("\(error)") }
        } receiveValue: { page in
            XCTAssertEqual(page.results.first?.domain.id, 42)
            decoded.fulfill()
        }.store(in: &subscriptions)
        wait(for: [decoded], timeout: 2)
    }

    func testRepositoryMapsDomainSortingToRAWGQuery() {
        for (order, parameter) in [(GameOrder.popular, "-added"), (.topRated, "-rating")] {
            NetworkURLProtocol.handler = { request in
                let url = try XCTUnwrap(request.url)
                let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
                XCTAssertEqual(query.first { $0.name == "ordering" }?.value, parameter)
                return (200, Data(#"{"next":null,"results":[]}"#.utf8))
            }
            let completed = expectation(description: "Mapped sorting query")
            let repository = RemoteGameRepository(network: network())
            repository.getGames(search: "", order: order, page: 1)
                .sink { completion in
                    if case .failure(let error) = completion { XCTFail("\(error)") }
                } receiveValue: { _ in completed.fulfill() }.store(in: &subscriptions)
            withExtendedLifetime(repository) { wait(for: [completed], timeout: 2) }
        }
    }

    func testRejectsUnauthorizedResponse() {
        assertFailure(status: 401, data: Data()) { error in
            guard case .server(401) = error as? NetworkError else {
                return XCTFail("Expected unauthorized error")
            }
        }
    }

    func testRejectsMalformedJSON() {
        assertFailure(status: 200, data: Data("invalid json".utf8)) { error in
            guard case .invalidData = error as? NetworkError else {
                return XCTFail("Expected decoding error")
            }
        }
    }

    func testCancellationStopsUnderlyingRequest() {
        let started = expectation(description: "Request started")
        let stopped = expectation(description: "Request cancelled")
        NetworkURLProtocol.handler = { _ in started.fulfill(); return nil }
        NetworkURLProtocol.onStop = { stopped.fulfill() }
        let response: AnyPublisher<GamePageDTO, Error> = network().fetch(path: "games")
        let subscription = response.sink(receiveCompletion: { _ in }, receiveValue: { _ in
            XCTFail("Cancelled request must not return data")
        })
        wait(for: [started], timeout: 2)
        subscription.cancel()
        wait(for: [stopped], timeout: 2)
    }

    private func network() -> NetworkService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [NetworkURLProtocol.self]
        return NetworkService(session: Session(configuration: configuration, startRequestsImmediately: false),
                              apiKey: "test-key")
    }

    private func assertFailure(status: Int, data: Data, check: @escaping (Error) -> Void) {
        NetworkURLProtocol.handler = { _ in (status, data) }
        let failed = expectation(description: "Request failed")
        let response: AnyPublisher<GamePageDTO, Error> = network().fetch(path: "games")
        response.sink { completion in
            if case .failure(let error) = completion { check(error); failed.fulfill() }
        } receiveValue: { _ in XCTFail("Unexpected response") }.store(in: &subscriptions)
        wait(for: [failed], timeout: 2)
    }

    func testMissingKeyFailsBeforeStartingNetworkRequest() {
        let network = NetworkService(session: Session(startRequestsImmediately: false), apiKey: " \n")
        let response: AnyPublisher<GamePageDTO, Error> = network.fetch(path: "games")
        var receivedMissingKey = false
        let subscription = response.sink { completion in
            if case .failure(let error) = completion,
               case .missingAPIKey = error as? NetworkError {
                receivedMissingKey = true
            }
        } receiveValue: { _ in XCTFail("Missing configuration must not return game data") }
        XCTAssertTrue(receivedMissingKey)
        withExtendedLifetime(subscription) {}
    }
}

private final class NetworkURLProtocol: URLProtocol, @unchecked Sendable {
    static var handler: ((URLRequest) throws -> (Int, Data)?)?
    static var onStop: (() -> Void)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        do {
            guard let handler = Self.handler else { throw URLError(.badServerResponse) }
            guard let (status, data) = try handler(request) else { return }
            let url = try XCTUnwrap(request.url)
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: status,
                                                       httpVersion: nil, headerFields: nil))
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() { Self.onStop?() }
}
