// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaAboutFeature
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaAboutFeature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaAboutFeature", type: .dynamic, targets: ["PlaypediaAboutFeature"])],
    dependencies: [
        .package(path: "../PlaypediaUI")
    ],
    targets: [
        .target(name: "PlaypediaAboutFeature", dependencies: [
            .product(name: "PlaypediaUI", package: "PlaypediaUI")
        ], resources: [.process("Resources")])
    ]
)
