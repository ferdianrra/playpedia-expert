//
//  GameCard.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

#if os(iOS)
import PlaypediaDomain
import SwiftUI

public struct RatingBadge: View {
    let rating: Double

    public init(rating: Double) { self.rating = rating }

    private var ratingText: String {
        rating.formatted(.number.precision(.fractionLength(1)).locale(Locale(identifier: "en_US")))
    }

    public var body: some View {
        Label(ratingText, systemImage: "star.fill")
            .font(.caption.weight(.medium))
            .foregroundStyle(Color.rating)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color.artworkOverlay.opacity(0.8), in: Capsule())
            .accessibilityLabel("Rating \(ratingText) out of 5")
    }
}

public struct GameCard: View {
    let game: Game

    public init(game: Game) { self.game = game }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GameImage(url: game.backgroundImage)
                .frame(height: 190)
                .overlay(alignment: .topTrailing) {
                    RatingBadge(rating: game.rating).padding(12)
                }
            VStack(alignment: .leading, spacing: 9) {
                HStack(alignment: .top, spacing: 12) {
                    Text(game.name)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "arrow.up.right")
                        .font(.callout)
                        .foregroundStyle(Color.textSecondary)
                }
                Text(game.genreText)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                Label(game.releaseDateText, systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(Color.textSecondary.opacity(0.12))
        }
        .contentShape(RoundedRectangle(cornerRadius: 22))
    }
}
#endif
