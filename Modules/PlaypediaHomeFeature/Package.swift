// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaHomeFeature
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaHomeFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaHomeFeature", type: .dynamic, targets: ["PlaypediaHomeFeature"])],
    dependencies: [
        .package(path: "../PlaypediaDomain"),
        .package(path: "../PlaypediaUI"),
        .package(path: "../PlaypediaDetailFeature"),
        .package(path: "../PlaypediaFavoritesState")
    ],
    targets: [
        .target(name: "PlaypediaHomeFeature", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain"),
            .product(name: "PlaypediaUI", package: "PlaypediaUI"),
            .product(name: "PlaypediaDetailFeature", package: "PlaypediaDetailFeature"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState")
        ])
    ]
)
