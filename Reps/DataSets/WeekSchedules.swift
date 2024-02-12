//
//  Schedules.swift
//  Reps
//
//  Created by Donovan Hutchinson on 31/07/2023.
//

import Foundation

let weekSchedules: [Schedule: [Int: [ExerciseType]]] = [
    .defaultSchedule: [
        2: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        3: [],
        4: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        5: [],
        6: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        7: [],
        1: []
    ],
    .intermediateSchedule: [
        2: [.pushup, .squat, .legraise, .handstandpushup],
        3: [.pullup, .bridge, .legraise],
        4: [],
        5: [.pushup, .squat, .legraise, .handstandpushup],
        6: [.pullup, .bridge, .legraise],
        7: [],
        1: []
    ],
    .advancedPushPullSchedule: [
        2: [.pushup, .squat, .legraise, .handstandpushup],
        3: [.pullup, .bridge, .legraise],
        4: [.pushup, .squat, .legraise, .handstandpushup],
        5: [.pullup, .bridge, .legraise],
        6: [.pushup, .squat, .legraise, .handstandpushup],
        7: [.pullup, .bridge, .legraise],
        1: []
    ],
    .advancedUpperLowerSchedule: [
        2: [.pushup, .pullup, .handstandpushup],
        3: [.squat, .bridge, .legraise],
        4: [.pushup, .pullup, .handstandpushup],
        5: [.squat, .bridge, .legraise],
        6: [.pushup, .pullup, .handstandpushup],
        7: [.squat, .bridge, .legraise],
        1: []
    ]
]
