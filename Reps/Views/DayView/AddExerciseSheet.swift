//
//  AddExerciseSheet.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import SwiftUI

struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: DayView.ViewModel
    let day: Int

    var body: some View {
        let workoutSchedule = viewModel.weeklySchedule[day] ?? []
        ForEach(ExerciseType.allCases, id: \.self) { exerciseType in
            if !workoutSchedule.contains(exerciseType) {
                Button(String(localized: exerciseType.localizedStringResource)) {
                    viewModel.addExerciseType(for: exerciseType, forDay: day)
                }
            }
        }
    }
}

#Preview {
    AddExerciseSheet(viewModel: DayView.ViewModel(), day: 2)
}
