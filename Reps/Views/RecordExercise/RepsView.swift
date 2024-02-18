//
//  RepsView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 18/02/2024.
//

import SwiftUI

struct RepsView: View {
    
    @Environment(\.modelContext) private var context
    
    let displayProgression: Progression
    let level: Level
    let saveAction: (_ progression: Progression, _ level: Level, _ reps: Int) -> Void
    
    @State private var reps: Int = 0
    @State private var isSavingExercise = false
    @State private var savingTask: Task<Void, Error>?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    decrementReps()
                } label: {
                    Image(systemName: "minus.circle")
                }
                .foregroundColor(.themeColor)
                .tint(.themeColor)
                .font(.system(size: 48))
                .controlSize(.large)
                .buttonRepeatBehavior(.enabled)
                VStack {
                    Text("\(reps)")
                        .font(.system(size: 64).bold())
                        .padding(.top, -10)
                        .padding(.bottom, -15)
                        .contentTransition(.numericText())
                    if displayProgression.showSecondsForReps == true {
                        Text("\(reps > 1 ? "seconds" : "second")")
                    } else {
                        Text("\(reps > 1 ? "reps" : "rep")")
                    }
                }
                .frame(width: 125)
                Button {
                    incrementReps()
                } label: {
                    Image(systemName: "plus.circle")
                }
                .foregroundColor(.themeColor)
                .tint(.themeColor)
                .font(.system(size: 48))
                .controlSize(.large)
                .buttonRepeatBehavior(.enabled)
                Spacer()
            }
            .padding(.bottom)
        }
        .presentationDragIndicator(.automatic)
        .onAppear {
            reps = displayProgression.getReps(for: level)
        }

        if !isSavingExercise {
            Button {
                savingTask = Task {
                    withAnimation {
                        isSavingExercise = true
                    }
                    try await Task.sleep(for: .seconds(2))
                    saveAction(displayProgression, level, reps)
                    withAnimation {
                        isSavingExercise = false
                    }
                }
            } label: {
                let TextView = displayProgression.showSecondsForReps == true
                ? Text("Log ^[\(reps) second](inflect: true)")
                : Text("Log ^[\(reps) rep](inflect: true)")
                
                TextView
                    .contentTransition(.numericText())
            }
            .foregroundColor(.white)
            .tint(.themeColor)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } else {
            Text("Saving...")
                .font(.title)
            Button("Cancel") {
                isSavingExercise = false
                savingTask?.cancel()
            }
            .tint(.themeColor)
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }
    
    func incrementReps() {
        if reps < 999 {
            withAnimation {
                reps += 1
            }
        }
    }
    
    func decrementReps() {
        if reps > 1 {
            withAnimation {
                reps -= 1
            }
        }
    }
}

#Preview {
    func saveAction(_: Progression, _: Level, _: Int) {}
    return RepsView(
        displayProgression: Progression.defaultProgression,
        level: .beginner,
        saveAction: saveAction
    )
}
