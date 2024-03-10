//
//  SwiftUIView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 06/02/2024.
//

import SwiftUI

// Load one of the icons by exerciseType.rawValue

// Load scene: basemodel, and apply "animation" file (with one frame)

struct Icon: View {
    
    let exerciseTypeAnimationFile: [ExerciseType: String] = [
        .bridge: "bridge-pose",
        .pushup: "pushup-05",
        .handstandpushup: "hspu--05",
        .legraise: "legraise-pose-anim",
        .squat: "squat-pose",
        .pullup: "pullup-05"
    ]
    
    var calculatedOffsets: CGSize {
        switch exerciseType {
        case .legraise: return CGSize(width: -(size * 0.133), height: -(size * 0.0333))
        case .squat: return CGSize(width: -(size * 0.0333), height: -(size * 0.133))
        case .pullup: return CGSize(width: 0.0, height: -(size * 0.066))
        default: return CGSize()
        }
    }
    
    let exerciseType: ExerciseType
    let stage: Int
    let size: CGFloat
    let score: Double
    let complete: Bool
    
    var body: some View {
        let name = exerciseTypeAnimationFile[exerciseType] ?? "pushup-05"
        ZStack {
            CircularProgressView(
                progress: score,
                size: size * 0.6,
                bgColor: .gray,
                highlightColor: complete ? .gray.opacity(0.5) : Color.themeColor,
                active: true
            )
            AnimationView(progressionAnimationName: name, height: size, isPaused: true)
                .grayscale(complete ? 1 : 0.5)
                .contrast(1.5)
                .offset(calculatedOffsets)
        }
        .frame(width: size, height: size)
    }
}

#Preview("Comparison") {
    ScrollView {
        HStack {
            VStack {
                Icon(exerciseType: .bridge, stage: 1, size: 100, score: 0.5, complete: false)
                Icon(exerciseType: .pushup, stage: 2, size: 100, score: 0.5, complete: false)
                Icon(exerciseType: .handstandpushup, stage: 3, size: 100, score: 0.5, complete: false)
                Icon(exerciseType: .legraise, stage: 4, size: 100, score: 0.5, complete: false)
                Icon(exerciseType: .squat, stage: 5, size: 100, score: 0.5, complete: false)
                Icon(exerciseType: .pullup, stage: 6, size: 100, score: 0.5, complete: false)
            }
            VStack {
                Icon(exerciseType: .bridge, stage: 1, size: 100, score: 0.5, complete: true)
                Icon(exerciseType: .pushup, stage: 2, size: 100, score: 0.5, complete: true)
                Icon(exerciseType: .handstandpushup, stage: 3, size: 100, score: 0.5, complete: true)
                Icon(exerciseType: .legraise, stage: 4, size: 100, score: 0.5, complete: true)
                Icon(exerciseType: .squat, stage: 5, size: 100, score: 0.5, complete: true)
                Icon(exerciseType: .pullup, stage: 6, size: 100, score: 0.5, complete: true)
            }
        }
        .frame(width: .infinity)
    }
}

#Preview("App Icon") {
    Icon(
        exerciseType: .pushup,
        stage: 6,
        size: 1024,
        score: 0.5,
        complete: true
    )
        .background(Color.darkBg)
}
