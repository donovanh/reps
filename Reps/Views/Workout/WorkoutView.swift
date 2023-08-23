//
//  ExerciseView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 12/08/2023.
//

import SwiftUI
import SwiftData
import Combine
import SceneKit

struct AnimationView: View {
    
    let currentProgressionAnimationName: String
    let currentExerciseIndex: Int
    let width: CGFloat
    let height: CGFloat
    
    func loadScene(_ currentProgressionAnimationName: String) -> SCNScene {
        guard let scene = SCNScene(named: currentProgressionAnimationName) else {
            print("Scene could not be loaded")
            return SCNScene()
        }
        
        // Set up an other scene from which to load the animation
//        let sceneURL = Bundle.main.url(forResource: "pushup-01", withExtension: "dae")
//        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        // from https://stackoverflow.com/questions/46209555/scenekit-how-to-get-animations-for-a-dae-model#62594220
        // Blocker: How do I identify the animation in the dae file?
//        if let animationObj = sceneSource?.entryWithIdentifier(animationIdentifier,
//                                                         withClass: CAAnimation.self) {
//            animationObj.repeatCount = 1
//            animationObj.fadeInDuration = CGFloat(1)
//            animationObj.fadeOutDuration = CGFloat(0.5)
//
//            animations[withKey] = animationObj
//        }

        // TODO: Set up background for dark mode support
        // scene.background.contents = UIColor.darkText
        return scene
    }
    
    var body: some View {
        SceneView(scene: loadScene(currentProgressionAnimationName))
        .edgesIgnoringSafeArea(.all)
        .frame(width: width, height: height)
    }
}

