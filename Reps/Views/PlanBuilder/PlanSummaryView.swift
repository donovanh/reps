import SwiftUI

struct PlanOverviewView: View {
    
    @Binding var schedule: Schedule
    @Binding var level: ExperienceLevel
    
    var body: some View {
        Text("Apply this plan")
            .font(.title)
        Text("Level: \(level.rawValue)")
        Text("Schedule: \(schedule.rawValue)")
        Text("Note: You can adjust these as needed in your weekly overview.")
    }
}

#Preview {
    Form {
        PlanOverviewView(
            schedule: .constant(Schedule.advancedPushPullSchedule),
            level: .constant(ExperienceLevel.intermediate)
        )
    }
}
