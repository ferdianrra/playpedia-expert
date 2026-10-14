//
//  Game.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation

struct GamePage {
    let next: URL?
    let results: [Game]
}

struct Game: Identifiable, Hashable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: URL?
    let rating: Double
    let ratingsCount: Int?
    let genres: [GameCategory]?

    var releaseDateText: String {
        guard let released, let date = Self.dateParser.date(from: released) else {
            return "To be announced"
        }
        return date.formatted(.dateTime.day().month(.abbreviated).year().locale(Locale(identifier: "en_US")))
    }

    var genreText: String {
        genres?.map(\.name).joined(separator: " · ") ?? "Game"
    }

    private static let dateParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

}

struct GameCategory: Identifiable, Hashable {
    let id: Int
    let name: String
}

struct GameDetail {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let backgroundImage: URL?
    let released: String?
    let rating: Double
    let metacritic: Int?
    let playtime: Int?
    let genres: [GameCategory]?
    let developers: [GameCategory]?
    let publishers: [GameCategory]?
    let platforms: [GamePlatform]?
    let website: String?

    var websiteURL: URL? {
        guard let website, let url = URL(string: website),
              ["https", "http"].contains(url.scheme?.lowercased() ?? "") else {
            return nil
        }
        return url
    }

}

struct GamePlatform {
    let platform: GameCategory
}

struct GameScreenshot: Identifiable {
    let id: Int
    let image: URL
}
