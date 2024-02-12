import SwiftUI

struct PlanOverviewView: View {
    
    @Binding var schedule: Schedule
    @Binding var level: ExperienceLevel
    
    var body: some View {
        VStack {
            Text("Let's add some exercises, at **\(level.rawValue)** level, with an **\(schedule.rawValue)** schedule.")
                .padding()
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
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
