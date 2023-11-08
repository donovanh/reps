//
//  Pushups.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

let pushupDataSet: [Progression] = [
    Progression(stage: 0, type: .pushup, name: .wallPushups, reps: [
        .beginner: 10,
        .intermediate: 25,
        .progression: 50
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "pushup-01"),
    Progression(stage: 1, type: .pushup, name: .inclinePushups, reps: [
        .beginner: 10,
        .intermediate: 20,
        .progression: 40
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "pushup-02"),
    Progression(stage: 2, type: .pushup, name: .kneelingPushups, reps: [
        .beginner: 10,
        .intermediate: 15,
        .progression: 30
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 3
    ], animationFileName: "pushup-03"),
    Progression(stage: 3, type: .pushup, name: .halfPushups, reps: [
        .beginner: 8,
        .intermediate: 12,
        .progression: 25
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "pushup-04"),
    Progression(stage: 4, type: .pushup, name: .fullPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "pushup-05"),
    Progression(stage: 5, type: .pushup, name: .closePushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], animationFileName: "pushup-06"),
    Progression(stage: 6, type: .pushup, name: .unevenPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "pushup-07"),
    Progression(stage: 7, type: .pushup, name: .halfOneArmPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "pushup-08"),
    Progression(stage: 8, type: .pushup, name: .leverPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 20
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 2
    ], showForEachSide: true, animationFileName: "pushup-09"),
    Progression(stage: 9, type: .pushup, name: .oneArmPushups, reps: [
        .beginner: 5,
        .intermediate: 10,
        .progression: 100
    ], sets: [
        .beginner: 1,
        .intermediate: 2,
        .progression: 1
    ], showForEachSide: true, animationFileName: "pushup-10"),
]
