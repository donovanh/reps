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
            .font(.title2)
            .padding(.horizontal, 20)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerSize: CGSize(width: 20, height: 20)))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
