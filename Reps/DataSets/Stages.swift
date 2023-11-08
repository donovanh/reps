//
//  Levels.swift
//  Reps
//
//  Created by Donovan Hutchinson on 02/08/2023.
//

import Foundation

let stages: [ExperienceLevel: [ExerciseType: Int]] = [
    .gettingStarted: [
        .pushup: 0,
        .pullup: 0,
        .squat: 0,
        .bridge: 0,
        .legraise: 0
    ],
    .intermediate: [
        .pushup: 4,
        .pullup: 4,
        .squat: 4,
        .bridge: 2,
        .legraise: 2,
        .handstandpushup: 0
    ],
    .advanced: [
        .pushup: 5,
        .pullup: 5,
        .squat: 5,
        .bridge: 4,
        .legraise: 4,
        .handstandpushup: 2
    ]
]
