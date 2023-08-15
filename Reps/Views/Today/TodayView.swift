//
//  TodayView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 03/08/2023.
//

import SwiftUI
import SwiftData

/*
 TODO
 - Progression: mechanism for moving to the next difficulty level, then next stage
 - Fixture journal data to set up and easily test progression mechanism
 - Look into bug for when opening specific exercise from Today view the first in the list shows
 - Maybe show progress here in terms of how much along they are to being levelled up
 */

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @Query private var users: [User]
    @Query private var journalEntries: [JournalEntry]
    
    @State var todayExercises: [Exercise] = []
    @State private var showingPlanBuilder = false
    @State private var showingTodayRoutine = false
    @State private var showingSettingsSheet = false
    
    @State private var isWorkoutInProgress = false
    @State private var isWorkoutComplete = false
    @State private var currentExerciseId: UUID?
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    if let user = users.first {
                        VStack {
                            if todayExercises.count > 0 {
                                ForEach(todayExercises, id: \.self) { exercise in
                                    let level = user.getLevel(forType: exercise.type)
                                    let sets = getSets(forExerciseType: exercise.type)
                                    let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
                                    if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                                        ExerciseItemView(
                                            progression: progression,
                                            exerciseType: ExerciseType(rawValue: exercise.type) ?? .bridge, levelStr: level,
                                            setsDone: setsDone
                                        )
                                        .onTapGesture {
                                            currentExerciseId = exercise.id
                                            showingTodayRoutine = true
                                        }
                                        .onAppear {
                                            if setsDone < sets {
                                                currentExerciseId = exercise.id
                                            }
                                            if setsDone > 0 {
                                                isWorkoutInProgress = true
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                if isWorkoutComplete != true {
                                    Button(isWorkoutInProgress ? "Continue Workout" : "Start Workout") {
                                        if isWorkoutInProgress == true {
                                            for exercise in todayExercises {
                                                let sets = getSets(forExerciseType: exercise.type)
                                                let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
                                                if setsDone < sets {
                                                    currentExerciseId = exercise.id
                                                    break
                                                }
                                            }
                                        }
                                        showingTodayRoutine = true
                                    }
                                    .padding()
                                } else {
                                    Text("You're all done for today!")
                                    Button("Do more") {
                                        currentExerciseId = todayExercises.first?.id
                                        showingTodayRoutine = true
                                    }
                                    .padding()
                                }
                            } else {
                                if routines.count == 0 {
                                    Button("Set up a new routine") {
                                        showingPlanBuilder = true
                                    }
                                } else {
                                    Text("Rest day")
                                        .font(.largeTitle)
                                    Text("Maybe go for a walk!")
                                }
                            }
                        }
                        .navigationTitle("Your Day: \(getDayName(forDate: Date()))")
                        .toolbar {
                            Button {
                                showingSettingsSheet = true
                            } label: {
                                Label("User Profile", systemImage: "person.crop.circle")
                            }
                        }
                    } else {
                        Text("New user")
                    }
                }
            }
            .sheet(isPresented: $showingPlanBuilder) {
                PlanBuilderView(showingPlanBuilder: $showingPlanBuilder)
            }
            .sheet(isPresented: $showingTodayRoutine) {
                WorkoutView(
                    showingTodayRoutine: $showingTodayRoutine,
                    isWorkoutComplete: $isWorkoutComplete,
                    isWorkoutInProgress: $isWorkoutInProgress,
                    currentExerciseId: currentExerciseId,
                    todayExercises: todayExercises,
                    screenWidth: geo.size.width
                )
            }
            .sheet(isPresented: $showingSettingsSheet) {
                UserView()
            }
            .onAppear {
                isWorkoutInProgress = false
                if users.isEmpty {
                    initUser()
                }
                if routines.isEmpty {
                    applyEmptySchedule()
                }
                todayExercises = getTodayExercises()
                isWorkoutComplete = checkIsWorkoutComplete(todayExercises: todayExercises)
            }
        }
    }
    
    func getDayName(forDate date: Date) -> String {
        let calendar = Calendar.current
        let dayNum = calendar.component(.weekday, from: date)
        let f = DateFormatter()
        return f.weekdaySymbols[dayNum - 1]
    }
    
    func getTodayExercises() -> [Exercise] {
        let currentDate = Date()
        let calendar = Calendar.current
        let dayNum = calendar.component(.weekday, from: currentDate)
        let routine = getRoutine(forDay: dayNum, fromRoutines: routines)
        return routine.exercises
    }
    
    func initUser() {
        let user = DefaultUser
        context.insert(user)
    }
    
    func applyEmptySchedule() {
        for dayNum in 1...7 {
            let newRoutine = Routine(day: dayNum, exercises: [])
            context.insert(newRoutine)
        }
    }
    
    func getSets(forExerciseType type: String) -> Int {
        if let user = users.first {
            if let progression = getExercise(ofType: type, atStage: user.getStage(forType: type)) {
                let levelStr = user.getLevel(forType: type)
                return progression.getSets(for: Level(rawValue: levelStr) ?? .beginner)
            }
        }
        return 0
    }
    
    func checkIsWorkoutComplete(todayExercises: [Exercise]) -> Bool {
        for exercise in todayExercises {
            let sets = getSets(forExerciseType: exercise.type)
            let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
            if setsDone < sets {
                return false
            }
        }
        return true
    }
}

//#Preview {
//    TodayView()
//}
