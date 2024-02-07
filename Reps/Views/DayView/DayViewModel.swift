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
        
        func isTodayDone(journalEntries: [JournalEntry], exerciseTypes: [ExerciseType], userExerciseStages: UserExerciseStages) -> Bool {
            var done = true
            
            let todayProgressions = makeProgressions(exerciseTypes: exerciseTypes, userExerciseStages: userExerciseStages)
            for progression in todayProgressions {
                if (!isProgressionDone(journalEntries: journalEntries, progression: progression, userExerciseStages: userExerciseStages)) {
                    done = false
                    break
                }
            }
            return done
        }
        
        func isTodayInProgress(journalEntries: [JournalEntry], exerciseTypes: [ExerciseType], userExerciseStages: UserExerciseStages) -> Bool {
            var inProgress = false
            
            let todayProgressions = makeProgressions(exerciseTypes: exerciseTypes, userExerciseStages: userExerciseStages)
            for progression in todayProgressions {
                let level = userExerciseStages.level(for: progression.type)
                let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
                if (setsDone > 0) {
                    inProgress = true
                    break
                }
            }
            return inProgress
        }
        
        func isProgressionDone(journalEntries: [JournalEntry], progression: Progression, userExerciseStages: UserExerciseStages) -> Bool {
            let level = userExerciseStages.level(for: progression.type)
            let requiredSets = progression.getSets(for: level)
            let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
            if (setsDone < requiredSets) {
                return false
            }
            return true
        }
        
        func firstNotDoneProgressionIndex(journalEntries: [JournalEntry], progressions: [Progression], userExerciseStages: UserExerciseStages) -> Int {
            for i in 0..<progressions.count {
                if !isProgressionDone(journalEntries: journalEntries, progression: progressions[i], userExerciseStages: userExerciseStages) {
                    return i
                }
            }
            return -1
        }
        
        func nextUnfinishedProgressionIndex(journalEntries: [JournalEntry], progressions: [Progression], progression: Progression, userExerciseStages: UserExerciseStages) -> Int {
            guard let currentIndex = progressions.firstIndex(where: { $0 == progression }) else {
                    return -1
                }
                
            var nextIndex = (currentIndex + 1) % progressions.count
            
            while nextIndex != currentIndex {
                let nextProgression = progressions[nextIndex]
                if !isProgressionDone(journalEntries: journalEntries, progression: nextProgression, userExerciseStages: userExerciseStages) {
                    return nextIndex
                }
                nextIndex = (nextIndex + 1) % progressions.count
            }
            
            return -1
        }
        
        func makeProgressions(exerciseTypes: [ExerciseType], userExerciseStages: UserExerciseStages
        ) -> [Progression] {
            return exerciseTypes.map {
                getProgression(ofType: $0, atStage: userExerciseStages.stage(for: $0)) ?? Progression.defaultProgression
            }
        }
        
        func dayName(for dayNum: Int) -> String {
            DateFormatter().weekdaySymbols[dayNum - 1]
        }

        func changeDayNum(num: Int, direction: String) -> Int {
            switch direction {
                case "next": return num == 7 ? 1 : num + 1
                default: return num == 1 ? 7 : num - 1
            }
        }
    }
}
