import SwiftUI

struct LevelOverviewView: View {
     
        @Binding var level: ExperienceLevel
        var showDescription = true
    
        @State private var isShowing = false
        
        var body: some View {
            if showDescription {
                Section {
                    if (level == ExperienceLevel.gettingStarted) {
                        Text("Build a strong foundation, beginning with the fundamental movements to get strong while avoiding injury.")
                    }
                    if (level == ExperienceLevel.intermediate) {
                        Text("You know the basics and you're ready to build stength.")
                    }
                    if (level == ExperienceLevel.advanced) {
                        Text("You've been doing this for a while and you're ready to take it to the next level.")
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal)
            }
            DisclosureGroup("Progressions") {
                let exerciseLevels = stagesByExperienceLevel[level] ?? [:]
                ForEach(exerciseLevels.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { exerciseType, stage in
                    let exercise = Progressions().getProgression(ofType: exerciseType, atStage: stage)
                        HStack {
                            Text(exercise?.name.rawValue ?? "")
                            Spacer()
                            Text(String(localized: exerciseType.localizedStringResource))
                                .font(.caption)
                        }
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
            }
        }
    }

#Preview {
    Form {
        LevelOverviewView(level: .constant(ExperienceLevel.intermediate))
    }
}
