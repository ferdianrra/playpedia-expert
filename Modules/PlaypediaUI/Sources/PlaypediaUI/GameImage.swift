//
//  GameImage.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

#if os(iOS)
import SwiftUI

public struct GameImage: View {
    let url: URL?

    public init(url: URL?) { self.url = url }

    public var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholder(symbol: "photo")
                case .empty:
                    if url == nil {
                        placeholder(symbol: "gamecontroller")
                    } else {
                        ZStack {
                            Color.cardBackground
                            ProgressView().tint(Color.accent)
                        }
                    }
                @unknown default:
                    placeholder(symbol: "photo")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
        .accessibilityHidden(true)
    }

    private func placeholder(symbol: String) -> some View {
        ZStack {
            Color.cardBackground
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.textSecondary)
        }
    }
}
#endif
