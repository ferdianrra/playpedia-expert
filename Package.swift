// swift-tools-version: 5.9
//
//  Package.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PackageDescription

let package = Package(
    name: "PlaypediaCore",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [.library(name: "PlaypediaCore", targets: ["PlaypediaCore"])],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.12.2"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1")
    ],
    targets: [
        .target(name: "PlaypediaCore", dependencies: [
                    .product(name: "Alamofire", package: "Alamofire"),
                    .product(name: "Swinject", package: "Swinject")
                ], path: "Playpedia",
                exclude: ["App/PlaypediaApp.swift", "View", "Assets.xcassets", "Preview"],
                sources: ["Domain", "Data", "ViewModel", "App/AppContainer.swift", "App/AppConfiguration.swift"]),
        .testTarget(name: "PlaypediaCoreTests", dependencies: ["PlaypediaCore"], path: "Tests")
    ]
)
