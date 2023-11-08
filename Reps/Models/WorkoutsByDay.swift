//
//  WorkoutsByDay.swift
//  Reps
//
//  Created by Donovan Hutchinson on 07/11/2023.
//

import Foundation
import SwiftData

enum WorkoutCompleteStatus: String, CaseIterable, Codable {
    case inProgress
    case complete
}

@Model
final class WorkoutsByDay: Identifiable {
    
    let id: UUID
    let date: Date
    var workout: [ExerciseType: WorkoutCompleteStatus]
    
    init(date: Date, workout: [ExerciseType : WorkoutCompleteStatus]) {
        self.id = UUID()
        self.date = date
        self.workout = workout
    }
}

func getWorkout(entries: [WorkoutsByDay], forDate targetDate: Date) -> [ExerciseType: WorkoutCompleteStatus]? {
    for entry in entries {
        if (entry.date == targetDate) {
            return entry.workout
        }
    }
    return nil
}
