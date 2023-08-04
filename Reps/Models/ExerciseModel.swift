//
//  Exercises.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

struct Exercise: Identifiable, Hashable, Codable {
    let id: UUID
    let type: String
}

enum ExerciseType: String, CaseIterable, Codable {
    case pushup = "Push-ups"
    case pullup = "Pull-ups"
    case squat = "Squats"
    case bridge = "Bridges"
    case legraise = "Leg Raises"
    case handstandpushup = "Handstand Push-ups"
}

struct Progression: Hashable {
    let stage: Int
    let type: ExerciseType
    let name: String
    let reps: [Level: Int]
    let sets: [Level: Int]
    var showSecondsForReps: Bool?
    
    func getReps(for level: Level) -> Int {
        return reps[level] ?? 0
    }
    
    func getSets(for level: Level) -> Int {
        return sets[level] ?? 0
    }
}

enum Level: String, CaseIterable, Codable {
    case beginner, intermediate, progression
    
    init?(fromString string: String) {
        self = Level.allCases.first { $0.rawValue == string } ?? .beginner
    }
}
