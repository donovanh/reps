//
//  Exercises.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

func getExercise(ofType type: String, atStage stage: Int) -> Progression? {
    return getExercises(ofType: type).first { $0.stage == stage }
}

func getExercises(ofType type: String) -> [Progression] {

    guard let exercises = getAllExercises()[type] else {
        print("Exercise missing for type: \(type)")
        return []
    }

    return exercises
}

func getAllExercises() -> [String: [Progression]] {
    let allExercises: [String: [Progression]] = [
        ExerciseType.pushup.rawValue: pushupDataSet,
        ExerciseType.pullup.rawValue: pullupDataSet,
        ExerciseType.squat.rawValue: squatDataSet,
        ExerciseType.bridge.rawValue: bridgeDataSet,
        ExerciseType.legraise.rawValue: legRaisesDataSet,
        ExerciseType.handstandpushup.rawValue: handstandpushupsDataSet
    ]
    
    return allExercises
}
