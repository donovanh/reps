import SwiftData
import SwiftUI

struct RecordExerciseView: View {
    
    // TODO: Repurpose this to control two sub-views
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    @Binding var isRecordingSet: Bool
    @State var sets: Int
    @State var setsDoneToday: Int
    @State var reps: Int
    @State var difficulty: Difficulty
    @State var isWorkoutInProgress: Bool
    @State var showingTodayRoutine: Bool
    @State var isWorkoutComplete: Bool
    
    let progression: Progression
    let level: Level
    let exerciseId: UUID
    let nextExerciseWithSetsId: UUID
    let scrollViewValue: ScrollViewProxy
    
    @State private var isShowingConfirmation = false
    @State private var isShowingNewProgressionDetails = false
    
    var body: some View {
        if isShowingConfirmation == true {
            let goalReps = progression.getReps(for: level)
            VStack {
                Text("Confirmation view")
                if reps >= goalReps {
                    if progressionHasNextLevel(for: progression, at: level) {
                        let nextLevel = getNextLevel(for: progression, at: level)
                        Text("Ready to go to the next level?")
                        Button {
                            setLevel(progression.type, levelStr: level.rawValue)
                            isShowingNewProgressionDetails = true
                        } label: {
                            Text("Progress to next level")
                        }
                    } else if progressionHasNextStage(for: progression) {
                        let nextStage = getNextStage(for: progression)
                        Text("Ready to go to the next stage?")
                        Button {
                            setProgression(progression.type, stage: nextStage)
                            isShowingNewProgressionDetails = true
                        } label: {
                            Text("Progress to next stage")
                        }
                    }
                }
                Spacer()
                Button("Next") {
                    goToNext()
                }
            }
            .onAppear {
                if progressionHasPreviousLevel(for: progression, at: level) {
                    print("Has previous level")
                }
                if progressionHasPreviousStage(for: progression) {
                    print("Has previous stage")
                }
                if progressionHasNextLevel(for: progression, at: level) {
                    print("Has Next level")
                }
                if progressionHasNextStage(for: progression) {
                    print("Has Next stage")
                }
            }
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.automatic)
        } else {
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
                Spacer()
                Button("Save") {
                    saveSet(setsDoneToday: setsDoneToday, sets: sets)
                    isShowingConfirmation = true
                }
                .padding()
            }
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.automatic)
        }
    }
    
    func incrementReps() {
        reps += 1
    }
    
    func decrementReps() {
        reps -= 1
    }
    
    // --------- //
    // TODO: Move this logic to the Exercise model
    
    func progressionHasPreviousLevel(for progression: Progression, at level: Level) -> Bool {
        return level != Level.beginner
    }
    
    func progressionHasPreviousStage(for: Progression) -> Bool {
        return progression.stage > 1
    }
    
    func getPreviousLevel(for: Progression, at level: Level) -> Level {
        switch level {
            case Level.beginner: return Level.beginner
            case Level.intermediate: return Level.beginner
            case Level.progression: return Level.intermediate
        }
    }
    
    func getPreviousStage(for: Progression) -> Int {
        return progression.stage > 1 ? progression.stage - 1 : 1
    }
    
    func progressionHasNextLevel(for: Progression, at: Level) -> Bool {
        return level != Level.progression
    }
    
    func progressionHasNextStage(for: Progression) -> Bool {
        return progression.stage < 10
    }
    
    func getNextLevel(for: Progression, at: Level) -> Level {
        switch level {
            case Level.beginner: return Level.intermediate
            case Level.intermediate: return Level.progression
            case Level.progression: return Level.progression
        }
    }
    
    func getNextStage(for: Progression) -> Int {
        return progression.stage > 10 ? progression.stage + 1 : 10
    }
    
    // --------- //
    
    func setProgression(_ type: ExerciseType, stage: Int) {
        if let user = users.first {
            user.setStage(forType: type, stage: stage)
            user.setLevel(forType: type, level: Level.beginner.rawValue)
        } else {
            print("No user set when saving")
        }
    }
    
    func setLevel(_ type: ExerciseType, levelStr: String) {
        if let user = users.first {
            user.setLevel(forType: type, level: levelStr)
        } else {
            print("No user set when saving")
        }
    }
    
    func saveSet(setsDoneToday: Int, sets: Int) {
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type.rawValue,
                stage: progression.stage,
                reps: reps//,
                //difficulty: difficulty.rawValue
            )
        )
    }
    
    func goToNext() {
        isWorkoutInProgress = true // TODO: needed?
        isRecordingSet = false
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
            isRecordingSet: .constant(true),
            sets: 2,
            setsDoneToday: 1,
            reps: 9000,
            difficulty: Difficulty.moderate, // TODO: remove perhaps
            isWorkoutInProgress: true,
            showingTodayRoutine: true,
            isWorkoutComplete: false,
            progression: pullupDataSet[5],
            level: Level.intermediate,
            exerciseId: UUID(),
            nextExerciseWithSetsId: UUID(),
            scrollViewValue: scrollViewValue
        )
        .modelContainer(DataController.previewContainer)
    }
}
