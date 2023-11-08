import SwiftUI
import SwiftData
import Foundation

struct ExerciseDetailView: View {
    
    // TODO
    // Show a confirmation when exercise entered, with option to progress or regress if needed
    // Incorporate logic to present the option to progress or step up as a suggestion, manual for now
    // Show a success screen when all exercises done - or return to home view with a success message there?
    // Offer option to record another set even if complete
    // Think about how to allow users to add extra sets of *any* exercise / progression
    @Environment(\.modelContext) private var context
    
    @Binding var showingTodayRoutine: Bool
    @Binding var isWorkoutComplete: Bool
    @Binding var isWorkoutInProgress: Bool

//    @State var reps: Int = 123
    @State var isRecordingSet = false
    @State var currentExerciseId: UUID?
    
    let progression: Progression
    let levelStr: String
    let scrollViewValue: ScrollViewProxy
    let exerciseId: UUID
    let nextExerciseWithSetsId: UUID
    let nextExerciseId: UUID
    let currentExerciseIndex: Int
    let exerciseIndex: Int
    let journalEntries: [JournalEntry]
    
    var body: some View {
        let level = Level(rawValue: levelStr) ?? .beginner
        let goalReps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        let setsDoneToday = getSetsDone(
            entries: journalEntries,
            forDate: Date(),
            ofType: progression.type
        )
        
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack {
                    ExerciseNameAndRepsView(
                        progression: progression,
                        reps: goalReps
                    )
                    .padding(.top, (geo.size.height / 2) + 80)
                    
                    if setsDoneToday >= sets {
                        Text("All sets done!")
                            .padding(.vertical)
                    }
                    if setsDoneToday >= sets {
                        Button("Record another set") {
                            isRecordingSet = true
                        }
                        .padding(.vertical)
                    } else {
                        Button("Record set \(setsDoneToday + 1) of \(sets)") {
                            isRecordingSet = true
                        }
                        .padding(.vertical)
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isRecordingSet) {
            RecordExerciseView(
                isRecordingSet: $isRecordingSet,
                sets: sets,
                setsDoneToday: setsDoneToday,
                isWorkoutInProgress: isWorkoutInProgress,
                showingTodayRoutine: showingTodayRoutine,
                isWorkoutComplete: isWorkoutComplete,
                progression: progression,
                level: level,
                exerciseId: exerciseId,
                nextExerciseWithSetsId: nextExerciseWithSetsId,
                scrollViewValue: scrollViewValue
            )
        }
        .onAppear {
            currentExerciseId = exerciseId
        }
    }
}

#Preview {
    ScrollViewReader { scrollViewProxy in
        ExerciseDetailView(
            showingTodayRoutine: .constant(true),
            isWorkoutComplete: .constant(true),
            isWorkoutInProgress: .constant(true),
            isRecordingSet: false,
            currentExerciseId: UUID(),
            progression: pullupDataSet[1],
            levelStr: Level.intermediate.rawValue,
            scrollViewValue: scrollViewProxy,
            exerciseId: UUID(),
            nextExerciseWithSetsId: UUID(),
            nextExerciseId: UUID(),
            currentExerciseIndex: 0,
            exerciseIndex: 1,
            journalEntries: [JournalEntry]()
        )
        .modelContainer(DataController.previewContainer)
    }
}
