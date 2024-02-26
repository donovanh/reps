//
//  WorkoutsByDay.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import Foundation
import SwiftUI

final class WorkoutSchedule {
    private let storageKey = "ExerciseTypesByDay"
    
    var exerciseTypesByDay: [Int: [ExerciseType]] = [:] {
        didSet {
            if let encoded = try? JSONEncoder().encode(exerciseTypesByDay) {
                UserDefaults.standard.set(encoded, forKey: storageKey)
            }
        }
    }
    
    init() {
        if let savedWorkouts = UserDefaults.standard.data(forKey: storageKey) {
            if let decodedItems = try? JSONDecoder().decode([Int: [ExerciseType]].self, from: savedWorkouts) {
                self.exerciseTypesByDay = decodedItems
                return
            }
        }

        self.exerciseTypesByDay = [:]
    }
    
    func exerciseTypes(forDay day: Int) -> [ExerciseType] {
        self.exerciseTypesByDay[day] ?? []
    }
}
