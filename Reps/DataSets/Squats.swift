//
//  Squats.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

let squatDataSet: [Progression] = [
    Progression(stage: 1, type: .squat, name: .shoulderStands, reps: [
        .beginner: 10,
        .intermediate: 25,
        .progression: 50
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 2, type: .squat, name: .jackknifeSquats, reps: [
        .beginner: 10,
        .intermediate: 20,
        .progression: 40
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 3, type: .squat, name: .supportedSquats, reps: [
        .beginner: 10,
        .intermediate: 15,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 4, type: .squat, name: .halfSquats, reps: [
        .beginner: 8,
        .intermediate: 35,
        .progression: 50
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 5, type: .squat, name: .fullSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "squat-05"),
    Progression(stage: 6, type: .squat, name: .closeSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 7, type: .squat, name: .unevenSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 8, type: .squat, name: .halfOneLegSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 9, type: .squat, name: .assistedOneLegSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 10, type: .squat, name: .oneLegSquats, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 50
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
]
