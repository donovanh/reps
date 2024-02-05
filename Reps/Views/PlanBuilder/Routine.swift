//
//  Routines.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation
import SwiftData

@Model
final class Routine: Identifiable {
    
    let id: String
    let day: Int
    var exercises: [Exercise]
    
    init(day: Int, exercises: [Exercise]) {
        self.id = UUID().uuidString
        self.day = day
        self.exercises = exercises
    }
}

func getRoutine(forDay day: Int, fromRoutines routines: [Routine]) -> Routine {
    return routines.first { $0.day == day } ?? Routine(day: day, exercises: [])
}

func makeExampleRoutineForToday(numberOfExercises: Int) -> Routine {
    let currentDate = Date()
    let calendar = Calendar.current
    let dayNum = calendar.component(.weekday, from: currentDate)

    // Create an array to hold the exercises
    var exercises: [Exercise] = []

    // Create the specified number of exercises, cycling through the exercise types
    for i in 0..<min(numberOfExercises, ExerciseType.allCases.count) {
        exercises.append(Exercise(id: UUID(), type: ExerciseType.allCases[i]))
    }

    let exampleRoutine = Routine(day: dayNum, exercises: exercises)
    return exampleRoutine
}
