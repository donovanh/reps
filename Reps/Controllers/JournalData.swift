//
//  JournalData.swift
//  Reps
//
//  Created by Donovan Hutchinson on 25/02/2024.
//

import Foundation

// Functions to generate journal data
// generateDaySession
// Define three types of day (which contain exercises) (incomplete, complete)
// Define levels for the day's exercises (Level)
// Method to return a day's session based on completeness and level

// TODO: Apply entopy to the reps and levels going back in time to look like progressions happening

// TODO: use this to visually test machine-learning-based coach decisions as well as UI
// TODO: Use spreadsheet to generate machine learning examples with expected outcomes

struct JournalData {
    
    // V2: Generate a realistic history starting N weeks back
    // Options: starting schedule and levels
    // Other options: Level-up aggressiveness (how long to wait when approaching or after 1 in score)
    
    static func generateHistoryForUser(
        forWeeks weeks: Int,
        withSchedule schedule: [Int: [ExerciseType]],
        withLevels userExerciseStages: [ExerciseType: UserExerciseStageDetails]
    ) -> [JournalEntry] {
        var journalEntries: [JournalEntry] = []
        let daysOffset = weeks * 7
        let currentDate = Date()
        var workingDate = currentDate.daysOffset(offset: -(daysOffset))
        
        var copiedUserExerciseStages: [ExerciseType: UserExerciseStageDetails] = [:]
        
        for (exerciseType, details) in userExerciseStages {
            copiedUserExerciseStages[exerciseType] = details
        }
        
        while workingDate < currentDate {
            
            if let dayNum = workingDate.dayNumberOfWeek() {
                if let exerciseTypes = schedule[dayNum] {
                    for exerciseType in exerciseTypes {
                        // Get the progression for this exercise type and user level and stage
                        let stage = copiedUserExerciseStages[exerciseType]?.stage ?? 0
                        let level = copiedUserExerciseStages[exerciseType]?.level ?? .beginner
                        if let progression = Progressions().getProgression(ofType: exerciseType, atStage: stage) {
                            // Decide whether to move it up  or not depending on score
                            let (newStage, newLevel) = adjustedStageAndLevel(forProgression: progression, level: level, entries: journalEntries)
                            copiedUserExerciseStages[exerciseType]?.stage = newStage
                            copiedUserExerciseStages[exerciseType]?.level = newLevel
                            let reps = progression.getReps(for: newLevel)
                            let sets = progression.getSets(for: newLevel)
                            for _ in 0..<sets {
                                let entry = JournalEntry(
                                    date: workingDate,
                                    exerciseType: progression.type,
                                    stage: newStage,
                                    level: newLevel,
                                    reps: reps
                                )
                                // Insert a journal entry for each set at the reps level
                                // TODO: Adjust the reps and sets recorded to make more random or by config
                                journalEntries.append(entry)
                            }
                        }
                    }
                }
            }
            workingDate = workingDate.daysOffset(offset: 1) // Move forward a day and keep looping
        }
        
        return journalEntries
    }
    
    static func adjustedStageAndLevel(forProgression progression: Progression, level: Level, entries: [JournalEntry]) -> (Int, Level) {
        // Calculate scores
        let filteredEntries = entries.filter {
            $0.exerciseType == progression.type &&
            $0.stage == progression.stage &&
            $0.level == level
        }
        // print("\(String(localized: progression.name.rawValue)) \(progression.stage) \(level)")
        if filteredEntries.count > 11 {
//            let progressionScores = JournalEntry.generateScoresForProgression(entries: filteredEntries, progression: progression)
//            let filteredScores = progressionScores.filter { $0.level == level }
//            let sortedFilteredScores = filteredScores.sorted { $0.date > $1.date }
//            for scoreStruct in sortedFilteredScores {
//                
//                if scoreStruct.score > 0.99 {
                    // print("\(String(localized: progression.name.rawValue)) \(level): \(scoreStruct.score)")
                    // Go to the next level or stage
                    if level == .beginner {
                        return (progression.stage, .intermediate)
                    }
                    if level == .intermediate {
                        return (progression.stage, .progression)
                    }
                    if level == .progression && progression.stage < 9 {
                        return (progression.stage + 1, .beginner)
                    }
//                }
//            }
        }
        return (progression.stage, level)
    }
    
    
    // Whether reps done were over or under required reps
    // Make this redundant with adjusting to create a progression over time
    enum Completedness {
        case under, over, matched
    }
    
