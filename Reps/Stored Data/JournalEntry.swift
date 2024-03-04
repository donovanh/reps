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

extension JournalEntry {

    static func getJournalEntries(entries: [JournalEntry], forDate date: Date) -> [JournalEntry] {
        return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    static func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType) -> [JournalEntry] {
        return entries.filter { entry in
            return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType
        }
    }
    
    static func getJournalEntries(entries: [JournalEntry], ofType exerciseType: ExerciseType, ofStage stage: Int, ofLevel level: Level) -> [JournalEntry] {
        return entries.filter { entry in
            return entry.exerciseType == exerciseType && entry.stage == stage && entry.level == level
        }
    }
    
    static func getJournalEntries(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType, ofStage stage: Int, ofLevel level: Level) -> [JournalEntry] {
        return entries.filter { entry in
            return Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.exerciseType == exerciseType && entry.stage == stage && entry.level == level
        }
    }

    static func getSetsDone(entries: [JournalEntry], forDate date: Date, ofType exerciseType: ExerciseType, ofStage stage: Int, ofLevel level: Level) -> Int {
        let entries = getJournalEntries(entries: entries, forDate: date, ofType: exerciseType, ofStage: stage, ofLevel: level)
        return entries.count
    }

    static func getLatestRecordedReps(entries: [JournalEntry], forType exerciseType: ExerciseType) -> Int {
        let entriesOfType = entries.filter { entry in
            entry.exerciseType == exerciseType
        }
        
        if let latestEntry = entriesOfType.last {
            return latestEntry.reps
        }
        
        return 0
    }
    
    struct ProgressionScore: Identifiable {
        let id = UUID()
        let date: Date
        let score: Double
    }
    
    // Generate a dictionary of scores with the keys being the progression, and each containing an array of scores by date
    // TODO: Adjust to be [Progression: [Level: [ProgressionScore]]]
    static func generateScores(entries: [JournalEntry]) -> [Progression: [Level: [ProgressionScore]]] {
        var result: [Progression: [Level: [ProgressionScore]]] = [:]
        for entry in entries {
            if let progression = Progressions().getProgression(ofType: entry.exerciseType, atStage: entry.stage) {
                if result[progression] == nil {
                    let progressionEntries = getJournalEntries(entries: entries, ofType: entry.exerciseType, ofStage: entry.stage, ofLevel: entry.level)
                    result[progression] = [entry.level: generateScoresForProgression(entries: progressionEntries, progression: progression, level: entry.level)]
                } else if result[progression]?[entry.level] == nil {
                    let progressionEntries = getJournalEntries(entries: entries, ofType: entry.exerciseType, ofStage: entry.stage, ofLevel: entry.level)
                    result[progression]?[entry.level] = generateScoresForProgression(entries: progressionEntries, progression: progression, level: entry.level)
                }
            }
        }
        return result
    }
    
    // Gets score for one progression
    static func generateScoresForProgression(
        entries: [JournalEntry],
        progression: Progression,
        level: Level
    ) -> [ProgressionScore] {
        let filteredEntries = entries.filter { $0.level == level }
        let sortedFilteredEntries = filteredEntries.sorted { $0.date < $1.date }
        var score = 0.0 // Beginning score
        return sortedFilteredEntries.map { entry in
            let targetReps = progression.getReps(for: entry.level)
            let targetSets = progression.getSets(for: entry.level)
            score += calculateScoreOffset(forTargetReps: targetReps, forTargetSets: targetSets, reps: entry.reps)
            // TODO: Regress the score if there's a significant time gap
            return ProgressionScore(
                date: entry.date,
                score: score
            )
        }
    }
    
    static func calculateScoreOffset(forTargetReps targetReps: Int, forTargetSets targetSets: Int, reps: Int) -> Double {
        let offset = 0.08333 // Approx 1/12
        let repsRatio = Double(reps) / Double(targetReps)
        return (offset * repsRatio) / Double(targetSets)
    }
    
}
