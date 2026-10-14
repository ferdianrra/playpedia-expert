//
//  GameDTO.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import Foundation

struct GamePageDTO: Decodable, Sendable {
    let next: URL?
    let results: [GameDTO]
}

struct GameDTO: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: URL?
    let rating: Double
    let ratingsCount: Int?
    let genres: [GameCategoryDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, genres
        case backgroundImage = "background_image"
        case ratingsCount = "ratings_count"
    }
}

struct GameCategoryDTO: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
}

struct GameDetailDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let backgroundImage: URL?
    let released: String?
    let rating: Double
    let metacritic: Int?
    let playtime: Int?
    let genres: [GameCategoryDTO]?
    let developers: [GameCategoryDTO]?
    let publishers: [GameCategoryDTO]?
    let platforms: [GamePlatformDTO]?
    let website: String?

    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, metacritic, playtime, genres
        case developers, publishers, platforms, website
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
    }
}

struct GamePlatformDTO: Decodable, Sendable {
    let platform: GameCategoryDTO
}

struct ScreenshotPageDTO: Decodable, Sendable {
    let results: [GameScreenshotDTO]
}

struct GameScreenshotDTO: Decodable, Identifiable, Sendable {
    let id: Int
    let image: URL
}
