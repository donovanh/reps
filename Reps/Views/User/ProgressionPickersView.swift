import SwiftUI
import SwiftData

struct ProgressionPickersView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    @State private var selectedProgression: Int = 1
    @State private var selectedLevel: String = Level.beginner.rawValue
    var exerciseType: ExerciseType
    
    var body: some View {
        if let user = users.first {
            VStack {
                Picker(String(localized: exerciseType.localizedStringResource), selection: $selectedProgression) {
                    let progressions = getExercises(ofType: exerciseType)
                    ForEach(progressions, id: \.self) { progression in
                        Text(String(localized: progression.name.rawValue))
                            .tag(progression.stage)
                    }
                }
                .padding(.top, 10)
                .onChange(of: selectedProgression) {
                    saveProgression(exerciseType, stage: selectedProgression)
                    saveLevel(exerciseType, levelStr: Level.beginner.rawValue)
                    selectedLevel = Level.beginner.rawValue
                }
                .onAppear {
                    selectedProgression = user.getStage(forType: exerciseType)
                }
                Picker(String(localized: exerciseType.localizedStringResource), selection: $selectedLevel) {
                    ForEach(Level.allCases, id: \.self) { level in
                        Text(String(localized: level.localizedStringResource))
                            .tag(level.rawValue)
                    }
                }
                .padding(.bottom, 10)
                .pickerStyle(.segmented)
                .onChange(of: selectedLevel) {
                    saveLevel(exerciseType, levelStr: selectedLevel)
                }
                .onAppear {
                    selectedLevel = user.getLevel(forType: exerciseType)
                }
            }
        }
    }
    
    // TODO: Extend model to support these
    
    func saveProgression(_ type: ExerciseType, stage: Int) {
        if let user = users.first {
            user.setStage(forType: type, stage: stage)
            user.setLevel(forType: type, level: Level.beginner.rawValue)
        } else {
            print("No user set when saving")
        }
    }
    
    func saveLevel(_ type: ExerciseType, levelStr: String) {
        if let user = users.first {
            user.setLevel(forType: type, level: levelStr)
        } else {
            print("No user set when saving")
        }
    }

}

#Preview {
    Form {
        ProgressionPickersView(exerciseType: ExerciseType.handstandpushup)
            .modelContainer(DataController.previewContainer)
    }
}