    // TODO: Go through data and make sure it's actually generating progression without skipping levels
    
    func adjustStagesForWeekNum(userExerciseStages: [ExerciseType : UserExerciseStageDetails], weekNum: Int) -> [ExerciseType : UserExerciseStageDetails] {
        // Adjusts level every two weeks
        var updatedStages: [ExerciseType : UserExerciseStageDetails] = [:]
        
        for (exerciseType, details) in userExerciseStages {
            updatedStages[exerciseType] = details
        }
        
        for (exerciseType, details) in userExerciseStages {
            // TODO: Make it an 80% chance of having progressed
            if details.level == .beginner {
                updatedStages[exerciseType]?.stage = details.stage > 0 ? details.stage - 1 : details.stage
                updatedStages[exerciseType]?.level = details.stage > 0 ? .progression : .beginner
            } else {
                if details.level == .intermediate {
                    updatedStages[exerciseType]?.level = .beginner
                } else {
                    updatedStages[exerciseType]?.level = .intermediate
                }
            }
        }
        
        return updatedStages
    }
    
    func generateHistoryFromContext(weeks: Int, weeklySchedule: [Int : [ExerciseType]], userExerciseStages: [ExerciseType : UserExerciseStageDetails], completedNess: Completedness) -> [JournalEntry] {
        var generatedHistory: [JournalEntry] = []
        
        let calendar = Calendar.current
        var currentDate = Date()
        var updatedUserExerciseStages = userExerciseStages
        
        for weekNum in 0..<weeks {
            // Track the stage and level and adjust it back every n weeks
            if weekNum.isMultiple(of: 2) {
                updatedUserExerciseStages = adjustStagesForWeekNum(userExerciseStages: updatedUserExerciseStages, weekNum: weekNum)
            }
            
            let weekEntries = generateWeekFromContext(endingOn: currentDate, weeklySchedule: weeklySchedule, userExerciseStages: updatedUserExerciseStages, completedNess: completedNess)
            generatedHistory.append(contentsOf: weekEntries)
            
            guard let previousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousWeek
        }
        
        return generatedHistory
    }
    
    func generateWeekFromContext(endingOn date: Date, weeklySchedule: [Int : [ExerciseType]], userExerciseStages: [ExerciseType : UserExerciseStageDetails], completedNess: Completedness) -> [JournalEntry] {
        var generatedWeek: [JournalEntry] = []
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -6, to: date)!
        
        for dayOffset in 0..<7 {
            let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            
            let currentDayNum = currentDate.dayNumberOfWeek() ?? 0
            
            let dayEntries = generateDayFromContext(for: currentDate, exercises: weeklySchedule[currentDayNum] ?? [], userExerciseStages: userExerciseStages, completedNess: completedNess)
            generatedWeek.append(contentsOf: dayEntries)
        }
        
        return generatedWeek
    }
    
    func generateDayFromContext(for date: Date, exercises: [ExerciseType], userExerciseStages: [ExerciseType : UserExerciseStageDetails], completedNess: Completedness) -> [JournalEntry] {
        var journalEntries: [JournalEntry] = []
        let progressions = Progressions()
        
        for exercise in exercises {
            // For each of fullDayExercises, obtain the required reps level
            let stage = userExerciseStages[exercise]?.stage ?? 0
            let level = userExerciseStages[exercise]?.level ?? .beginner
            let progression = progressions.getProgression(ofType: exercise, atStage: stage)
            // Get number of sets for the progression
            if let sets = progression?.getSets(for: level) {
                for _ in 0..<sets {
                    if let reps = progression?.getReps(for: level) {
                        // Generate reps needed by completeness
                        var repsDone = reps
                        if completedNess == .over {
                            repsDone += 5 // TODO: More nuance here?
                        }
                        if completedNess == .under {
                            repsDone -= 2 // TODO: More nuance here?
                        }
                        journalEntries.append(
                            JournalEntry(
                                date: date,
                                exerciseType: exercise,
                                stage: stage,
                                level: level,
                                reps: repsDone
                            )
                        )
                    }
                }
            }
            
//            // For debugging, add in another at different stage
//            journalEntries.append(
//                JournalEntry(
//                    date: date,
//                    exerciseType: exercise,
//                    stage: 9,
//                    level: .progression,
//                    reps: 999
//                )
//            )
        }
        
        return journalEntries
    }
    
}
