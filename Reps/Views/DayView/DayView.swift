//
//  DayView.swift
//
// V0.1 Testflight required items
// Onboarding flow
// Welcome image
// Better buttons
// Check top row icon sizes
// Journal with todo text
// Icon
// Set up Testflight-ready app configuration

// BUG: Adding last item makes sheet re-appear (iOS bug?)

// TODO: Design an icon for each progression, using 3d model
// TODO: Try a USDZ model, see if can attach animation from existing files

// TODO: Check aligment issues don't persist on other devides
// TODO: Maybe have custom layout on ipad

// TODO: Make sure continue workout goes to the next set incomplete set with fewer sets than the previous

// TODO: Animate the today's exercises in using s staggered fade

// TODO: Make edit mode put an edit icon in front of the progression so selecting the progression chooses level
// TODO: Maybe have next/ prev day buttons but when not in "Edit schedule" mode, show that day's actual workout from journal
// TODO: Present a nice empty state
// TODO: Buttons:
//      Add button
//      Edit button
//      Close button
// TODO: Iterate on the animation view. Maybe a circle like the icon?
// TODO: Journal view
// TODO: Export / reset journal options
// TODO: Reference guide
// TODO: Link reference info from the record view - using a modal
// TODO: Link similarly from the change progression view - using a modal

import SwiftData
import SwiftUI

struct DayView: View {

    @Environment(\.modelContext) private var context
    @Query private var journalEntries: [JournalEntry]
    @State private var viewModel = ViewModel()
    @State private var isPresentingAddExercise: Bool = false
    @State private var isPresentingWorkout: Bool = false
    @State private var isEditMode = false
    @State private var userExerciseStages = UserExerciseStages()
    @State private var isAnimating = false
    
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
                        Section {
                            ForEach(workout.exerciseTypes.indices, id: \.self) { index in
                                let exerciseType = workout.exerciseTypes[index]
                                let delay = 0.25 + (0.05 * Double(index))
                                ExerciseItem(
                                    userExerciseStages: userExerciseStages,
                                    exerciseType: exerciseType,
                                    isEditMode: isEditMode,
                                    progressions: progressions,
                                    index: index,
                                    geo: geo
                                )
                                
                                .id(exerciseType)
                                .foregroundColor(.primary)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.easeIn.delay(delay), value: isAnimating)
                            }
                            .onMove(perform: workout.moveExercise(fromOffsets:toOffset:))
                            .onDelete(perform: workout.removeExerciseType)
                            .onAppear {
                                isAnimating = true
                            }
                            
                            if workout.exerciseTypes.count < 6 {
                                let buttonDelay = 0.3 + (0.05 * Double(workout.exerciseTypes.count))
                                Button {
                                    isPresentingAddExercise = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: isEditMode ? 24 : 34))
                                            
                                        if workout.exerciseTypes.count == 0 {
                                            Text("Add exercise")
                                                .font(.headline)
                                        }
                                    }
                                }
                                .foregroundStyle(Color.secondaryButtonBg)
                                .padding(isEditMode ? -2 : 2)
                                .padding(.top, isEditMode ? 14 : 10)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(.easeIn.delay(buttonDelay), value: isAnimating)
                                .confirmationDialog("Adding exercise", isPresented: $isPresentingAddExercise) {
                                    AddExerciseSheet(workout: workout)
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white.opacity(0))
                                        .padding(.bottom, 10)
                                )
                            }
//                            Button("Clear today's journal") {
//                                let currentDate = Date()
//
//                                let entriesToDelete = journalEntries.filter { entry in
//                                    let entryDate = Calendar.current.startOfDay(for: entry.date)
//                                    let currentDate = Calendar.current.startOfDay(for: currentDate)
//                                    return entryDate == currentDate
//                                }
//
//                                for entryToDelete in entriesToDelete {
//                                    context.delete(entryToDelete)
//                                }
//                            }
                        }
                    }
                    
                    if isTodayDone {
                        Text("All done!")
                            .font(.callout) // TODO: Celebration animation
                    } else if !isEditMode {
                        Button(isTodayInProgress ? "Continue Workout" : "Start Workout") {
                            isPresentingWorkout = true
                        }
                        .tint(.themeColor)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                    }
                }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        if isEditMode {
                            HStack {
                                Button {
                                    changeDay(direction: "prev")
                                } label: {
                                    Image(systemName: "arrow.left")
                                }
                                Spacer()
                                Button {
                                    changeDay(direction: "next")
                                } label: {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .tint(.themeColor)
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .buttonBorderShape(.roundedRectangle(radius: 10))
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                isEditMode.toggle()
                                day = Date().dayNumberOfWeek() ?? 0
                            }
                        } label: {
                            if !isEditMode {
                                Text("Edit")
                            } else {
                                Text("Done")
                            }
                        }
                        .tint(.themeColor)
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .scrollContentBackground(.hidden)
                .containerRelativeFrame([.horizontal, .vertical])
                .background(Color.lightBg)
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
