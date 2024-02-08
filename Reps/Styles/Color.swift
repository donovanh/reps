//
//  Colors.swift
//  Reps
//
//  Created by Donovan Hutchinson on 05/02/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let themeColor = Color.teal
    static let themeContrastColor = Color.orange
    static let lightBg = themeColor.opacity(0.15).gradient
    static let lightAnimationBg = Color.white
    static let secondaryButtonBg = themeColor.gradient
}
