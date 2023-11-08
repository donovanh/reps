//
//  AdjustProgression.swift
//  Reps
//
//  Created by Donovan Hutchinson on 08/11/2023.
//

import SwiftUI
import SwiftData

struct AdjustProgression: View {
    
    struct ProgressionDetails {
        let progression: Progression
        let level: Level
    }
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    let progression: Progression
    let level: Level
    
    @State private var prevProgressionDetails = ProgressionDetails(progression: pushupDataSet[0], level: Level.beginner)
    @State private var nextProgressionDetails = ProgressionDetails(progression: pushupDataSet[0], level: Level.beginner)
    @State private var isShowingNewProgressionDetails = false
    
    // TODO: Details of the level/stage change
    // TODO: "Applied" state
    // TODO: Cancel button
    // TODO: Confirm button
    
    var body: some View {
        Text("Adjust Progression")
            .font(.title)
        // TODO: Suggest a level/stage progression if streak of hitting the full rep + sets goal
        // TODO: Logic to show/hide these if at first stage+level or last stage+level
        HStack {
            let prevLevel = getPreviousLevel(for: progression, at: level)
            let prevStage = getPreviousStage(for: progression)
            let nextLevel = getNextLevel(for: progression, at: level)
            let nextStage = getNextStage(for: progression)
            
            let prevReps = prevProgressionDetails.progression.getReps(for: prevLevel)
            let prevSets = prevProgressionDetails.progression.getSets(for: prevLevel)
            let nextReps = nextProgressionDetails.progression.getReps(for: nextLevel)
            let nextSets = nextProgressionDetails.progression.getSets(for: nextLevel)
            
            if progressionHasPreviousLevel(for: progression, at: level) || progressionHasPreviousStage(for: progression) {
                VStack {
                    Text(String(localized: prevProgressionDetails.progression.name.rawValue))
                    if (prevProgressionDetails.progression.showSecondsForReps == true) {
                        Text("\(prevSets) x \(prevReps) seconds")
                    } else {
                        Text("\(prevSets) x \(prevReps) reps")
                    }
                    Button {
                        if progressionHasPreviousLevel(for: progression, at: level) {
                            setLevel(progression.type, levelStr: prevLevel.rawValue) // TODO: Try to use level as object
                        } else {
                            setProgression(progression.type, stage: prevStage)
                        }
                        isShowingNewProgressionDetails = true
                    } label: {
                        Text("Move back")
                    }
                    .padding()
                }
                .padding()
            }
            if progressionHasNextLevel(for: progression, at: level) || progressionHasNextStage(for: progression) {
                VStack {
                    Text(String(localized: nextProgressionDetails.progression.name.rawValue))
                    if (nextProgressionDetails.progression.showSecondsForReps == true) {
                        Text("\(nextSets) x \(nextReps) seconds")
                    } else {
                        Text("\(nextSets) x \(nextReps) reps")
                    }
                    Button {
                        if progressionHasNextLevel(for: progression, at: level) {
                            setLevel(progression.type, levelStr: nextLevel.rawValue)
                        } else {
                            setProgression(progression.type, stage: nextStage)
                        }
                        isShowingNewProgressionDetails = true
                    } label: {
                        Text("Move up")
                    }
                    .padding()
                }
                .padding()
            }
        }
        .onAppear {
            let progressionDetails = getProgressionDetails(forProgression: progression, level: level)
            prevProgressionDetails = progressionDetails.prevProgressionDetails
            nextProgressionDetails = progressionDetails.nextProgressionDetails
        }
    }
    
    func newProgression(forStage stage: Int?) -> Progression {
        if let progression = getExercise(ofType: progression.type, atStage: stage ?? progression.stage) {
            return progression
        } else {
            fatalError("Could not find progression")
        }
    }
    // TODO: Add check for very first stage/level and very last stage/level
    func getProgressionDetails(forProgression progression: Progression, level: Level) -> (prevProgressionDetails: ProgressionDetails, nextProgressionDetails: ProgressionDetails) {
        var prevProgressionDetails: ProgressionDetails
        var nextProgressionDetails: ProgressionDetails
        
        if progressionHasPreviousLevel(for: progression, at: level) {
            prevProgressionDetails = ProgressionDetails(progression: progression, level: getPreviousLevel(for: progression, at: level))
        } else {
            let newProgression = newProgression(forStage: getPreviousStage(for: progression))
            prevProgressionDetails = ProgressionDetails(progression: newProgression, level: Level.beginner)
        }
    
        if progressionHasNextLevel(for: progression, at: level) {
            nextProgressionDetails = ProgressionDetails(progression: progression, level: getNextLevel(for: progression, at: level))
        } else {
            let newProgression = newProgression(forStage: getNextStage(for: progression))
            nextProgressionDetails = ProgressionDetails(progression: newProgression, level: Level.beginner)
        }
        
        return (prevProgressionDetails, nextProgressionDetails)
    }
    
    func setProgression(_ type: ExerciseType, stage: Int) {
        if let user = users.first {
            user.setStage(forType: type, stage: stage)
            user.setLevel(forType: type, level: Level.beginner.rawValue)
        }
    }
    
    func setLevel(_ type: ExerciseType, levelStr: String) {
        if let user = users.first {
            user.setLevel(forType: type, level: levelStr)
        }
    }
}

#Preview {
    AdjustProgression(
        progression: pullupDataSet[9],
        level: Level.progression
    )
}
