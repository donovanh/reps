//
//  LevelStrings.swift
//  Reps
//
//  Created by Donovan Hutchinson on 03/02/2024.
//

import Foundation

extension Level {
    var localizedStringResource: LocalizedStringResource {
        switch self {
            case .beginner:
                return "Beginner"
            case .intermediate:
                return "Intermediate"
            case .progression:
                return "Progression"
        }
    }
}
