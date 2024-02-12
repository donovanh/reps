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

final class UserExerciseStages {
    private let storageKey = "UserExerciseStages"
    
    var userExerciseStages: [ExerciseType: UserExerciseStageDetails] = [:] {
        didSet {
            saveState(userExerciseStages: userExerciseStages)
        }
    }
    
    private func saveState(userExerciseStages: [ExerciseType: UserExerciseStageDetails]) {
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

}
