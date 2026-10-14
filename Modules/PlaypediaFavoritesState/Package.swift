// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaFavoritesState
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaFavoritesState",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaFavoritesState", type: .dynamic, targets: ["PlaypediaFavoritesState"])],
    dependencies: [
        .package(
            url: "https://github.com/ferdianrra/playpedia-domain.git",
            revision: "e2d0be81278e9ba61cc58e8247d43981d63e0fea"
        )
    ],
    targets: [
        .target(name: "PlaypediaFavoritesState", dependencies: [
            .product(name: "PlaypediaDomain", package: "playpedia-domain")
        ])
    ]
)
