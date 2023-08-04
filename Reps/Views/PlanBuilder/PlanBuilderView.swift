//
//  PlanBuilderView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 27/07/2023.
//

import SwiftUI
import SwiftData

struct PlanBuilderView: View {
    
    // TODO: Builder that has options for experience level
    // It should note that this will replace the current plan
    
    // When building plan, preserve progression level if stage doesn't change
    // Nice to have: Store the previous plan and an option to revert it after applying the new plan
    // Levels:
    // Beginner - start at start and hold off handstand progressions?
    // Enthusiast - you know your way around a pushup or two, but would like guidance on how to get really good
    // Advanced - choose your own starting level for each exercise
    // Have a way to skip the weekly plan with "Keep current week" or "Don't plan my week" depending on if a plan exists
    
    @Binding var showingPlanBuilder: Bool
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @Query private var users: [User]
    
    @State private var formStep: Int = 1
    @State private var experienceLevelOption: ExperienceLevel = ExperienceLevel.gettingStarted
    @State private var scheduleOption: Schedule = Schedule.defaultSchedule
    
    var body: some View {
        VStack {
            Form {
                if formStep == 1 {
                    Section("Progression level") {
                        Picker("Choose your progression level", selection: $experienceLevelOption) {
                            ForEach(ExperienceLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                    LevelOverviewView(level: $experienceLevelOption)
                    Button("Choose a schedule") {
                        formStep = 2
                    }
                }
                if formStep == 2 {
                    Section("Schedule") {
                        Picker("Choose your weekly plan", selection: $scheduleOption) {
                            ForEach(Schedule.allCases, id: \.self) { schedule in
                                Text(schedule.rawValue).tag(schedule)
                            }
                        }
                    }
                    ScheduleOverviewView(scheduleOption: $scheduleOption, experienceLevelOption: $experienceLevelOption)
                    Section {
                        Button("Next") {
                            formStep = 3
                        }
                    }
                }
                if formStep == 3 {
                    Section("Apply new plan") {
                        PlanOverviewView(level: $experienceLevelOption, schedule: $scheduleOption)
                        Button("Apply this plan") {
                            applyPlan()
                        }
                    }
                }
            }
            .navigationTitle("Plan Builder")
            Spacer()
            Button("Cancel") {
                showingPlanBuilder = false
            }
        }
    }
    
    func clearRoutines(_ routines: [Routine]) {
        for routine in routines {
            context.delete(routine)
        }
    }
    
    func applyPlan() {
        let schedule = schedules[scheduleOption] ?? [:]
        if schedule.count > 0 {
            for (day, exercises) in schedule {
                var dayExercises: [Exercise] = []
                for exerciseType in exercises {
                    if !(experienceLevelOption == .gettingStarted && exerciseType == .handstandpushup) {
                        dayExercises.append(Exercise(id: UUID(), type: exerciseType.rawValue))
                    }
                }
                 if let index = routines.firstIndex(where: { $0.day == day.rawValue }) {
                     routines[index].exercises = dayExercises
                 } else {
                     let newRoutine = Routine(day: day.rawValue, exercises: dayExercises)
                     context.insert(newRoutine)
                 }
            }
        }
        
        if users.first == nil {
            context.insert(DefaultUser)
        }
        // Empty existing routines
        let user = users.first ?? DefaultUser
        
        let exerciseStages = stages[experienceLevelOption] ?? [:]
        
        user.pushupStage = exerciseStages[.pushup] ?? 1
        user.pullupStage = exerciseStages[.pullup] ?? 1
        user.squatStage = exerciseStages[.squat] ?? 1
        user.bridgeStage = exerciseStages[.bridge] ?? 1
        user.legraiseStage = exerciseStages[.legraise] ?? 1
        user.handstandpushupStage = exerciseStages[.handstandpushup] ?? 1

        showingPlanBuilder = false
    }
}

//#Preview {
//    PlanBuilderView()
//}
