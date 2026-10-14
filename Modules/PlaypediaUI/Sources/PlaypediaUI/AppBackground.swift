//
//  AppBackground.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

#if os(iOS)
import SwiftUI

public struct AppBackground: View {

    public init() {}
    public var body: some View {
        LinearGradient(
            colors: [Color.ambientGlow, Color.appBackground, Color.appBackground],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
}
#endif
