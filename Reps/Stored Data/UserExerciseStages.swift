//
//  UserExerciseStages.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import Foundation

struct UserExerciseStageDetails: Codable {
    var stage: Int = 0
    var level: Level = .beginner
}

@Observable
final class UserExerciseStages {
    private let storageKey = "UserExerciseStages"
    
    var userExerciseStages: [ExerciseType: UserExerciseStageDetails] = [:] {
        didSet {
            saveState(userExerciseStages: userExerciseStages)
        }
    }
    
    func saveState(userExerciseStages: [ExerciseType: UserExerciseStageDetails]) {
        if let encoded = try? JSONEncoder().encode(userExerciseStages) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    init() {
        if let savedUserStages = UserDefaults.standard.data(forKey: storageKey) {
            if let decodedItems = try? JSONDecoder().decode([ExerciseType: UserExerciseStageDetails].self, from: savedUserStages) {
                self.userExerciseStages = decodedItems
                return
            }
        }

        self.userExerciseStages = [:]
    }
    
    func stage(for type: ExerciseType) -> Int {
        self.userExerciseStages[type]?.stage ?? 0
    }
    
    func level(for type: ExerciseType) -> Level {
        self.userExerciseStages[type]?.level ?? .beginner
    }
    
    func setStage(for type: ExerciseType, stage: Int) {
        var currentDetails = self.userExerciseStages[type] ?? UserExerciseStageDetails()
        currentDetails.stage = stage
        self.userExerciseStages[type] = currentDetails
    }
    
    func setLevel(for type: ExerciseType, level: Level) {
        var currentDetails = self.userExerciseStages[type] ?? UserExerciseStageDetails()
        currentDetails.level = level
        self.userExerciseStages[type] = currentDetails
    }
    
    func setStageAndLevel(for type: ExerciseType, stage: Int, level: Level) {
        var currentDetails = self.userExerciseStages[type] ?? UserExerciseStageDetails()
        currentDetails.stage = stage
        currentDetails.level = level
        self.userExerciseStages[type] = currentDetails
    }
}
