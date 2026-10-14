//
//  ErrorMessage.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation

enum ErrorMessage {
    static func message(for error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "You’re offline. Check your internet connection and try again."
            case .timedOut:
                return "The request timed out. Please try again."
            default:
                return "Unable to connect. Please try again."
            }
        }
        if let networkError = error as? LocalizedError {
            return networkError.errorDescription ?? "Unable to load data. Please try again."
        }
        return "Unable to load data. Please try again."
    }

}
