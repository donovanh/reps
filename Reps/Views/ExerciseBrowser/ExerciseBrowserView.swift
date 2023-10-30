//
//  ExerciseBrowserView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 30/10/2023.
//

import SwiftUI

struct ExerciseBrowserView: View {
    
    @State private var selectedExerciseType: ExerciseType = ExerciseType.pushup
    @State private var selectedProgression: Int = 1
    @State private var animationName: String = "pushup-01"
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                AnimationView(
                    baseModel: "base-model",
                    currentProgressionAnimationName: animationName,
                    currentExerciseIndex: 1,
                    width: geo.size.width,
                    height: geo.size.width
                )
                .onAppear {
                    setAnimationName()
                }
                Form {
                    VStack {
                        Picker("Exercise Type", selection: $selectedExerciseType) {
                            ForEach(ExerciseType.allCases, id: \.self) { exercise in
                                Text(exercise.localizedStringResource)
                                    .tag(exercise)
                            }
                        }
                        .onChange(of: selectedExerciseType) {
                            selectedProgression = 1
                            setAnimationName()
                        }
                        Picker("Progression", selection: $selectedProgression) {
                            let progressions = getExercises(ofType: selectedExerciseType.rawValue)
                            ForEach(progressions, id: \.self) { progression in
                                Text(String(localized: progression.name.rawValue))
                                    .tag(progression.stage)
                            }
                        }
                        .onChange(of: selectedProgression) {
                            setAnimationName()
                        }
                    }
                }
            }
        }
    }
    
    func setAnimationName() {
        let progression = getExercise(ofType: selectedExerciseType.rawValue, atStage: selectedProgression)
        animationName = progression?.animationFileName ?? "pushup-01"
    }
}

#Preview {
    ExerciseBrowserView()
}
