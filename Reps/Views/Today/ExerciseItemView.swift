//
//  ExerciseView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 08/08/2023.
//

import SwiftUI

struct ExerciseItemView: View {
    
    let progression: Progression
    let exerciseType: ExerciseType
    let levelStr: String
    let setsDone: Int
    
    var body: some View {
        let level = Level(rawValue: levelStr) ?? .beginner
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        
        HStack {
            VStack(alignment: .leading) {
                Text(String(localized: progression.name.rawValue))
                    .font(.title)
                
                Text(String(localized: exerciseType.localizedStringResource))
                    .font(.caption)
            }
            
            Spacer()
            
            if (progression.showSecondsForReps == true) {
                Text("\(sets) x \(reps) seconds")
            } else {
                Text("\(sets) x \(reps) reps")
            }
            
            if (setsDone >= sets) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio (contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: 20)
                }
            } else {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio (contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 20)
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    ExerciseView()
//}
