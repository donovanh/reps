//
//  ScheduleOverviewView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/08/2023.
//

import SwiftUI

struct ScheduleOverviewView: View {
    
    @Binding var scheduleOption: Schedule
    @Binding var experienceLevelOption: ExperienceLevel
    
    
    var body: some View {
        Section {
            if scheduleOption == Schedule.defaultSchedule {
                Text("A solid workout, three times each week. This allows for time for recovery while also ensuring progress.")
            }
            
            if scheduleOption == Schedule.intermediateSchedule {
                Text("A plan that allows you to focus on alternately pushing and pulling, broken up into four workouts per week.")
            }
            
            if scheduleOption == Schedule.advancedPushPullSchedule {
                Text("A heavier workout routine, focusing on alternate pushing and pulling days.")
            }
            
            if scheduleOption == Schedule.advancedUpperLowerSchedule {
                Text("A heavier workout routine, with alternating days focusing on upper and lower body exercises.")
            }
        }
        let schedule = schedules[scheduleOption] ?? [:]
        ForEach(DayOfWeek.allCases, id: \.self) { day in
            let dayExercises = schedule[day] ?? []
            if dayExercises.count > 0 {
                let exerciseListString = createExerciseString(dayExercises)
                HStack {
                    Text(exerciseListString)
                        .font(.caption)
                    Spacer()
                    Text(day.rawValue)
                        .font(.caption2)
                        .padding(.leading)
                }
            }
        }
    }
    
    func createExerciseString(_ dayExercises: [ExerciseType]) -> String {
        var updatedExercises = dayExercises
        if (experienceLevelOption == ExperienceLevel.gettingStarted) {
            updatedExercises.removeAll { $0 == .handstandpushup }
        }
        let exerciseTypeRawValues = updatedExercises.map { $0.rawValue }
        return exerciseTypeRawValues.joined(separator: ", ")
    }
}

//#Preview {
//    ScheduleOverviewView()
//}
