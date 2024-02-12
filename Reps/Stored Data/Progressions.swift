//
//  Progressions.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/02/2024.
//

import Foundation

struct Progressions {
    func getProgression(ofType type: ExerciseType, atStage stage: Int) -> Progression? {
        return getProgressions(ofType: type).first { $0.stage == stage }
    }

    func getProgressions(ofType type: ExerciseType) -> [Progression] {

        guard let exercises = getAllProgressions()[type] else {
            print("Exercise missing for type: \(type)")
            return []
        }

        return exercises
    }

    func getAllProgressions() -> [ExerciseType: [Progression]] {
        let allExercises: [ExerciseType: [Progression]] = [
            .pushup: pushupDataSet,
            .pullup: pullupDataSet,
            .squat: squatDataSet,
            .bridge: bridgeDataSet,
            .legraise: legRaisesDataSet,
            .handstandpushup: handstandpushupsDataSet
        ]
        
        return allExercises
    }
}
