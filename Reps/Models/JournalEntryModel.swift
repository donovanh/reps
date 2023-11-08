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
    
    let id: UUID
    let date: Date
    let exerciseType: String
    let stage: Int
    let level: Level
    let reps: Int
    
    init(
        date: Date,
        exerciseType: String,
        stage: Int,
        level: Level,
        reps: Int
    ) {
        self.id = UUID()
        self.date = date
        self.exerciseType = exerciseType
        self.stage = stage
        self.level = level
        self.reps = reps
    }
}

func getJournalEntries(entries: [JournalEntry], forDate date: Date) -> [JournalEntry] {
    return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
}

func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType) -> [JournalEntry] {
    return entries.filter { entry in
        return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType.rawValue
    }
}

func getSetsDone(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType) -> Int {
    let entries = getJournalEntries(entries: entries, forDate: date, ofType: exerciseType)
    return entries.count
}

func getLatestRecordedReps(entries: [JournalEntry], forType exerciseType: ExerciseType) -> Int {
    let entriesOfType = entries.filter { entry in
        entry.exerciseType == exerciseType.rawValue
    }
    
    if let latestEntry = entriesOfType.last {
        return latestEntry.reps
    }
    
    return 0
}
