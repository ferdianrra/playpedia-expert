// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaFavoritesFeature
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaFavoritesFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaFavoritesFeature", type: .dynamic, targets: ["PlaypediaFavoritesFeature"])],
    dependencies: [
        .package(path: "../PlaypediaDomain"),
        .package(path: "../PlaypediaUI"),
        .package(path: "../PlaypediaDetailFeature"),
        .package(path: "../PlaypediaFavoritesState")
    ],
    targets: [
        .target(name: "PlaypediaFavoritesFeature", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain"),
            .product(name: "PlaypediaUI", package: "PlaypediaUI"),
            .product(name: "PlaypediaDetailFeature", package: "PlaypediaDetailFeature"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState")
        ])
    ]
)
