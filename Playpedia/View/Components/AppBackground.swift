//
//  AppBackground.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color.ambientGlow, Color.appBackground, Color.appBackground],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}
