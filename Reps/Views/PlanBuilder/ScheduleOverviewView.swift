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
        ForEach(1...7, id: \.self) { day in
            let dayExercises = schedule[day] ?? []
            let f = DateFormatter()
            let dayString = f.weekdaySymbols[day - 1]
            if dayExercises.count > 0 {
                let exerciseListStrings = exerciseListStrings(dayExercises)
                HStack {
                    Text(ListFormatter.localizedString(byJoining: exerciseListStrings))
                    Spacer()
                    Text(dayString)
                        .font(.caption2)
                        .padding(.leading)
                }
            }
        }
    }
    
    func exerciseListStrings(_ dayExercises: [ExerciseType]) -> [String] {
        var updatedExercises = dayExercises
        if (experienceLevelOption == ExperienceLevel.gettingStarted) {
            updatedExercises.removeAll { $0 == .handstandpushup }
        }
        return updatedExercises.map({ exerciseType in
            String(localized: exerciseType.localizedStringResource)
        })
    }
}

#Preview {
    Form {
        ScheduleOverviewView(
            scheduleOption: .constant(Schedule.advancedPushPullSchedule),
            experienceLevelOption: .constant(ExperienceLevel.intermediate)
        )
    }
}
