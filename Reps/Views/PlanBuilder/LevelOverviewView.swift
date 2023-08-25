//
//  LabelOverviewView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/08/2023.
//

import SwiftUI

struct LevelOverviewView: View {
     
        @Binding var level: ExperienceLevel
        
        var body: some View {
            Section {
                if (level == ExperienceLevel.gettingStarted) {
                    Text("Build a strong foundation, beginning with the fundamental movements to get strong while avoiding injury.")
                }
                if (level == ExperienceLevel.intermediate) {
                    Text("You know the basics and you're ready to build stength.")
                }
                if (level == ExperienceLevel.advanced) {
                    Text("You've been doing this for a while and you're ready to take it to the next level.")
                }
            }
            Section("Progressions") {
                let exerciseLevels = stages[level] ?? [:]
                ForEach(exerciseLevels.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { exerciseType, stage in
                    let exercise = getExercise(ofType: exerciseType.rawValue, atStage: stage)
                        HStack {
                            Text(exercise?.name.rawValue ?? "")
                            Spacer()
                            Text(String(localized: exerciseType.localizedStringResource))
                                .font(.caption)
                        }
                }
            }
        }
    }

//#Preview {
//    LevelOverviewView()
//}
