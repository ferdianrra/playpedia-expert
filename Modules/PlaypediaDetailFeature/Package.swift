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
        .package(path: "../PlaypediaDomain"),
        .package(path: "../PlaypediaUI"),
        .package(path: "../PlaypediaFavoritesState")
    ],
    targets: [
        .target(name: "PlaypediaDetailFeature", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain"),
            .product(name: "PlaypediaUI", package: "PlaypediaUI"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState")
        ])
    ]
)
