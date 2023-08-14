//
//  DifficultyTypeStrings.swift
//  Reps
//
//  Created by Donovan Hutchinson on 14/08/2023.
//

import Foundation
import SwiftUI

extension Difficulty {
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .easy:
            return "Easy"
        case .moderate:
            return "Moderate"
        case .difficult:
            return "Difficult"
        }
    }
}
