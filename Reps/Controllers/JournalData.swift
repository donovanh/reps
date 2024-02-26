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
    
    // Whether reps done were over or under required reps
    // Make this redundant with adjusting to create a progression over time
    enum Completedness {
        case under, over, matched
    }
    
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
                        var repsDone = reps - 3
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
