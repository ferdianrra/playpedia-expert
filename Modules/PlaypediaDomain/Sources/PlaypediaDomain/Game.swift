//
//  Game.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation

public struct GamePage {
    public let next: URL?
    public let results: [Game]

    public init(
        next: URL?,
        results: [Game]
    ) {
        self.next = next
        self.results = results
    }
}

public struct Game: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let released: String?
    public let backgroundImage: URL?
    public let rating: Double
    public let ratingsCount: Int?
    public let genres: [GameCategory]?

    public init(
        id: Int,
        name: String,
        released: String?,
        backgroundImage: URL?,
        rating: Double,
        ratingsCount: Int?,
        genres: [GameCategory]?
    ) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingsCount = ratingsCount
        self.genres = genres
    }

    public var releaseDateText: String {
        guard let released, let date = Self.dateParser.date(from: released) else {
            return "To be announced"
        }
        return date.formatted(.dateTime.day().month(.abbreviated).year().locale(Locale(identifier: "en_US")))
    }

    public var genreText: String {
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

public struct GameCategory: Identifiable, Hashable {
    public let id: Int
    public let name: String

    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

public struct GameDetail {
    public let id: Int
    public let name: String
    public let descriptionRaw: String?
    public let backgroundImage: URL?
    public let released: String?
    public let rating: Double
    public let metacritic: Int?
    public let playtime: Int?
    public let genres: [GameCategory]?
    public let developers: [GameCategory]?
    public let publishers: [GameCategory]?
    public let platforms: [GamePlatform]?
    public let website: String?

    public init(
        id: Int,
        name: String,
        descriptionRaw: String?,
        backgroundImage: URL?,
        released: String?,
        rating: Double,
        metacritic: Int?,
        playtime: Int?,
        genres: [GameCategory]?,
        developers: [GameCategory]?,
        publishers: [GameCategory]?,
        platforms: [GamePlatform]?,
        website: String?
    ) {
        self.id = id
        self.name = name
        self.descriptionRaw = descriptionRaw
        self.backgroundImage = backgroundImage
        self.released = released
        self.rating = rating
        self.metacritic = metacritic
        self.playtime = playtime
        self.genres = genres
        self.developers = developers
        self.publishers = publishers
        self.platforms = platforms
        self.website = website
    }

    public var websiteURL: URL? {
        guard let website, let url = URL(string: website),
              ["https", "http"].contains(url.scheme?.lowercased() ?? "") else {
            return nil
        }
        return url
    }

}

public struct GamePlatform {
    public let platform: GameCategory

    public init(
        platform: GameCategory
    ) {
        self.platform = platform
    }
}

public struct GameScreenshot: Identifiable {
    public let id: Int
    public let image: URL

    public init(
        id: Int,
        image: URL
    ) {
        self.id = id
        self.image = image
    }
}
