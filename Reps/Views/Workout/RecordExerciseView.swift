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
    
    @State var isShowingConfirmation = false
    @State var isShowingAdjustProgression = false
    
    // TODO:
    // Summarise what this does for future me
    // Pull Confirmation View into it's own thing
    
    var body: some View {
        if isShowingConfirmation == true {
            if isShowingAdjustProgression == true {
                AdjustProgression(
                    progression: progression,
                    level: level
                )
                Spacer()
            } else {
                let goalReps = progression.getReps(for: level)
                VStack {
                    Text("Confirmation view")
                        .font(.title)
                    // TODO: Congrats image (and animation)
                    // TODO: Suggest a level/stage progression if streak of hitting the full rep + sets goal
                    Text("Great work! Staying consistent and gradually improving over time is the key to progress.")
                    if reps >= goalReps && setsDoneToday >= sets {
                        Text("Ready to go to the next level?")
                        Button {
                            isShowingAdjustProgression = true
                        } label: {
                            Text("Progress to next level")
                        }
                    }
                }
                Spacer()
                Button("Adjust this progression") {
                    isShowingAdjustProgression = true
                }
                .padding(.vertical)
            }
            Button("Next") {
                goToNext()
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
            level: Level.beginner,
            exerciseId: UUID(),
            nextExerciseWithSetsId: UUID(),
            scrollViewValue: scrollViewValue
        )
        .modelContainer(DataController.previewContainer)
    }
}
