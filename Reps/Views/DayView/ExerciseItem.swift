//
//  ExerciseItem.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import SwiftData
import SwiftUI

struct ExerciseItem: View {
    
    @State var viewModel: DayView.ViewModel
    let exerciseType: ExerciseType
    let isEditMode: Bool
    let progressions: [Progression]
    let index: Int
    let geo: GeometryProxy

    @Query private var journalEntries: [JournalEntry]
    @State private var isPresentingExerciseSelection = false
    @State private var isPresentingWorkout = false
    @State private var setsDone = 0
    
    var progression: Progression {
        viewModel.getProgression(for: exerciseType)
    }
    
    var level: Level {
        viewModel.getLevel(for: exerciseType)
    }
    
    var body: some View {
        let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
        
        ExerciseItemView(
            progression: progression,
            exerciseType: exerciseType,
            stage: progression.stage,
            level: level,
            setsDone: setsDone,
            isEditMode: isEditMode
        )
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
                dayViewModel: viewModel,
                viewToShow: .changeProgression,
                progressions: getProgressions(ofType: exerciseType),
                startingIndex: progression.stage,
                startingLevel: level,
                screenWidth: geo.size.width
            )
        }
        .sheet(isPresented: $isPresentingWorkout) {
            ProgressionViewer(
                dayViewModel: viewModel,
                viewToShow: .workoutView,
                progressions: progressions,
                startingIndex: index,
                startingLevel: level,
                screenWidth: geo.size.width
            )
        }
    }
}

struct ExerciseItemView: View {
    let progression: Progression
    let exerciseType: ExerciseType
    let stage: Int
    let level: Level
    let setsDone: Int
    let isEditMode: Bool
    
    var body: some View {
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        
        HStack {
            if !isEditMode {
                if setsDone >= sets {
                    Icon(exerciseType: exerciseType, stage: stage, size: 50, complete: true)
                } else {
                    Icon(exerciseType: exerciseType, stage: stage, size: 50, complete: false)
                }
            }
            
            VStack(alignment: .leading) {
                Text(String(localized: progression.name.rawValue))
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                if isEditMode {
                    Text(String(localized: exerciseType.localizedStringResource))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    if setsDone > 0 && setsDone < sets {
                        Text("\(setsDone) of ^[\(sets) set](inflect: true) done")
                    } else if setsDone > 0 {
                        Text("^[\(setsDone) set](inflect: true) done")
                    } else {
                        Text("\(sets) x \(reps) \(progression.showSecondsForReps == true ? "seconds" : "reps")")
                    }
                }
            }
            .padding(.leading, 10)
        }
    }
}

#Preview("ExerciseItemView") {
    let setsDone = [0,1,2,3,0,1]
    let stage = [1,4,3,6,8,9]
    return List {
        Section {
            ForEach(Progression.defaultProgressionMixedSet.indices, id: \.self) { index in
                let progression = Progression.defaultProgressionMixedSet[index]
                ExerciseItemView(
                    progression: progression,
                    exerciseType: progression.type,
                    stage: stage[index],
                    level: .intermediate,
                    setsDone: setsDone[index],
                    isEditMode: false
                )
            }
        }
        .foregroundColor(.primary)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
        .listRowSeparator(.hidden)
        .listRowBackground(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
        )
    }
}

#Preview("ExerciseItem") {
    GeometryReader{ geo in
        ExerciseItem(
            viewModel: DayView.ViewModel(),
            exerciseType: .pushup,
            isEditMode: false,
            progressions: Progression.defaultProgressionSingleType,
            index: 2,
            geo: geo
        )
            .modelContainer(DataController.previewContainer)
    }
}
