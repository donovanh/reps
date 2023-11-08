//
//  DataController.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/11/2023.
//

import Foundation
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: User.self, JournalEntry.self, Routine.self, WorkoutsByDay.self, configurations: config, config, config)

            // Set up JournalExamples to set journal entries for today, today minus x days, etc
            let exampleJournalEntry = JournalEntry(
                date: Date(),
                exerciseType: "pushup",
                stage: 4,
                level: Level.intermediate,
                reps: 30
            )
            
            // Set up WorkoutsByDay similar to align with journal entries for completed / in-progress exercises
            let exampleWorkoutsByDayEntry = WorkoutsByDay(date: getCurrentDate(), workout: [ExerciseType.pushup: WorkoutCompleteStatus.complete])
            
            container.mainContext.insert(DefaultUser)
            container.mainContext.insert(exampleJournalEntry)
            container.mainContext.insert(exampleWorkoutsByDayEntry)
            
            let exampleRoutines = Routine.generateExampleRoutines()
            exampleRoutines.forEach { exampleRoutine in
                container.mainContext.insert(exampleRoutine)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
