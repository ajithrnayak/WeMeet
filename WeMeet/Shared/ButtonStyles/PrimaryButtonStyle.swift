//
//  PrimaryButtonStyle.swift
//  WeMeet
//
//  Created by Ajith Renjala on 02/08/23.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout)
            .fontWeight(.bold)
            .fixedSize()
            .padding(.horizontal, Spacing.standard.value)
            .padding(.vertical, Spacing.full.value)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.default))
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
