//
//  UserModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 25/07/2023.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    
    let id: String
    var pushupStage: Int
    var pullupStage: Int
    var squatStage: Int
    var bridgeStage: Int
    var legraiseStage: Int
    var handstandpushupStage: Int
    
    var pushupLevel: String
    var pullupLevel: String
    var squatLevel: String
    var bridgeLevel: String
    var legraiseLevel: String
    var handstandpushupLevel: String
    
    init(
        pushupStage: Int,
        pullupStage: Int,
        squatStage: Int,
        bridgeStage: Int,
        legraiseStage: Int,
        handstandpushupStage: Int,
        pushupLevel: String,
        pullupLevel: String,
        squatLevel: String,
        bridgeLevel: String,
        legraiseLevel: String,
        handstandpushupLevel: String
    ) {
        self.id = UUID().uuidString
        self.pushupStage = pushupStage
        self.pullupStage = pullupStage
        self.squatStage = squatStage
        self.bridgeStage = bridgeStage
        self.legraiseStage = legraiseStage
        self.handstandpushupStage = handstandpushupStage
        
        self.pushupLevel = pushupLevel
        self.pullupLevel = pullupLevel
        self.squatLevel = squatLevel
        self.bridgeLevel = bridgeLevel
        self.legraiseLevel = legraiseLevel
        self.handstandpushupLevel = handstandpushupLevel
    }
    
    func getStage(forType type: ExerciseType) -> Int {
        switch type {
        case ExerciseType.bridge: return self.bridgeStage
        case ExerciseType.handstandpushup: return self.handstandpushupStage
        case ExerciseType.legraise: return self.legraiseStage
        case ExerciseType.pullup: return self.pullupStage
        case ExerciseType.pushup: return self.pushupStage
        case ExerciseType.squat: return self.squatStage
        }
    }
    
    func getLevel(forType type: ExerciseType) -> String {
        switch type {
        case ExerciseType.bridge: return self.bridgeLevel
        case ExerciseType.handstandpushup: return self.handstandpushupLevel
        case ExerciseType.legraise: return self.legraiseLevel
        case ExerciseType.pullup: return self.pullupLevel
        case ExerciseType.pushup: return self.pushupLevel
        case ExerciseType.squat: return self.squatLevel
        }
    }
    
    func setStage(forType type: ExerciseType, stage: Int) {
        switch type {
        case ExerciseType.bridge: self.bridgeStage = stage
        case ExerciseType.handstandpushup: self.handstandpushupStage = stage
        case ExerciseType.legraise: self.legraiseStage = stage
        case ExerciseType.pullup: self.pullupStage = stage
        case ExerciseType.pushup: self.pushupStage = stage
        case ExerciseType.squat: self.squatStage = stage
        }
    }
    
    func setLevel(forType type: ExerciseType, level: String) {
        switch type {
        case ExerciseType.bridge: self.bridgeLevel = level
        case ExerciseType.handstandpushup: self.handstandpushupLevel = level
        case ExerciseType.legraise: self.legraiseLevel = level
        case ExerciseType.pullup: self.pullupLevel = level
        case ExerciseType.pushup: self.pushupLevel = level
        case ExerciseType.squat: self.squatLevel = level
        }
    }
}

let DefaultUser = User(
    pushupStage: 1,
    pullupStage: 1,
    squatStage: 1,
    bridgeStage: 1,
    legraiseStage: 1,
    handstandpushupStage: 1,
    pushupLevel: Level.beginner.rawValue,
    pullupLevel: Level.beginner.rawValue,
    squatLevel: Level.beginner.rawValue,
    bridgeLevel: Level.beginner.rawValue,
    legraiseLevel: Level.beginner.rawValue,
    handstandpushupLevel: Level.beginner.rawValue
)