struct WorkoutView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var journalEntries: [JournalEntry]
    
    @Binding var showingTodayRoutine: Bool
    @Binding var isWorkoutComplete: Bool
    @Binding var isWorkoutInProgress: Bool
    
    let currentExerciseId: UUID?
    let todayExercises: [Exercise]
    let screenWidth: CGFloat

    @State private var offset = CGFloat.zero
    @State private var scrollWidth = CGFloat.zero
    @State private var currentExerciseIndex: Int = 0
    @State private var currentAnimationOpacity: CGFloat = 1.0
    @State private var currentXOffset: Double = 0.0
    @State private var currentProgressionAnimationName: String?
    
    var body: some View {
        if let user = users.first {
            GeometryReader { geo in
                ZStack {
                    VStack {
                        // .temporalAntialiasingEnabled, .allowsCameraControl
                        ZStack {
                            AnimationView(
                                currentProgressionAnimationName: currentProgressionAnimationName ?? "pushup-07.dae",
                                currentExerciseIndex: currentExerciseIndex,
                                width: geo.size.width,
                                height: geo.size.width
                            )
                            .opacity(currentAnimationOpacity)
                            .offset(x: currentXOffset, y: 0)
                        }
                        Spacer()
                    }
                    ScrollViewReader { scrollViewValue in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(todayExercises.enumerated()), id: \.1.id) { index, exercise in
                                    let level = user.getLevel(forType: exercise.type)
                                    if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                                        ExerciseDetailView(
                                            showingTodayRoutine: $showingTodayRoutine,
                                            isWorkoutComplete: $isWorkoutComplete,
                                            isWorkoutInProgress: $isWorkoutInProgress,
                                            currentExerciseId: currentExerciseId,
                                            progression: progression,
                                            exerciseType: ExerciseType(rawValue: exercise.type) ?? .bridge, levelStr: level,
                                            scrollViewValue: scrollViewValue,
                                            exerciseId: exercise.id,
                                            nextExerciseWithSetsId: nextExerciseWithSetsId(after: exercise),
                                            nextExerciseId: nextExerciseId(after: exercise),
                                            currentExerciseIndex: currentExerciseIndex,
                                            exerciseIndex: index
                                        )
                                        .id(exercise.id)
                                        .frame(
                                            width: geo.size.width > 40 ? geo.size.width - 40 : geo.size.width,
                                            height: geo.size.height > 80 ? geo.size.height - 80 : geo.size.height
                                        )
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewOffsetKey.self,
                                    value: -$0.frame(in: .named("scroll")).origin.x)
                            })
                            .onPreferenceChange(ViewOffsetKey.self) {
                                currentExerciseIndex = visibleExerciseIndex(forOffset: $0)
                                currentAnimationOpacity = calculateOpacityOfAnimation(forOffset: $0, numberOfExercises: todayExercises.count)
                                currentXOffset = calculateXOffset(forOffset: $0)
                                let exercise = todayExercises[currentExerciseIndex]
                                let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type))
                                currentProgressionAnimationName = progression?.animationFileName
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .onAppear {
                            DispatchQueue.main.async() {
                                scrollViewValue.scrollTo(currentExerciseId)
                            }
                        }
                        
                        Spacer()
                        
                        // Progress Indicator
                        HStack {
                            ForEach(todayExercises.indices, id: \.self) { index in
                                let exercise = todayExercises[index]
                                let status = getProgressIndicatorStatus(forExercise: exercise)
                                Circle()
                                    .fill(status == "complete" ? .green : .gray)
                                    .opacity(currentExerciseIndex == index ? 1 : 0.3)
                                    .frame(width: 10)
                                    .padding(2)
                            }
                        }
                        .padding(.bottom)
                        Button("Close") {
                            showingTodayRoutine = false
                        }
                    }
                }
            }
            .onAppear {
                setScrollWidth()
            }
        }
    }
    
    func setScrollWidth() {
        scrollWidth = screenWidth * CGFloat(todayExercises.count)
    }
    
    func visibleExerciseIndex(forOffset offset: CGFloat) -> Int {
        return Int((offset / screenWidth).rounded(.toNearestOrAwayFromZero))
    }
    
    func calculateOpacityOfAnimation(forOffset offset: CGFloat, numberOfExercises: Int) -> Double {
        let maxWidth = screenWidth * CGFloat(numberOfExercises - 1)

        if offset < 0 || offset > maxWidth {
            return 1
        }
        let index = visibleExerciseIndex(forOffset: offset)
            
        let nearestIndexOffset = CGFloat(index) * screenWidth // Calculate the offset of the nearest index
 
        let distance = abs(offset - nearestIndexOffset) // Calculate the distance from that offset value
        
        let halfScreenWidth = screenWidth / 2
        let opacity = 1 - Double(min(distance, halfScreenWidth)) / Double(halfScreenWidth)
        
        return max(opacity, 0) // Ensure opacity is not negative
    }
    
    func calculateXOffset(forOffset offset: CGFloat) -> Double {
        // print("offset: \(offset), screenWidth: \(screenWidth)")
        let index = visibleExerciseIndex(forOffset: offset)
        let nearestIndexOffset = CGFloat(index) * screenWidth // Calculate the offset of the nearest index
        let distance = offset - nearestIndexOffset // Calculate the distance from that offset value
        
        return (0 - distance / 3)
    }
    
    func nextExerciseWithSetsId(after exercise: Exercise) -> UUID {
        // Returns next exercise with unfinished sets, if any
        // Otherwise just next exercise (looping back to start if end)
        let currentIndex = todayExercises.firstIndex(of: exercise) ?? 0
        let exercisesCount = todayExercises.count
        
        for offset in 1..<exercisesCount {
            let nextIndex = (currentIndex + offset) % exercisesCount
            let nextExercise = todayExercises[nextIndex]
            let setsDone = getSetsDone(
                entries: journalEntries,
                forDate: Date(),
                ofType: nextExercise.type
            )
            
            if let user = users.first {
                if let progression = getExercise(ofType: nextExercise.type, atStage: user.getStage(forType: nextExercise.type)) {
                    let levelStr = user.getLevel(forType: exercise.type)
                    let level = Level(rawValue: levelStr) ?? .beginner
                    let sets = progression.getSets(for: level)
                    if setsDone < sets {
                        return nextExercise.id
                    }
                }
            }
            
        }
        
        return todayExercises[currentIndex].id // Returning current exercise
    }
    
    func nextExerciseId(after exercise: Exercise) -> UUID {
        let currentIndex = todayExercises.firstIndex(of: exercise) ?? 0
        let exercisesCount = todayExercises.count
        let nextIndex = (currentIndex + 1) % exercisesCount
        let nextExercise = todayExercises[nextIndex]
        return nextExercise.id
    }
    
    func getProgressIndicatorStatus(forExercise exercise: Exercise) -> String {
        let setsDone = getSetsDone(
            entries: journalEntries,
            forDate: Date(),
            ofType: exercise.type
        )
        
        if let user = users.first {
            if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                let levelStr = user.getLevel(forType: exercise.type)
                let level = Level(rawValue: levelStr) ?? .beginner
                let sets = progression.getSets(for: level)
                if setsDone < sets {
                    return "incomplete"
                }
            }
        }
        
        return "complete"
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

//#Preview {
//    ExercisesView()
//}
