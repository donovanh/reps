//
//  RoutineExamples.swift
//  Reps
//
//  Created by Donovan Hutchinson on 05/11/2023.
//

import Foundation

extension Routine {
    static func generateExampleRoutines() -> [Routine] {
        var exampleRoutines: [Routine] = []

        for dayNum in 1...7 {
            let numberOfExercises = Int.random(in: 1...6)
            let routineForDay = makeExampleRoutineForDayNum(numberOfExercises: numberOfExercises, dayNum: dayNum)
            exampleRoutines.append(routineForDay)
        }

        return exampleRoutines
    }
}

func makeExampleRoutineForDayNum(numberOfExercises: Int, dayNum: Int) -> Routine {
    // Create an array to hold the exercises
    var exercises: [Exercise] = []

    // Create the specified number of exercises, cycling through the exercise types
    for i in 0..<min(numberOfExercises, ExerciseType.allCases.count) {
        exercises.append(Exercise(id: UUID(), type: ExerciseType.allCases[i]))
    }

    let exampleRoutine = Routine(day: dayNum, exercises: exercises)
    return exampleRoutine
}
