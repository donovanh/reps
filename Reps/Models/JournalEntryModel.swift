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
    
    let id: String
    let date: Date
    let exerciseType: String
    let stage: Int
    let reps: Int
    let difficulty: String
    
    init(
        date: Date,
        exerciseType: String,
        stage: Int,
        reps: Int,
        difficulty: String
    ) {
        self.id = UUID().uuidString
        self.date = date
        self.exerciseType = exerciseType
        self.stage = stage
        self.reps = reps
        self.difficulty = difficulty
    }
}

func getJournalEntries(entries: [JournalEntry], forDate date: Date) -> [JournalEntry] {
    return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
}

func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: String) -> [JournalEntry] {
    return entries.filter { entry in
        return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType
    }
}

func getSetsDone(entries: [JournalEntry], forDate date: Date, ofType exerciseType: String) -> Int {
    let entries = getJournalEntries(entries: entries, forDate: date, ofType:  exerciseType)
    return entries.count
}

func getLatestRecordedReps(entries: [JournalEntry], forType exerciseType: String) -> Int {
    let entriesOfType = entries.filter { entry in
        entry.exerciseType == exerciseType
    }
    
    if let latestEntry = entriesOfType.last {
        return latestEntry.reps
    }
    
    return 0
}

func getLatestRecordedDifficulty(entries: [JournalEntry], forType exerciseType: String) -> Difficulty {
    let defaultDifficulty: Difficulty = .moderate
    let entriesOfType = entries.filter { entry in
        entry.exerciseType == exerciseType
    }
    
    if let latestEntry = entriesOfType.last {
        return Difficulty(rawValue: latestEntry.difficulty) ?? defaultDifficulty
    }
    
    return defaultDifficulty
}


enum Difficulty: String, CaseIterable {
    case easy, moderate, difficult
}
