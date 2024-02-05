//
//  WorkoutsByDay.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import Foundation
import SwiftUI

// TODO: Maybe WorkoutsByDay really?

@Observable
final class ExerciseTypesByDay {
    let day: Int
    
    private let storageKey = "ExerciseTypesByDay"
    
    var exerciseTypesByDay: [Int: [ExerciseType]] = [:] {
        didSet {
            if let encoded = try? JSONEncoder().encode(exerciseTypesByDay) {
                UserDefaults.standard.set(encoded, forKey: storageKey)
            }
        }
    }
    
    init(day: Int) {
        self.day = day
        if let savedWorkouts = UserDefaults.standard.data(forKey: storageKey) {
            if let decodedItems = try? JSONDecoder().decode([Int: [ExerciseType]].self, from: savedWorkouts) {
                self.exerciseTypesByDay = decodedItems
                return
            }
        }

        self.exerciseTypesByDay = [:]
    }
    
    var exerciseTypes: [ExerciseType] {
        self.exerciseTypesByDay[day] ?? []
    }
    
    func addExerciseType(type: ExerciseType) {
        withAnimation {
            var currentDayExerciseTypes = exerciseTypes
            currentDayExerciseTypes.append(type)
            self.exerciseTypesByDay[day] = currentDayExerciseTypes
        }
    }
    
    func moveExercise(fromOffsets: IndexSet, toOffset: Int) {
        withAnimation {
            var currentDayExerciseTypes = exerciseTypes
            currentDayExerciseTypes.move(fromOffsets: fromOffsets, toOffset: toOffset)
            self.exerciseTypesByDay[day] = currentDayExerciseTypes
        }
    }
    
    func removeExerciseType(at offsets: IndexSet) {
        withAnimation {
            var currentDayExerciseTypes = exerciseTypes
            for offset in offsets {
                currentDayExerciseTypes.remove(at: offset)
            }
            self.exerciseTypesByDay[day] = currentDayExerciseTypes
        }
    }
}
