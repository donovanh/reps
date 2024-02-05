//
//  DayView.swift
//
// TODO: Bug: Not filling some exercises properly even though it seems to

// Add a ProgressTracking class to store number of times each progression has been done - like .pushup stage 2 level .beginner, count 10 would mean halfway to filling that ring
// Design an icon for each progression, dynamically generated with colours and initials for the exercise type

// TODO: Make edit mode put an edit icon in front of the progression so selecting the progression chooses level
// TODO: Maybe have next/ prev day buttons but when not in "Edit schedule" mode, show that day's actual workout from journal
// TODO: Present a nice empty state
// TODO: Buttons - primary, a subtle add button, etc

import SwiftData
import SwiftUI

struct DayView: View {

    @Environment(\.modelContext) private var context
    @Query private var journalEntries: [JournalEntryV2]
    @State private var viewModel = ViewModel()
    
    @State private var isPresentingAddExercise: Bool = false
    @State private var isPresentingWorkout: Bool = false
    
    @State private var isEditMode = false
    
    @State private var userExerciseStages = UserExerciseStages()
    
    @State var day: Int
    
    var isTodayDone: Bool {
        withAnimation {
            workout.exerciseTypes.count > 0 && viewModel.isTodayDone(journalEntries: journalEntries, exerciseTypes: workout.exerciseTypes, userExerciseStages: userExerciseStages)
        }
    }
    
    var isTodayInProgress: Bool {
        withAnimation {
            workout.exerciseTypes.count > 0 && viewModel.isTodayInProgress(journalEntries: journalEntries, exerciseTypes: workout.exerciseTypes, userExerciseStages: userExerciseStages)
        }
    }
    
    var workout: ExerciseTypesByDay {
        withAnimation {
            ExerciseTypesByDay(day: day)
        }
    }
    
    var title: String {
        if isEditMode == true || day != Date().dayNumberOfWeek() ?? 0 {
            return "\(viewModel.dayName(for: day))s"
        }
        
        return "Today"
    }
    
    var progressions: [Progression] {
        viewModel.makeProgressions(
            exerciseTypes: workout.exerciseTypes,
            userExerciseStages: userExerciseStages
        )
    }
    
    var firstNotDoneProgressionIndex: Int {
        let firstNotDoneProgressionIndex = viewModel.firstNotDoneProgressionIndex(journalEntries: journalEntries, progressions: progressions, userExerciseStages: userExerciseStages)
        if firstNotDoneProgressionIndex == -1 {
            return 0
        }
        return firstNotDoneProgressionIndex
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    List {
                        ForEach(workout.exerciseTypes.indices, id: \.self) { index in
                            let exerciseType = workout.exerciseTypes[index]
                            ExerciseItem(
                                userExerciseStages: userExerciseStages,
                                exerciseType: exerciseType,
                                isEditMode: isEditMode,
                                progressions: progressions,
                                index: index,
                                geo: geo
                            )
                            .id(exerciseType)
                        }
                        .onMove(perform: workout.moveExercise(fromOffsets:toOffset:))
                        .onDelete(perform: workout.removeExerciseType)
                        if workout.exerciseTypes.count < 6 {
                            Button("Add") {
                                isPresentingAddExercise = true
                            }
                            .confirmationDialog("Adding exercise", isPresented: $isPresentingAddExercise) {
                                AddExerciseSheet(workout: workout)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    if isEditMode {
                        Text("Editing schedule")
                    } else if isTodayDone {
                        Text("All done!")
                            .font(.callout) // TODO: Celebration animation
                    } else {
                        Button(isTodayInProgress ? "Continue Workout" : "Start Workout") {
                            isPresentingWorkout = true
                        }
                        .buttonStyle(PrimaryButton())
                    }
                }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        if isEditMode {
                            HStack {
                                Button("Prev day") {
                                    changeDay(direction: "prev")
                                }
                                Spacer()
                                Button("Next day") {
                                    changeDay(direction: "next")
                                }
                            }
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(isEditMode ? "Done" : "Edit") {
                            withAnimation {
                                isEditMode.toggle()
                                day = Date().dayNumberOfWeek() ?? 0
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
            }
            .sheet(isPresented: $isPresentingWorkout) {
                ProgressionViewer(
                    userExerciseStages: userExerciseStages,
                    viewToShow: .workoutView,
                    progressions: progressions,
                    startingIndex: firstNotDoneProgressionIndex,
                    startingLevel: userExerciseStages.level(for: progressions[firstNotDoneProgressionIndex].type),
                    screenWidth: geo.size.width
                )
            }
        }
    }
    
    func changeDay(direction: String) {
        withAnimation {
            day = viewModel.changeDayNum(num: day, direction: direction)
        }
    }
}

#Preview {
    DayView(day: Date().dayNumberOfWeek() ?? 0)
        .modelContainer(DataController.previewContainer)
}
