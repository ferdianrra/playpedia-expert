//
//  StateView.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

#if os(iOS)
import SwiftUI

public struct StateView: View {
    let symbol: String
    let title: String
    let message: String
    var actionTitle = "Try again"
    var action: (() -> Void)?

    public init(symbol: String, title: String, message: String,
                actionTitle: String = "Try again", action: (() -> Void)? = nil) {
        self.symbol = symbol
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbol)
                .font(.system(size: 38))
                .foregroundStyle(Color.accent)
            Text(title).font(.title3.weight(.medium)).foregroundStyle(Color.textPrimary)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.textSecondary)
            if let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.accent)
                    .foregroundStyle(Color.appBackground)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
    }
}
#endif
