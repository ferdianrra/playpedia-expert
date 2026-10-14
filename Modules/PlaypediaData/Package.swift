// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaData
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaData",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaData", type: .dynamic, targets: ["PlaypediaData"])],
    dependencies: [
        .package(
            url: "https://github.com/ferdianrra/playpedia-domain.git",
            revision: "e2d0be81278e9ba61cc58e8247d43981d63e0fea"
        ),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.12.2")
    ],
    targets: [
        .target(name: "PlaypediaData", dependencies: [
            .product(name: "PlaypediaDomain", package: "playpedia-domain"),
            .product(name: "AlamofireDynamic", package: "Alamofire")
        ])
    ]
)
