//
//  ExerciseDayViewModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/02/2024.
//

import Foundation
import SwiftUI

extension DayView {
    @Observable
    class ViewModel {
        
        var weeklySchedule: [Int: [ExerciseType]] = [:]
        var userExerciseStages: [ExerciseType: UserExerciseStageDetails] = [:]
        var progressionScores: [ExerciseType: [JournalEntry.ProgressionScore]] = [:]
        
        // Stored data - loading and saving
        let workoutScheduleStore = WorkoutSchedule()
        let userExerciseStagesStore = UserExerciseStages()
        let progressionsStore = Progressions()
        
        init() {
            weeklySchedule = workoutScheduleStore.exerciseTypesByDay
            userExerciseStages = userExerciseStagesStore.userExerciseStages
            // TODO: Load any stored userdefaults from icloud and apply
        }
        
        // Use journal entries and current user stage/level to calculate a score for current progress
        func calculateProgressionScores(journalEntries: [JournalEntry]) {
            var updatedProgressionScores: [ExerciseType: [JournalEntry.ProgressionScore]] = [:]
            for exerciseType in ExerciseType.allCases {
                if let stage = userExerciseStages[exerciseType]?.stage, let level = userExerciseStages[exerciseType]?.level {
                    let filteredEntries = journalEntries.filter {
                        $0.exerciseType == exerciseType &&
                        $0.stage == stage &&
                        $0.level == level
                    }
                    if let progression = Progressions().getProgression(ofType: exerciseType, atStage: stage) {
                        let progressionScores = JournalEntry.generateScoresForProgression(entries: filteredEntries, progression: progression, level: level)
                        updatedProgressionScores[exerciseType] = progressionScores
                    }
                }
                
            }
            self.progressionScores = updatedProgressionScores
        }
        
        func getLatestScore(forExerciseType exerciseType: ExerciseType) -> Double {
            return progressionScores[exerciseType]?.max(by: { $0.score < $1.score })?.score ?? 0.0
        }
        
        func getProgression(for type: ExerciseType) -> Progression {
            let stage = userExerciseStages[type]?.stage ?? 0
            return progressionsStore.getProgression(ofType: type, atStage: stage)!
        }
        
        func getStage(for type: ExerciseType) -> Int {
            userExerciseStages[type]?.stage ?? 0
        }
        
        func getLevel(for type: ExerciseType) -> Level {
            userExerciseStages[type]?.level ?? .beginner
        }

        func setStageAndLevel(for type: ExerciseType, stage: Int, level: Level) {
            var currentDetails = userExerciseStages[type] ?? UserExerciseStageDetails()
            currentDetails.stage = stage
            currentDetails.level = level
            userExerciseStages[type] = currentDetails
            userExerciseStagesStore.userExerciseStages = userExerciseStages
        }
        
        func setStages(to userStages: [ExerciseType: Int]) {
            var updatedStages: [ExerciseType: UserExerciseStageDetails] = [:]
            for (exerciseType, stage) in userStages {
                updatedStages[exerciseType] = UserExerciseStageDetails(stage: stage, level: .beginner)
            }
            self.userExerciseStages = updatedStages
        }
        
        func addExerciseType(for type: ExerciseType, forDay day: Int) {
            withAnimation {
                var currentDayExerciseTypes = weeklySchedule[day] ?? []
                currentDayExerciseTypes.append(type)
                weeklySchedule[day] = currentDayExerciseTypes
            }
            workoutScheduleStore.exerciseTypesByDay = weeklySchedule
        }
        
        func setWeeklySchedule(typeByDay: [Int: [ExerciseType]]) {
            weeklySchedule = typeByDay
            workoutScheduleStore.exerciseTypesByDay = weeklySchedule
        }
        
        func moveExercise(fromOffsets: IndexSet, toOffset: Int, forDay day: Int) {
            withAnimation {
                var currentDayExerciseTypes = weeklySchedule[day] ?? []
                currentDayExerciseTypes.move(fromOffsets: fromOffsets, toOffset: toOffset)
                weeklySchedule[day] = currentDayExerciseTypes
            }
            workoutScheduleStore.exerciseTypesByDay = weeklySchedule
        }
        
        func removeExerciseType(at offsets: IndexSet, forDay day: Int) {
            withAnimation {
                var currentDayExerciseTypes = weeklySchedule[day] ?? []
                for offset in offsets {
                    currentDayExerciseTypes.remove(at: offset)
                }
                self.weeklySchedule[day] = currentDayExerciseTypes
            }
            workoutScheduleStore.exerciseTypesByDay = weeklySchedule
        }
        
        func makeProgressions(exerciseTypes: [ExerciseType]) -> [Progression] {
            return exerciseTypes.map {
                progressionsStore.getProgression(ofType: $0, atStage: self.getStage(for: $0)) ?? Progression.defaultProgression
            }
        }
        
        func isTodayDone(journalEntries: [JournalEntry], exerciseTypes: [ExerciseType]) -> Bool {
            var done = true
            
            let todayProgressions = makeProgressions(exerciseTypes: exerciseTypes)
            for progression in todayProgressions {
                if (!isProgressionDone(journalEntries: journalEntries, progression: progression)) {
                    done = false
                    break
                }
            }
            return done
        }
        
        func isTodayInProgress(journalEntries: [JournalEntry], exerciseTypes: [ExerciseType]) -> Bool {
            var inProgress = false
            
            let todayProgressions = makeProgressions(exerciseTypes: exerciseTypes)
            for progression in todayProgressions {
                let level = getLevel(for: progression.type)
                let setsDone = JournalEntry.getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
                if (setsDone > 0) {
                    inProgress = true
                    break
                }
            }
            return inProgress
        }
        
        func isProgressionDone(journalEntries: [JournalEntry], progression: Progression) -> Bool {
            let level = getLevel(for: progression.type)
            let requiredSets = progression.getSets(for: level)
            let setsDone = JournalEntry.getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
            if (setsDone < requiredSets) {
                return false
            }
            return true
        }
        
        // TODO: should be moved to a workout model
        func firstNotDoneProgressionIndex(journalEntries: [JournalEntry], progressions: [Progression]) -> Int {
            for i in 0..<progressions.count {
                if !isProgressionDone(journalEntries: journalEntries, progression: progressions[i]) {
                    return i
                }
            }
            return -1
        }
        
        func nextUnfinishedProgressionIndex(journalEntries: [JournalEntry], progressions: [Progression], progression: Progression) -> Int {
            guard let currentIndex = progressions.firstIndex(where: { $0 == progression }) else {
                    return -1
                }
                
            var nextIndex = (currentIndex + 1) % progressions.count
            
            while nextIndex != currentIndex {
                let nextProgression = progressions[nextIndex]
                if !isProgressionDone(journalEntries: journalEntries, progression: nextProgression) {
                    return nextIndex
                }
                nextIndex = (nextIndex + 1) % progressions.count
            }
            
            return -1
        }
        
        func dayName(for dayNum: Int) -> String {
            DateFormatter().weekdaySymbols[dayNum - 1]
        }
        
        func shortDayName(for dayNum: Int) -> String {
            DateFormatter().shortWeekdaySymbols[dayNum - 1]
        }

        func changeDayNum(num: Int, direction: String) -> Int {
            switch direction {
                case "next": return num == 7 ? 1 : num + 1
                default: return num == 1 ? 7 : num - 1
            }
        }
    }
}
