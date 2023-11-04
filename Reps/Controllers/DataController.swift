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
            let container = try ModelContainer(for: User.self, JournalEntry.self, Routine.self, configurations: config, config, config)

            let exampleJournalEntry = JournalEntry(
                date: Date(),
                exerciseType: "pushup",
                stage: 1,
                reps: 8000
            )
            let exampleRoutine = makeExampleRoutineForToday(numberOfExercises: 6)

            container.mainContext.insert(DefaultUser)
            container.mainContext.insert(exampleJournalEntry)
            container.mainContext.insert(exampleRoutine)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
