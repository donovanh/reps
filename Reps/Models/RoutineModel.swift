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
