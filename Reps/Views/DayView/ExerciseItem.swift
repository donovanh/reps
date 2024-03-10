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
    let progressScore: Double
    let isEditMode: Bool
    let progressions: [Progression]
    let index: Int
    let geo: GeometryProxy

    @Query private var journalEntries: [JournalEntry]
    @State private var isPresentingExerciseSelection = false
    @State private var isPresentingWorkout = false
    @State private var setsDone = 0
    @State private var showNextProgressionInProgressionViewer = false
    
    var progression: Progression {
        viewModel.getProgression(for: exerciseType)
    }
    
    var level: Level {
        viewModel.getLevel(for: exerciseType)
    }
    
    var body: some View {
        let setsDone = JournalEntry.getSetsDone(entries: journalEntries, forDate: Date(), ofType: progression.type, ofStage: progression.stage, ofLevel: level)
        
        ExerciseItemView(
            progression: progression,
            exerciseType: exerciseType,
            progressScore: progressScore,
            stage: progression.stage,
            level: level,
            setsDone: setsDone,
            isEditMode: isEditMode,
            isPresentingExerciseSelection: $isPresentingExerciseSelection
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
                progressions: Progressions().getProgressions(ofType: exerciseType),
                startingIndex: progression.stage,
                startingLevel: level,
                progressScore: progressScore,
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
                progressScore: progressScore,
                screenWidth: geo.size.width
            )
        }
    }
}

struct ExerciseItemView: View {
    let progression: Progression
    let exerciseType: ExerciseType
    let progressScore: Double
    let stage: Int
    let level: Level
    let setsDone: Int
    let isEditMode: Bool
    @Binding var isPresentingExerciseSelection: Bool
    
    var body: some View {
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        let isComplete = setsDone >= sets
        
        ZStack {
            Color.clear.contentShape(Rectangle())
            HStack {
                let canUpgrade = progressScore > 0.98
                if !isEditMode {
                        Icon(
                            exerciseType: exerciseType,
                            stage: stage,
                            size: 50,
                            score: progressScore,
                            complete: isComplete
                        )
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(String(localized: progression.name.rawValue))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        
                        if isEditMode {
                            Text(String(localized: exerciseType.localizedStringResource))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            HStack {
                                if isComplete {
                                    Text("All sets done")
                                } else if setsDone > 0 && setsDone < sets {
                                    Text("\(setsDone) of ^[\(sets) set](inflect: true) done")
                                } else if setsDone > 0 {
                                    Text("^[\(setsDone) set](inflect: true) done")
                                } else {
                                    Text("\(sets) x \(reps) \(progression.showSecondsForReps == true ? "seconds" : "reps")")
                                }
                            }
                            .font(.caption)
                        }
                    }
                    .opacity(isComplete ? 0.25 : 1)
                    if !isEditMode {
                        Spacer()
                        Button {
                            isPresentingExerciseSelection = true
                        } label: {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 20).bold())
                                .foregroundColor(canUpgrade ? Color.themeColor : .secondary.opacity(0.5))
                        }
                        .onTapGesture(perform: {
                            isPresentingExerciseSelection = true
                        })
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

#Preview("ExerciseItemView") {
    let setsDone = [0,1,2,3,0,1]
    let stage = [1,4,3,6,8,9]
    return ScrollView {
        VStack(alignment: .leading) {
            ForEach(Progression.defaultProgressionMixedSet.indices, id: \.self) { index in
                let progression = Progression.defaultProgressionMixedSet[index]
                ExerciseItemView(
                    progression: progression,
                    exerciseType: progression.type,
                    progressScore: 0.45,
                    stage: stage[index],
                    level: .intermediate,
                    setsDone: setsDone[index],
                    isEditMode: false,
                    isPresentingExerciseSelection: .constant(false)
                )
            }
        }
    }
}

#Preview("ExerciseItem") {
    GeometryReader{ geo in
        ExerciseItem(
            viewModel: DayView.ViewModel(),
            exerciseType: .pushup,
            progressScore: 0.95,
            isEditMode: false,
            progressions: Progression.defaultProgressionSingleType,
            index: 2,
            geo: geo
        )
            .modelContainer(DataController.previewContainer)
    }
}
