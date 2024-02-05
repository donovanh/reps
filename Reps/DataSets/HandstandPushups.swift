//
//  HandstandPushups.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

let handstandpushupsDataSet: [Progression] = [
    Progression(stage: 0, type: .handstandpushup, name: .wallHeadstands, reps: [
        .beginner: 30,
        .intermediate: 60,
        .progression: 120
    ], sets: [
        .beginner: 1,
        .intermediate: 1,
        .progression: 1
    ], showSecondsForReps: true, animationFileName: "hspu--01"),
    Progression(stage: 1, type: .handstandpushup, name: .crow, reps: [
        .beginner: 10,
        .intermediate: 30,
        .progression: 60
    ], sets: [
        .beginner: 1,
        .intermediate: 1,
        .progression: 1
    ], showSecondsForReps: true, animationFileName: "hspu--02"),
    Progression(stage: 2, type: .handstandpushup, name: .wallHandstands, reps: [
        .beginner: 30,
        .intermediate: 60,
        .progression: 120
    ], sets: [
        .beginner: 1,
        .intermediate: 1,
        .progression: 1
    ], showSecondsForReps: true, animationFileName: "hspu--03"),
    Progression(stage: 3, type: .handstandpushup, name: .halfHandstandPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "hspu--04"),
    Progression(stage: 4, type: .handstandpushup, name: .handstandPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 15
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "hspu--05"),
    Progression(stage: 5, type: .handstandpushup, name: .closeHandstandPushups, reps: [
        .beginner: 5,
        .intermediate: 9,
        .progression: 12
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "hspu--06"),
    Progression(stage: 6, type: .handstandpushup, name: .unevenHandstandPushups, reps: [
        .beginner: 5,
        .intermediate: 8,
        .progression: 10
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "hspu--07"),
    Progression(stage: 7, type: .handstandpushup, name: .halfOneArmHandstandPushups, reps: [
        .beginner: 4,
        .intermediate: 6,
        .progression: 8
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "hspu--08"),
    Progression(stage: 8, type: .handstandpushup, name: .leverHandstandPushups, reps: [
        .beginner: 3,
        .intermediate: 4,
        .progression: 6
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "hspu--09"),
    Progression(stage: 9, type: .handstandpushup, name: .oneArmHandstandPushups, reps: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 5
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 1
    ], showForEachSide: true, animationFileName: "hspu--10"),
]
