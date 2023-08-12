//
//  ExerciseView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/08/2023.
//

import SwiftUI
import SwiftData

struct ExercisesView: View {
    
    @Environment(\.modelContext) private var context
    // @Query private var routines: [Routine]
    @Query private var users: [User]
    
    var todayExercises: [Exercise]
    
    var body: some View {
        if let user = users.first {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(todayExercises, id: \.self) { exercise in
                            let level = user.getLevel(forType: exercise.type)
                            if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                                ExerciseView(
                                    progression: progression,
                                    exerciseType: ExerciseType(rawValue: exercise.type) ?? .bridge, levelStr: level
                                )
                                .background(.cyan)
                                .frame(width: geo.size.width, height: 400)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 40)
            }
            
        }
    }
}

//#Preview {
//    ExercisesView()
//}
