// swift-tools-version: 5.9
//
//  Package.swift
//  PlaypediaDomain
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaDomain",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "PlaypediaDomain", type: .dynamic, targets: ["PlaypediaDomain"])],
    targets: [.target(name: "PlaypediaDomain")]
)
