//
//  Pullups.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

let pullupDataSet: [Progression] = [
    Progression(stage: 1, type: .pullup, name: .verticalPullups, reps: [
        .beginner: 10,
        .intermediate: 20,
        .progression: 40
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 2, type: .pullup, name: .horizontalPullups, reps: [
        .beginner: 10,
        .intermediate: 20,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 3, type: .pullup, name: .jackknifePullups, reps: [
        .beginner: 10,
        .intermediate: 15,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ]),
    Progression(stage: 4, type: .pullup, name: .halfPullups, reps: [
        .beginner: 8,
        .intermediate: 11,
        .progression: 15
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 5, type: .pullup, name: .fullPullups, reps: [
        .beginner: 5,
        .intermediate: 8,
        .progression: 10
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 6, type: .pullup, name: .closePullups, reps: [
        .beginner: 5,
        .intermediate: 8,
        .progression: 10
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 7, type: .pullup, name: .unevenPullups, reps: [
        .beginner: 5,
        .intermediate: 7,
        .progression: 9
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 8, type: .pullup, name: .halfOneArmPullups, reps: [
        .beginner: 4,
        .intermediate: 6,
        .progression: 8
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 9, type: .pullup, name: .assistedOneArmPullups, reps: [
        .beginner: 3,
        .intermediate: 5,
        .progression: 7
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
    Progression(stage: 10, type: .pullup, name: .oneArmPullups, reps: [
        .beginner: 1,
        .intermediate: 3,
        .progression: 6
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ]),
]
