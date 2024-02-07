//
//  PrimaryButtonStyle.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/02/2024.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .padding()
            .background(.thinMaterial)
            .background(Color.primaryButtonBg)
            .foregroundStyle(.primary)
            .clipShape(.rect(cornerSize: CGSize(width: 10, height: 10)))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
