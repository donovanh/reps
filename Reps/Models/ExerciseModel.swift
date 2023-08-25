//
//  Exercises.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

struct Exercise: Identifiable, Hashable, Codable {
    let id: UUID
    let type: String
}

enum ExerciseType: String, CaseIterable, Codable {
    case pushup, pullup, squat, bridge, legraise, handstandpushup
}

enum ProgressionName: LocalizedStringResource {
    case shortBridges = "Short bridges"
    case straightBridges = "Straight bridges"
    case angledBridges = "Angled bridges"
    case headBridges = "Head bridges"
    case halfBridges = "Half bridges"
    case fullBridges = "Full bridges"
    case wallWalkingDown = "Wall Walking (Down)"
    case wallWalkingUp = "Wall Walking (Up)"
    case closingBridges = "Closing bridges"
    case standToStandBridges = "Stand-to-Stand bridges"
    
    case wallHeadstands = "Wall headstands"
    case crow = "Crow"
    case wallHandstands = "Wall handstands"
    case halfHandstandPushups = "Half-handstand pushups"
    case handstandPushups = "Handstand pushups"
    case closeHandstandPushups = "Close handstand pushups"
    case unevenHandstandPushups = "Uneven handstand pushups"
    case halfOneArmHandstandPushups = "Half One-arm handstand pushups"
    case leverHandstandPushups = "Lever handstand pushups"
    case oneArmHandstandPushups = "One-arm handstand pushups"
    
    case kneeTucks = "Knee tucks"
    case flatKneeLegRaises = "Flat knee leg raises"
    case flatBentLegRaises = "Flat bent leg raises"
    case flatFrogRaises = "Flat frog raises"
    case flatStraightLegRaises = "Flat straight-leg raises"
    case hangingKneeRaises = "Hanging knee raises"
    case hangingBentLegRaises = "Hanging bent-leg raises"
    case hangingFrogRaises = "Hanging frog raises"
    case partialStraightLegRaises = "Partial straight-leg raises"
    case hangingStraightLegRaises = "Hanging straight-leg raises"
    
    case verticalPullups = "Vertical pull-ups"
    case horizontalPullups = "Horizontal pull-ups"
    case jackknifePullups = "Jackknife pull-ups"
    case halfPullups = "Half pull-ups"
    case fullPullups = "Full pull-ups"
    case closePullups = "Close pull-ups"
    case unevenPullups = "Uneven pull-ups"
    case halfOneArmPullups = "Half One-arm pull-ups"
    case assistedOneArmPullups = "One-arm negative pull-ups"
    case oneArmPullups = "One-arm pull-ups"
    
    case wallPushups = "Wall push-ups"
    case inclinePushups = "Incline push-ups"
    case kneelingPushups = "Kneeling push-ups"
    case halfPushups = "Half push-ups"
    case fullPushups = "Full push-ups"
    case closePushups = "Close push-ups"
    case unevenPushups = "Uneven push-ups"
    case halfOneArmPushups = "Half One-arm push-ups"
    case leverPushups = "Lever push-ups"
    case oneArmPushups = "One-arm push-ups"
    
    case shoulderStands = "Shoulder stands"
    case jackknifeSquats = "Jackknife squats"
    case supportedSquats = "Supported squats"
    case halfSquats = "Half squats"
    case fullSquats = "Full squats"
    case closeSquats = "Close squats"
    case unevenSquats = "Uneven squats"
    case halfOneLegSquats = "Half One-leg squats"
    case assistedOneLegSquats = "Assisted One-leg squats"
    case oneLegSquats = "One-leg squats"
}

struct Progression: Hashable {
    let stage: Int
    let type: ExerciseType
    let name: ProgressionName
    let reps: [Level: Int]
    let sets: [Level: Int]
    var showSecondsForReps: Bool?
    var showForEachSide: Bool?
    var animationFileName: String?
    
    func getReps(for level: Level) -> Int {
        return reps[level] ?? 0
    }
    
    func getSets(for level: Level) -> Int {
        return sets[level] ?? 0
    }
}

enum Level: String, CaseIterable, Codable {
    case beginner, intermediate, progression
}
