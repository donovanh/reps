import SwiftData
import SwiftUI

struct RecordExerciseView: View {
    
    // TODO: Repurpose this to control two sub-views
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var workoutsByDay: [WorkoutsByDay]
    @Query private var journalEntries: [JournalEntry]
    
    @State var reps: Int = 0
    
    @Binding var isRecordingSet: Bool
    @State var sets: Int
    @State var setsDoneToday: Int
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
    
    // TODO:
    // Summarise what this does for future me
    
    var body: some View {
        if isShowingConfirmation == true {
            let goalReps = progression.getReps(for: level)
            VStack {
                Text("Confirmation view")
                if reps >= goalReps { // TODO: And both sets done!
                    // Offer progression option
                    if progressionHasNextLevel(for: progression, at: level) {
                        let nextLevel = getNextLevel(for: progression, at: level)
                        Text("Ready to go to the next level?")
                        Button {
                            setLevel(progression.type, levelStr: nextLevel.rawValue)
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
                } else {
                    // Offer regression option
                    if progressionHasPreviousLevel(for: progression, at: level) {
                        let prevLevel = getPreviousLevel(for: progression, at: level)
                        Text("Ready to go to the previous level?")
                        Button {
                            setLevel(progression.type, levelStr: prevLevel.rawValue)
                            isShowingNewProgressionDetails = true
                        } label: {
                            Text("Progress to previous level")
                        }
                    } else if progressionHasPreviousStage(for: progression) {
                        let prevStage = getPreviousStage(for: progression)
                        Text("Ready to go to the previous stage?")
                        Button {
                            setProgression(progression.type, stage: prevStage)
                            isShowingNewProgressionDetails = true
                        } label: {
                            Text("Progress to previous stage")
                        }
                    }
                }
                Spacer()
                Button("Next") {
                    goToNext()
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
                Spacer()
                Button("Save") {
                    saveSet(setsDoneToday: setsDoneToday, sets: sets)
                    isShowingConfirmation = true
                }
                .padding()
            }
            .onAppear {
                let latestRepCount = getLatestRecordedReps(entries: journalEntries, forType: progression.type)
                reps = latestRepCount > 0 ? latestRepCount : progression.getReps(for: level)
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
        // Insert exercise if not already in WorkoutsByDay for this day
        let status = setsDoneToday + 1 >= sets ? WorkoutCompleteStatus.complete : WorkoutCompleteStatus.inProgress
        updateTodaysWorkoutStatus(for: progression.type, status: status)
        var level = Level.beginner.rawValue
        if let user = users.first {
            level = user.getLevel(forType: progression.type)
        }
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type.rawValue,
                stage: progression.stage,
                level: Level(rawValue: level) ?? Level.beginner,
                reps: reps
            )
        )
    }
    
    func updateTodaysWorkoutStatus(for exerciseType: ExerciseType, status: WorkoutCompleteStatus) {
        let currentDate = getCurrentDate()
        if var currentWorkout = getWorkout(entries: workoutsByDay, forDate: currentDate) {
            currentWorkout[exerciseType] = status
        } else {
            let newWorkoutByDay = WorkoutsByDay(date: currentDate, workout: [exerciseType: status])
            context.insert(newWorkoutByDay)
        }
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
