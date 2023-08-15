//
//  ExerciseView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/08/2023.
//

import SwiftUI
import SwiftData
import Foundation

struct ExerciseDetailView: View {
    
    // TODO
    // Show a success screen when all exercises done - or return to home view with a success message there?
    // Offer option to record another set even if complete
    // Think about how to allow users to add extra sets of *any* exercise / progression
    
    @Environment(\.modelContext) private var context
    @Query private var journalEntries: [JournalEntry]
    
    
    @Binding var showingTodayRoutine: Bool
    
    @State var reps = 0
    @State var difficulty: Difficulty = .moderate
    @State var isRecordingSet = false
    @State var currentExerciseId: UUID?
    
    let progression: Progression
    let exerciseType: ExerciseType
    let levelStr: String
    let scrollViewValue: ScrollViewProxy
    let exerciseId: UUID
    let nextExerciseWithSetsId: UUID
    let nextExerciseId: UUID
    
    var body: some View {
        let level = Level(rawValue: levelStr) ?? .beginner
        let goalReps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        let setsDoneToday = getSetsDone(
            entries: journalEntries,
            forDate: Date(),
            ofType: progression.type.rawValue
        )
        
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text(String(localized: exerciseType.localizedStringResource))
                    .font(.caption)
                Text(String(localized: progression.name.rawValue))
                    .font(.title)
                    .padding(.top, 10)
                Text("\(goalReps)")
                    .font(.system(size: 128))
                if (progression.showSecondsForReps == true) {
                    Text("seconds")
                        .font(.title)
                } else {
                    Text("reps")
                        .font(.title)
                }
                if (setsDoneToday >= sets) {
                    Text("All sets done!")
                        .padding(.vertical)
                } else {
                    Text("Set \(setsDoneToday + 1) of \(sets)")
                        .padding(.vertical)
                }
                Spacer()
                Button("Record Set") {
                    isRecordingSet = true
                }
                Spacer()
            }
            Spacer()
            .sheet(isPresented: $isRecordingSet) {
                VStack {
                    Text("I managed...")
                    HStack {
                        Spacer()
                        Button {
                            decrementReps()
                        } label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48)
                        }
                        .buttonRepeatBehavior(.enabled)
                        
                        Spacer()
                        HStack {
                            Text("\(reps)")
                                .font(.system(size: 64))
                            if (progression.showSecondsForReps == true) {
                                Text("seconds")
                            } else {
                                Text("reps")
                            }
                        }
                        Spacer()
                        Button {
                            incrementReps()
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48)
                        }
                        .buttonRepeatBehavior(.enabled)
                        Spacer()
                    }
                    Text("It was...")
                    Picker("Difficulty level", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { diff in
                            Text(diff.localizedStringResource)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    Button("Save") {
                        saveSet(setsDoneToday: setsDoneToday, sets: sets)
                    }
                    .padding()
                }
                .presentationDetents([.height(275)])
                .presentationDragIndicator(.automatic)
            }
        }
        .onAppear {
            currentExerciseId = exerciseId
            let latestRepCount = getLatestRecordedReps(entries: journalEntries, forType: progression.type.rawValue)
            reps = latestRepCount > 0 ? latestRepCount : progression.getReps(for: level)
            difficulty = getLatestRecordedDifficulty(entries: journalEntries, forType: progression.type.rawValue)
        }
    }
    
    func saveSet(setsDoneToday: Int, sets: Int) {
        isRecordingSet = false
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type.rawValue,
                stage: progression.stage,
                reps: reps,
                difficulty: difficulty.rawValue
            )
        )
        if exerciseId == nextExerciseWithSetsId {
            print(setsDoneToday)
            print(sets)
            if setsDoneToday + 1 >= sets {
                showingTodayRoutine = false
            }
        } else {
            withAnimation {
                scrollViewValue.scrollTo(nextExerciseWithSetsId)
            }
        }
    }
    
    func incrementReps() {
        reps += 1
    }
    
    func decrementReps() {
        reps -= 1
    }
}

//#Preview {
//    ExerciseDetailView()
//}
