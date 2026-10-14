// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaComposition
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaComposition",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaComposition", type: .dynamic, targets: ["PlaypediaComposition"])],
    dependencies: [
        .package(
            url: "https://github.com/ferdianrra/playpedia-domain.git",
            revision: "e2d0be81278e9ba61cc58e8247d43981d63e0fea"
        ),
        .package(path: "../PlaypediaData"),
        .package(path: "../PlaypediaFavoritesState"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.12.2"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1")
    ],
    targets: [
        .target(name: "PlaypediaComposition", dependencies: [
            .product(name: "PlaypediaDomain", package: "playpedia-domain"),
            .product(name: "PlaypediaData", package: "PlaypediaData"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState"),
            .product(name: "AlamofireDynamic", package: "Alamofire"),
            .product(name: "Swinject", package: "Swinject")
        ])
    ]
)
