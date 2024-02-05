//
//  ExerciseTypeStrings.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/08/2023.
//

import Foundation

extension ExerciseType {
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .pushup:
            return "Push-ups"
        case .pullup:
            return "Pull-ups"
        case .squat:
            return "Squats"
        case .bridge:
            return "Bridges"
        case .legraise:
            return "Leg Raises"
        case .handstandpushup:
            return "Handstand Push-ups"
        }
    }
}
