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
                        ExerciseStagePicker(selectedOption: $pushupStageSelectedOption, exerciseType: ExerciseType.pushup.rawValue)
                        ExerciseStagePicker(selectedOption: $pullupStageSelectedOption, exerciseType: ExerciseType.pullup.rawValue)
                        ExerciseStagePicker(selectedOption: $squatStageSelectedOption, exerciseType: ExerciseType.squat.rawValue)
                        ExerciseStagePicker(selectedOption: $bridgeStageSelectedOption, exerciseType: ExerciseType.bridge.rawValue)
                        ExerciseStagePicker(selectedOption: $legraiseStageSelectedOption, exerciseType: ExerciseType.legraise.rawValue)
                        ExerciseStagePicker(selectedOption: $handstandpushupStageSelectedOption, exerciseType: ExerciseType.handstandpushup.rawValue)
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
}

#Preview {
    UserView()
}
