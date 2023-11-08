//
//  Bridges.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

let bridgeDataSet: [Progression] = [
    Progression(stage: 0, type: .bridge, name: .shortBridges, reps: [
        .beginner: 10,
        .intermediate: 25,
        .progression: 50
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "bridge-01"),
    Progression(stage: 1, type: .bridge, name: .straightBridges, reps: [
        .beginner: 10,
        .intermediate: 20,
        .progression: 40
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "bridge-02"),
    Progression(stage: 2, type: .bridge, name: .angledBridges, reps: [
        .beginner: 8,
        .intermediate: 15,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "bridge-03"),
    Progression(stage: 3, type: .bridge, name: .headBridges, reps: [
        .beginner: 8,
        .intermediate: 15,
        .progression: 25
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-04"),
    Progression(stage: 4, type: .bridge, name: .halfBridges, reps: [
        .beginner: 8,
        .intermediate: 15,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-05"),
    Progression(stage: 5, type: .bridge, name: .fullBridges, reps: [
        .beginner: 6,
        .intermediate: 10,
        .progression: 15
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-06"),
    Progression(stage: 6, type: .bridge, name: .wallWalkingDown, reps: [
        .beginner: 3,
        .intermediate: 6,
        .progression: 10
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-07"),
    Progression(stage: 7, type: .bridge, name: .wallWalkingUp, reps: [
        .beginner: 2,
        .intermediate: 4,
        .progression: 8
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-08"),
    Progression(stage: 8, type: .bridge, name: .closingBridges, reps: [
        .beginner: 1,
        .intermediate: 3,
        .progression: 6
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-09"),
    Progression(stage: 9, type: .bridge, name: .standToStandBridges, reps: [
        .beginner: 1,
        .intermediate: 3,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "bridge-10")
]
