//
//  Colors.swift
//  Reps
//
//  Created by Donovan Hutchinson on 05/02/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let themeColor = Color(red: 1, green: 0.4, blue: 0.2)
    static let lightBg = Color(red: 0.8, green: 0.9, blue: 1).gradient
    static let darkBg = Color(red: 0, green: 0.05, blue: 0.15).gradient
    static let lightAnimationBg = Color.white
    static let darkAnimationBg = Color.white.opacity(0.05)
    static let secondaryButtonBg = themeColor.gradient
}
