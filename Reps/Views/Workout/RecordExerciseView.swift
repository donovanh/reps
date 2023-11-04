import SwiftData
import SwiftUI

struct RecordExerciseView: View {
    
    @Environment(\.modelContext) private var context
    
    @State var isRecordingSet: Bool
    @State var sets: Int
    @State var setsDoneToday: Int
    @State var reps: Int
    @State var difficulty: Difficulty
    @State var isWorkoutInProgress: Bool
    @State var showingTodayRoutine: Bool
    @State var isWorkoutComplete: Bool
    
    let progression: Progression
    let exerciseId: UUID
    let nextExerciseWithSetsId: UUID
    let scrollViewValue: ScrollViewProxy
    
    var body: some View {
        VStack {
            Text("I managed...")
            HStack {
                Spacer()
                Button {
                    decrementReps()
                } label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                }
                .buttonRepeatBehavior(.enabled)
                
                Spacer()
                HStack {
                    Text("\(reps)")
                        .font(.system(size: 64))
                    if (progression.showSecondsForReps == true) {
                        Text("seconds")
                    } else {
                        Text("reps")
                    }
                }
                Spacer()
                Button {
                    incrementReps()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                }
                .buttonRepeatBehavior(.enabled)
                Spacer()
            }
            // TODO: Rethink difficulty
//            Text("It was...")
//            Picker("Difficulty level", selection: $difficulty) {
//                ForEach(Difficulty.allCases, id: \.self) { diff in
//                    Text(diff.localizedStringResource)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
            Button("Save") {
                saveSet(setsDoneToday: setsDoneToday, sets: sets)
            }
            .padding()
        }
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.automatic)
    }
    
    func incrementReps() {
        reps += 1
    }
    
    func decrementReps() {
        reps -= 1
    }
    
    func saveSet(setsDoneToday: Int, sets: Int) {
        isRecordingSet = false
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type.rawValue,
                stage: progression.stage,
                reps: reps//,
                //difficulty: difficulty.rawValue
            )
        )
        isWorkoutInProgress = true
        if exerciseId == nextExerciseWithSetsId {
            if setsDoneToday + 1 >= sets {
                // Mark complete
                isWorkoutComplete = true
                showingTodayRoutine = false
            }
        } else {
            withAnimation {
                scrollViewValue.scrollTo(nextExerciseWithSetsId)
            }
        }
    }
}

#Preview {
    ScrollViewReader { scrollViewValue in
        RecordExerciseView(
            isRecordingSet: true,
            sets: 2,
            setsDoneToday: 1,
            reps: 9000,
            difficulty: Difficulty.moderate,
            isWorkoutInProgress: true,
            showingTodayRoutine: true,
            isWorkoutComplete: false,
            progression: pullupDataSet[1],
            exerciseId: UUID(),
            nextExerciseWithSetsId: UUID(),
            scrollViewValue: scrollViewValue
        )
        .modelContainer(DataController.previewContainer)
    }
}
