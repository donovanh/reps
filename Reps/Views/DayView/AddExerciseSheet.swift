//
//  AddExerciseSheet.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import SwiftUI

struct AddExerciseSheet: View {
    @Environment(\.dismiss) var dismiss
    let workout: ExerciseTypesByDay

    var body: some View {
        ForEach(ExerciseType.allCases, id: \.self) { exerciseType in
            if !workout.exerciseTypes.contains(exerciseType) {
                Button(String(localized: exerciseType.localizedStringResource)) {
                    workout.addExerciseType(type: exerciseType)
                }
            }
        }
    }
}

#Preview {
    AddExerciseSheet(workout: ExerciseTypesByDay(day: 5))
}
