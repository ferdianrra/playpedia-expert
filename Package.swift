// swift-tools-version: 5.9
//
//  Package.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaModules",
    platforms: [.iOS(.v17), .macOS(.v14)],
    dependencies: [
        .package(path: "Modules/PlaypediaDomain"),
        .package(path: "Modules/PlaypediaData"),
        .package(path: "Modules/PlaypediaFavoritesState"),
        .package(path: "Modules/PlaypediaHomeFeature"),
        .package(path: "Modules/PlaypediaDetailFeature"),
        .package(path: "Modules/PlaypediaComposition"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.12.2")
    ],
    targets: [
        .testTarget(name: "PlaypediaModulesTests", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain"),
            .product(name: "PlaypediaData", package: "PlaypediaData"),
            .product(name: "PlaypediaHomeFeature", package: "PlaypediaHomeFeature"),
            .product(name: "PlaypediaDetailFeature", package: "PlaypediaDetailFeature"),
            .product(name: "PlaypediaFavoritesState", package: "PlaypediaFavoritesState"),
            .product(name: "PlaypediaComposition", package: "PlaypediaComposition"),
            .product(name: "AlamofireDynamic", package: "Alamofire")
        ], path: "Tests")
    ]
)
