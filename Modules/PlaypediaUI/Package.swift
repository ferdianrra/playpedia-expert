// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaUI
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaUI",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaUI", type: .dynamic, targets: ["PlaypediaUI"])],
    dependencies: [
        .package(
            url: "https://github.com/ferdianrra/playpedia-domain.git",
            revision: "e2d0be81278e9ba61cc58e8247d43981d63e0fea"
        )
    ],
    targets: [
        .target(name: "PlaypediaUI", dependencies: [
            .product(name: "PlaypediaDomain", package: "playpedia-domain")
        ], resources: [.process("Resources")])
    ]
)
