// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaDetailFeature
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaDetailFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaDetailFeature", type: .dynamic, targets: ["PlaypediaDetailFeature"])],
    dependencies: [
        .package(
            url: "https://github.com/ferdianrra/playpedia-domain.git",
            revision: "e2d0be81278e9ba61cc58e8247d43981d63e0fea"
        ),
        .package(path: "../PlaypediaUI"),
        .package(path: "../PlaypediaFavoritesState")
    ],
    targets: [
        .target(name: "PlaypediaDetailFeature", dependencies: [
            .product(name: "PlaypediaDomain", package: "playpedia-domain"),
            .product(name: "PlaypediaUI", package: "PlaypediaUI"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState")
        ])
    ]
)
