//
//  NetworkError.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case missingAPIKey
    case invalidURL, invalidData
    case server(Int)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "RAWG API key is missing. Add it to Configuration/Secrets.xcconfig and rebuild the app."
        case .invalidURL:
            "Unable to reach the server. Please try again."
        case .invalidData:
            "Unable to read the game data. Please try again."
        case .server(let status):
            status == 401 || status == 403
                ? "The API key is invalid. Check the RAWG configuration."
                : "The server returned an error (\(status)). Please try again."
        }
    }
}
