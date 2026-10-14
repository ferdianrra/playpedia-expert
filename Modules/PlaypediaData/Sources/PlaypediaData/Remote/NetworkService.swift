//
//  NetworkService.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import Foundation
import Combine
import Alamofire

public struct NetworkService {
    let session: Session
    let apiKey: String

    public init(session: Session, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }

    public func fetch<Response: Decodable & Sendable>(
        path: String, query: [URLQueryItem] = []
    ) -> AnyPublisher<Response, Error> {
        guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Fail(error: NetworkError.missingAPIKey).eraseToAnyPublisher()
        }
        var components = URLComponents(string: "https://api.rawg.io/api/\(path)")
        components?.queryItems = [URLQueryItem(name: "key", value: apiKey)] + query
        guard let url = components?.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return Deferred {
            session.request(url)
                .validate(statusCode: 200..<300)
                .publishDecodable(type: Response.self)
                .value()
                .mapError { error -> Error in
                    switch error {
                    case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
                        return NetworkError.server(code)
                    case .responseSerializationFailed:
                        return NetworkError.invalidData
                    case .sessionTaskFailed(let underlying):
                        return underlying
                    default:
                        return error
                    }
                }
        }.eraseToAnyPublisher()
    }
}
