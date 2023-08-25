//
//  Levels.swift
//  Reps
//
//  Created by Donovan Hutchinson on 02/08/2023.
//

import Foundation

let stages: [ExperienceLevel: [ExerciseType: Int]] = [
    .gettingStarted: [
        .pushup: 1,
        .pullup: 1,
        .squat: 1,
        .bridge: 1,
        .legraise: 1
    ],
    .intermediate: [
        .pushup: 5,
        .pullup: 5,
        .squat: 5,
        .bridge: 3,
        .legraise: 3,
        .handstandpushup: 1
    ],
    .advanced: [
        .pushup: 6,
        .pullup: 6,
        .squat: 6,
        .bridge: 5,
        .legraise: 5,
        .handstandpushup: 3
    ]
]
