//
//  ExerciseView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/08/2023.
//

import SwiftUI

struct ExerciseView: View {
    
    var progression: Progression
    var exerciseType: ExerciseType
    var levelStr: String
    
    var body: some View {
        let level = Level(rawValue: levelStr) ?? .beginner
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        
        VStack {
            Text(String(localized: progression.name.rawValue))
                .font(.title)
                .padding(.top, 10)
            
            Text(String(localized: exerciseType.localizedStringResource))
                .font(.caption)
            if (progression.showSecondsForReps == true) {
                Text("\(sets) x \(reps) seconds")
            } else {
                Text("\(sets) x \(reps) reps")
            }
        }
    }
}

//#Preview {
//    ExerciseView()
//}
