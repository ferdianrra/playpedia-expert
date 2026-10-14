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
        .package(path: "../PlaypediaDomain")
    ],
    targets: [
        .target(name: "PlaypediaUI", dependencies: [
            .product(name: "PlaypediaDomain", package: "PlaypediaDomain")
        ], resources: [.process("Resources")])
    ]
)
