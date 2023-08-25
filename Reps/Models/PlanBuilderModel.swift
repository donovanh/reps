//
//  PlanBuilderModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 31/07/2023.
//

import Foundation

enum ExperienceLevel: LocalizedStringResource, CaseIterable {
    case gettingStarted = "Getting started"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum Schedule: LocalizedStringResource, CaseIterable {
    case defaultSchedule = "Default"
    case intermediateSchedule = "Intermediate"
    case advancedPushPullSchedule = "Advanced (push/pull) "
    case advancedUpperLowerSchedule = "Advanced (upper/lower)"
}
