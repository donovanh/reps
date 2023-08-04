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
 - Set out today's routine, with a check indicator for if each exercise is done
 - Start / Continue button
 - Sheet overlay with the exercise and a "Done" option (or enter reps / time option fallback)
 - Maybe a skip button to skip a certain exercise
 - Each done exercise put into database for this date as an exercise done. Noting date/time done, exercise type, stage, level, reps or time
 - At end of routine, if all done, congrats
 - Maybe show progress here in terms of how much along they are to being levelled up
 */

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @Query private var users: [User]
    
    @State var todayExercises: [Exercise] = []
    @State private var showingPlanBuilder = false
    
    var body: some View {
        VStack {
            if let user = users.first {
                VStack(alignment: .leading) {
                    Text("Your Day")
                        .font(.largeTitle)
                    if todayExercises.count > 0 {
                        ForEach(todayExercises, id: \.self) { exercise in
                            let level = user.getLevel(forType: exercise.type)
                            if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                                ExerciseView(progression: progression, exerciseType: exercise.type, levelStr: level)
                            }
                        }
                    } else {
                        if routines.count == 0 {
                            Button("Set up a new routine") {
                                showingPlanBuilder = true
                            }
                        } else {
                            Text("Rest day! Maybe go for a walk.")
                        }
                    }
                }
            } else {
                Text("New user")
            }
        }
        .sheet(isPresented: $showingPlanBuilder) {
            PlanBuilderView(showingPlanBuilder: $showingPlanBuilder)
        }
        .onAppear {
            todayExercises = getTodayExercises()
            if users.isEmpty {
                initUser()
            }
        }
    }
    
    func getTodayExercises() -> [Exercise] {
        let currentDate = Date()
        let calendar = Calendar.current
        let dayNum = calendar.component(.day, from: currentDate)
        let currentDayOfWeek = DayOfWeek.allCases[dayNum]
        let routine = getRoutine(forDay: currentDayOfWeek.rawValue, fromRoutines: routines)
        return routine.exercises
    }
    
    func initUser() {
        print("First use")
        let user = DefaultUser
        context.insert(user)
    }
}

struct ExerciseView: View {
    
    var progression: Progression
    var exerciseType: String
    var levelStr: String
    
    var body: some View {
        let level = Level(fromString: levelStr) ?? .beginner
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        
        VStack(alignment: .leading) {
            Text(progression.name)
                .font(.title)
                .accessibility(label: Text("Exercise Name: \(progression.name)"))
                .padding(.top, 10)
            
            Text(exerciseType)
                .font(.caption)
                .accessibility(label: Text("Exercise Type: \(exerciseType)"))
            
            Text("\(sets) x \(reps) \(progression.showSecondsForReps == true ? "seconds" : "reps")")
        }
    }
}

//#Preview {
//    TodayView()
//}
