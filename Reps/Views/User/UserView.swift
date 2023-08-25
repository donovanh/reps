//
//  UserSettingsView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 25/07/2023.
//

import SwiftUI
import SwiftData

struct UserView: View {
    
    // TODO: Put in about section with how to get in touch
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var routines: [User]
    @Query private var journalEntries: [JournalEntry]
    
    @State var pushupStageSelectedOption = 1
    @State var pullupStageSelectedOption = 1
    @State var squatStageSelectedOption = 1
    @State var bridgeStageSelectedOption = 1
    @State var legraiseStageSelectedOption = 1
    @State var handstandpushupStageSelectedOption = 1
    
    var body: some View {
        if !users.isEmpty {
            NavigationView {
                Form {
                    Section("Your progressions") {
                        ExerciseStagePicker(selectedOption: $pushupStageSelectedOption, exerciseType: ExerciseType.pushup)
                        ExerciseStagePicker(selectedOption: $pullupStageSelectedOption, exerciseType: ExerciseType.pullup)
                        ExerciseStagePicker(selectedOption: $squatStageSelectedOption, exerciseType: ExerciseType.squat)
                        ExerciseStagePicker(selectedOption: $bridgeStageSelectedOption, exerciseType: ExerciseType.bridge)
                        ExerciseStagePicker(selectedOption: $legraiseStageSelectedOption, exerciseType: ExerciseType.legraise)
                        ExerciseStagePicker(selectedOption: $handstandpushupStageSelectedOption, exerciseType: ExerciseType.handstandpushup)
                    }
                    
                    Section("Admin") {
                        Button("Clear User Data") {
                            clearUser()
                        }
                        Button("Clear Routines") {
                            clearRoutines()
                        }
                        Button("Clear Journal") {
                            clearJournalEntries()
                        }
                    }
                }
                .navigationTitle("Settings")
            }
            .onAppear {
                setupForm()
            }
        }
    }
    
    func setupForm() {
        if let user = users.first {
            pushupStageSelectedOption = user.pushupStage
            pullupStageSelectedOption = user.pullupStage
            squatStageSelectedOption = user.squatStage
            bridgeStageSelectedOption = user.bridgeStage
            legraiseStageSelectedOption = user.legraiseStage
            handstandpushupStageSelectedOption = user.handstandpushupStage
        }
    }
    
    func clearUser() {
        for user in users {
            context.delete(user)
        }
    }
    
    func clearRoutines() {
        for routine in routines {
            context.delete(routine)
        }
    }
    
    func clearJournalEntries() {
        for entry in journalEntries {
            context.delete(entry)
        }
    }
}

//#Preview {
//    UserView()
//}
