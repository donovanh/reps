import SwiftUI
import SwiftData

struct ExerciseListItemView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    var exercise: Exercise

    var body: some View {
        if let user = users.first {
            let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type))
            let exerciseName = exercise.type.localizedStringResource
            
            if let progressionName = progression?.name {
                HStack {
                    Text(String(localized: progressionName.rawValue))
                    Spacer()
                    Text(String(localized: exerciseName))
                        .font(.caption)
                }
                
            } else {
                Text("No progression found")
            }
        }
    }
}

#Preview {
    Form {
        ExerciseListItemView(
            exercise: Exercise(id: UUID(), type: .pullup)
        )
        .modelContainer(DataController.previewContainer)
    }
}
