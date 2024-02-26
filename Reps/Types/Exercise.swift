//
//  Exercises.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

struct Exercise: Identifiable, Hashable, Codable {
    let id: UUID
    let type: ExerciseType
}

enum ExerciseType: String, CaseIterable, Codable, Comparable {
    case pushup, pullup, squat, bridge, legraise, handstandpushup
    
    static func < (lhs: ExerciseType, rhs: ExerciseType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
