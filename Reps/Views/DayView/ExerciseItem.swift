//
//  ExerciseItem.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

// TODO: Functions to find sets done today for the given progression

import SwiftData
import SwiftUI

struct ExerciseItem: View {
    
    @State var userExerciseStages: UserExerciseStages
    let exerciseType: ExerciseType
    let isEditMode: Bool
    let progressions: [Progression]
    let index: Int
    let geo: GeometryProxy

    @Query private var journalEntries: [JournalEntryV2]
    @State private var isPresentingExerciseSelection = false
    @State private var isPresentingWorkout = false
    @State private var setsDone = 0
    
    var progression: Progression {
        getProgression(ofType: exerciseType, atStage: userExerciseStages.stage(for: exerciseType)) ?? Progression.defaultProgression
    }
    
    var level: Level {
        userExerciseStages.level(for: exerciseType)
    }
    
    var body: some View {
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: exerciseType, ofStage: progression.stage, ofLevel: level)
        
        HStack {
            VStack(alignment: .leading) {
                Text(String(localized: progression.name.rawValue))
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("\(sets) x \(reps) \(progression.showSecondsForReps == true ? "seconds" : "reps")")
            }
            
            Spacer()
            
            if isEditMode {
                Text(String(localized: exerciseType.localizedStringResource))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                if setsDone > 0 {
                    Text("^[\(setsDone) set](inflect: true) done")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Not started")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if !isEditMode {
                if (setsDone >= sets) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio (contentMode: .fit)
                            .foregroundColor(.green)
                            .frame(width: 20)
                    }
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio (contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 20)
                }
            }
        }
        .padding()
        .onTapGesture(perform: {
            if isEditMode {
                isPresentingExerciseSelection = true
            } else {
                isPresentingWorkout = true
            }
        })
        .sheet(isPresented: $isPresentingExerciseSelection) {
            ProgressionViewer(
                userExerciseStages: userExerciseStages,
                viewToShow: .changeProgression,
                progressions: getProgressions(ofType: exerciseType),
                startingIndex: progression.stage,
                startingLevel: level,
                screenWidth: geo.size.width
            )
        }
        .sheet(isPresented: $isPresentingWorkout) {
            ProgressionViewer(
                userExerciseStages: userExerciseStages,
                viewToShow: .workoutView,
                progressions: progressions,
                startingIndex: index,
                startingLevel: level,
                screenWidth: geo.size.width
            )
        }
    }
}

#Preview {
    GeometryReader{ geo in
        ExerciseItem(
            userExerciseStages: UserExerciseStages(),
            exerciseType: .pushup,
            isEditMode: false,
            progressions: Progression.defaultProgressionSingleType,
            index: 2,
            geo: geo
        )
            .modelContainer(DataController.previewContainer)
    }
}
