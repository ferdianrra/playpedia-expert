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
        .package(path: "../PlaypediaDomain")
    ],
    targets: [
        .target(name: "PlaypediaFavoritesState", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain")
        ])
    ]
)
