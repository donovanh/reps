//
//  ExerciseTypePicker.swift
//  Reps
//
//  Created by Donovan Hutchinson on 26/07/2023.
//

import SwiftUI
import SwiftData

struct ExerciseStagePicker: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @Query private var users: [User]
    
    @Binding var selectedOption: Int
    var exerciseType: String
    
    var body: some View {
        
        Picker(exerciseType, selection: $selectedOption) {
            let progressions = getExercises(ofType: exerciseType)
            ForEach(progressions, id: \.self) { progression in
                Text(progression.name)
                    .tag(progression.stage)
            }
        }
        .onChange(of: selectedOption) {
            saveProgressionStage(exerciseType, stage: selectedOption)
        }
    }
    
    func saveProgressionStage(_ type: String, stage: Int) {
        if let user = users.first {
            user.setStage(forType: type, stage: stage)
        } else {
            print("No user set when saving")
        }
    }

}

//#Preview {
//    ExerciseStagePicker()
//}
