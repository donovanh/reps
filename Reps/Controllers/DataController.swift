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
            let container = try ModelContainer(for: JournalEntryV2.self, configurations: config)

            // Set up JournalExamples to set journal entries for today, today minus x days, etc
//            let exampleJournalEntry = JournalEntryV2(
//                date: Date(),
//                exerciseType: "pushup",
//                stage: 4,
//                level: Level.intermediate,
//                reps: 30
//            )
//            container.mainContext.insert(exampleJournalEntry)
            
            // Make array of journal entries, for today, and yesterday
            let today = Date()
            let yesterday = Date().daysOffset(offset: -1)
            let dayBeforeYesterday = Date().daysOffset(offset: -2)
            
            let todayJournalEntries = [
                JournalEntryV2(
                    date: today,
                    exerciseType: .pushup,
                    stage: 0,
                    level: .beginner,
                    reps: 30
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .pullup,
                    stage: 4,
                    level: .intermediate,
                    reps: 30
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .bridge,
                    stage: 0,
                    level: .beginner,
                    reps: 5
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .pushup,
                    stage: 0,
                    level: .beginner,
                    reps: 25
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .pullup,
                    stage: 4,
                    level: .intermediate,
                    reps: 25
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .handstandpushup,
                    stage: 4,
                    level: .intermediate,
                    reps: 10
                ),
                JournalEntryV2(
                    date: today,
                    exerciseType: .squat,
                    stage: 0,
                    level: .beginner,
                    reps: 200
                )
            ]
            
            todayJournalEntries.forEach { entry in
                container.mainContext.insert(entry)
            }
            
            let yesterdayJournalEntries = [
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .pushup,
                    stage: 0,
                    level: .beginner,
                    reps: 25
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .pullup,
                    stage: 4,
                    level: .intermediate,
                    reps: 28
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .bridge,
                    stage: 2,
                    level: .intermediate,
                    reps: 15
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .bridge,
                    stage: 2,
                    level: .intermediate,
                    reps: 15
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .pushup,
                    stage: 0,
                    level: .beginner,
                    reps: 25
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .pullup,
                    stage: 4,
                    level: .intermediate,
                    reps: 25
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .handstandpushup,
                    stage: 4,
                    level: .intermediate,
                    reps: 10
                ),
                JournalEntryV2(
                    date: yesterday,
                    exerciseType: .handstandpushup,
                    stage: 3,
                    level: .intermediate,
                    reps: 5
                )
            ]
            
            yesterdayJournalEntries.forEach { entry in
                container.mainContext.insert(entry)
            }
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
