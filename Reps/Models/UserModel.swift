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
    
    func getStage(forType type: String) -> Int {
        switch type {
        case ExerciseType.bridge.rawValue: return self.bridgeStage
        case ExerciseType.handstandpushup.rawValue: return self.handstandpushupStage
        case ExerciseType.legraise.rawValue: return self.legraiseStage
        case ExerciseType.pullup.rawValue: return self.pullupStage
        case ExerciseType.pushup.rawValue: return self.pushupStage
        case ExerciseType.squat.rawValue: return self.squatStage
        default: return 1
        }
    }
    
    func getLevel(forType type: String) -> String {
        switch type {
        case ExerciseType.bridge.rawValue: return self.bridgeLevel
        case ExerciseType.handstandpushup.rawValue: return self.handstandpushupLevel
        case ExerciseType.legraise.rawValue: return self.legraiseLevel
        case ExerciseType.pullup.rawValue: return self.pullupLevel
        case ExerciseType.pushup.rawValue: return self.pushupLevel
        case ExerciseType.squat.rawValue: return self.squatLevel
        default: return Level.beginner.rawValue
        }
    }
    
    func setStage(forType type: String, stage: Int) {
        switch type {
        case ExerciseType.bridge.rawValue: self.bridgeStage = stage
        case ExerciseType.handstandpushup.rawValue: self.handstandpushupStage = stage
        case ExerciseType.legraise.rawValue: self.legraiseStage = stage
        case ExerciseType.pullup.rawValue: self.pullupStage = stage
        case ExerciseType.pushup.rawValue: self.pushupStage = stage
        case ExerciseType.squat.rawValue: self.squatStage = stage
        default: break
        }
    }
    
    func setLevel(forType type: String, level: String) {
        switch type {
        case ExerciseType.bridge.rawValue: self.bridgeLevel = level
        case ExerciseType.handstandpushup.rawValue: self.handstandpushupLevel = level
        case ExerciseType.legraise.rawValue: self.legraiseLevel = level
        case ExerciseType.pullup.rawValue: self.pullupLevel = level
        case ExerciseType.pushup.rawValue: self.pushupLevel = level
        case ExerciseType.squat.rawValue: self.squatLevel = level
        default: break
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

