//
//  ThemeColors.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 14/10/26.
//

#if os(iOS)
import SwiftUI

public extension Color {
    static let accent = Color("AccentColor", bundle: .module)
    static let ambientGlow = Color("AmbientGlow", bundle: .module)
    static let appBackground = Color("AppBackground", bundle: .module)
    static let artworkOverlay = Color("ArtworkOverlay", bundle: .module)
    static let cardBackground = Color("CardBackground", bundle: .module)
    static let rating = Color("RatingColor", bundle: .module)
    static let textPrimary = Color("TextPrimary", bundle: .module)
    static let textSecondary = Color("TextSecondary", bundle: .module)
}
#endif
