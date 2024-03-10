//
//  Colors.swift
//  Reps
//
//  Created by Donovan Hutchinson on 05/02/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let themeColor = Color(red: 0.5, green: 0.85, blue: 0.5)
    static let lightBg = LinearGradient(
        gradient: Gradient(colors: [.black, Color(red: 0, green: 0.05, blue: 0.15)]),
        startPoint: .top,
        endPoint: .bottom
    )
    static let darkBg = LinearGradient(
        gradient: Gradient(colors: [.black, Color(red: 0, green: 0.05, blue: 0.15)]),
        startPoint: .top,
        endPoint: .bottom
    ) //Color(red: 0, green: 0.05, blue: 0.15)
    static let lightAnimationBg = Color.white
    static let darkAnimationBg = Color.white.opacity(0.10)
    static let secondaryButtonBg = themeColor.gradient
}
