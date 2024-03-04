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
    // TODO: Have other types of previewcontainer as needed
    static let previewContainer: ModelContainer = {
        let weeklySchedule: [Int : [ExerciseType]] = [
            1: [],
            2: [.pushup, .pullup, .bridge, .legraise, .handstandpushup, .squat],
            3: [.pushup, .pullup, .bridge, .legraise, .handstandpushup, .squat],
            4: [.pushup, .pullup, .bridge, .legraise, .handstandpushup, .squat],
            5: [.pushup, .pullup, .bridge, .legraise, .handstandpushup, .squat],
            6: [.pushup, .pullup, .bridge, .legraise, .handstandpushup, .squat],
            7: []
        ]
//        let userExerciseStages: [ExerciseType : UserExerciseStageDetails] = [
//            .pushup: UserExerciseStageDetails(stage: 5, level: .intermediate),
//            .pullup: UserExerciseStageDetails(stage: 5, level: .intermediate),
//            .bridge: UserExerciseStageDetails(stage: 3, level: .intermediate),
//            .legraise: UserExerciseStageDetails(stage: 5, level: .intermediate),
//            .handstandpushup: UserExerciseStageDetails(stage: 3, level: .intermediate),
//            .squat: UserExerciseStageDetails(stage: 5, level: .intermediate)
//        ]
        let userExerciseStages: [ExerciseType : UserExerciseStageDetails] = [
            .pushup: UserExerciseStageDetails(stage: 0, level: .beginner),
            .pullup: UserExerciseStageDetails(stage: 0, level: .beginner),
            .bridge: UserExerciseStageDetails(stage: 0, level: .beginner),
            .legraise: UserExerciseStageDetails(stage: 0, level: .beginner),
            .handstandpushup: UserExerciseStageDetails(stage: 0, level: .beginner),
            .squat: UserExerciseStageDetails(stage: 0, level: .beginner)
        ]
        
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: JournalEntry.self, configurations: config)

//            let trainingHistoryEntries = JournalData().generateHistoryFromContext(weeks: 26, weeklySchedule: weeklySchedule, userExerciseStages: userExerciseStages, completedNess: .matched)
            
            let trainingHistoryEntries = JournalData.generateHistoryForUser(forWeeks: 6, withSchedule: weeklySchedule, withLevels: userExerciseStages)
            //print("History: \(generatedHistory)")
            
            trainingHistoryEntries.forEach { entry in
                container.mainContext.insert(entry)
            }
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
