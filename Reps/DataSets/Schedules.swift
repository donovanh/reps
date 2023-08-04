//
//  Schedules.swift
//  Reps
//
//  Created by Donovan Hutchinson on 31/07/2023.
//

import Foundation

let schedules: [Schedule: [DayOfWeek: [ExerciseType]]] = [
    .defaultSchedule: [
        .monday: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        .tuesday: [],
        .wednesday: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        .thursday: [],
        .friday: [.pushup, .pullup, .squat, .bridge, .legraise, .handstandpushup],
        .saturday: [],
        .sunday: []
    ],
    .intermediateSchedule: [
        .monday: [.pushup, .squat, .legraise, .handstandpushup],
        .tuesday: [.pullup, .bridge, .legraise],
        .wednesday: [],
        .thursday: [.pushup, .squat, .legraise, .handstandpushup],
        .friday: [.pullup, .bridge, .legraise],
        .saturday: [],
        .sunday: []
    ],
    .advancedPushPullSchedule: [
        .monday: [.pushup, .squat, .legraise, .handstandpushup],
        .tuesday: [.pullup, .bridge, .legraise],
        .wednesday: [.pushup, .squat, .legraise, .handstandpushup],
        .thursday: [.pullup, .bridge, .legraise],
        .friday: [.pushup, .squat, .legraise, .handstandpushup],
        .saturday: [.pullup, .bridge, .legraise],
        .sunday: []
    ],
    .advancedUpperLowerSchedule: [
        .monday: [.pushup, .pullup, .handstandpushup],
        .tuesday: [.squat, .bridge, .legraise],
        .wednesday: [.pushup, .pullup, .handstandpushup],
        .thursday: [.squat, .bridge, .legraise],
        .friday: [.pushup, .pullup, .handstandpushup],
        .saturday: [.squat, .bridge, .legraise],
        .sunday: []
    ]
]

let defaultSchedule: [DayOfWeek: [ExerciseType]] = [
    .monday: [.pushup, .pullup, .squat, .bridge, .legraise],
    .tuesday: [],
    .wednesday: [.pushup, .pullup, .squat, .bridge, .legraise],
    .thursday: [],
    .friday: [.pushup, .pullup, .squat, .bridge, .legraise],
    .saturday: [],
    .sunday: []
]

let intermediateSchedule: [DayOfWeek: [ExerciseType]] = [
    .monday: [.pushup, .squat, .legraise, .handstandpushup],
    .tuesday: [.pullup, .bridge, .legraise],
    .wednesday: [],
    .thursday: [.pushup, .squat, .legraise, .handstandpushup],
    .friday: [.pullup, .bridge, .legraise],
    .saturday: [],
    .sunday: []
]

let advancedPushPullSchedule: [DayOfWeek: [ExerciseType]] = [
    .monday: [.pushup, .squat, .legraise, .handstandpushup],
    .tuesday: [.pullup, .bridge, .legraise],
    .wednesday: [.pushup, .squat, .legraise, .handstandpushup],
    .thursday: [.pullup, .bridge, .legraise],
    .friday: [.pushup, .squat, .legraise, .handstandpushup],
    .saturday: [.pullup, .bridge, .legraise],
    .sunday: []
]

let advancedUpperLowerSchedule: [DayOfWeek: [ExerciseType]] = [
    .monday: [.pushup, .pullup, .handstandpushup],
    .tuesday: [.squat, .bridge, .legraise],
    .wednesday: [.pushup, .pullup, .handstandpushup],
    .thursday: [.squat, .bridge, .legraise],
    .friday: [.pushup, .pullup, .handstandpushup],
    .saturday: [.squat, .bridge, .legraise],
    .sunday: []
]
