//
//  JournalEntryModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/08/2023.
//

import Foundation
import SwiftData

@Model
final class JournalEntry: Identifiable {

    let id: UUID = UUID()
    let date: Date = Date()
    let exerciseType: ExerciseType = ExerciseType.pushup
    let stage: Int = 0
    let level: Level = Level.beginner
    let reps: Int = 0

    init(
        date: Date = Date(),
        exerciseType: ExerciseType = .pushup,
        stage: Int = 0,
        level: Level = .beginner,
        reps: Int = 0
    ) {
        self.id = UUID()
        self.date = date
        self.exerciseType = exerciseType
        self.stage = stage
        self.level = level
        self.reps = reps
    }
}

struct journalEntryMethods {
    func getJournalEntries(entries: [JournalEntry], forDate date: Date) -> [JournalEntry] {
        return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType) -> [JournalEntry] {
        return entries.filter { entry in
            return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType
        }
    }
    
    func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType, ofStage stage: Int, ofLevel level: Level) -> [JournalEntry] {
        return entries.filter { entry in
            return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType && entry.stage == stage && entry.level == level
        }
    }

    func getSetsDone(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType, ofStage stage: Int, ofLevel level: Level) -> Int {
        let entries = getJournalEntries(entries: entries, forDate: date, ofType: exerciseType, ofStage: stage, ofLevel: level)
        return entries.count
    }

    func getLatestRecordedReps(entries: [JournalEntry], forType exerciseType: ExerciseType) -> Int {
        let entriesOfType = entries.filter { entry in
            entry.exerciseType == exerciseType
        }
        
        if let latestEntry = entriesOfType.last {
            return latestEntry.reps
        }
        
        return 0
    }
}

