//
//  DayView.swift
//
// Refactor all viewModel.userExerciseStagesStore methods into viewModel, make the store simpler
// Remove observation from data stores and ensure viewModel is handling it

// BUG: Adding last item makes sheet re-appear (iOS bug?)
// BUG: Grey box on first showing icons - preload somehow? Maybe load the six icons I'll need to show invisibly somewhere?

// Pull DayView into smaller pieces - like main view, edit view, etc

// TODO: Make add exercise list give the right exercise names

// TODO: Design an icon for each progression, using 3d model
// TODO: Try a USDZ model, see if can attach animation from existing files

// TODO: Check aligment issues don't persist on other devides
// TODO: Maybe have custom layout on ipad

// TODO: Make sure continue workout goes to the next set incomplete set with fewer sets than the previous

// TODO: Animate the today's exercises in using s staggered fade

// TODO: Make edit mode put an edit icon in front of the progression so selecting the progression chooses level
// TODO: Maybe have next/ prev day buttons but when not in "Edit schedule" mode, show that day's actual workout from journal
// TODO: Illustration for empty state
// TODO: Iterate on the animation view. Maybe a circle like the icon?
// TODO: Journal view
// TODO: Export / reset journal options
// TODO: Reference guide
// TODO: Link reference info from the record view - using a modal
// TODO: Link similarly from the change progression view - using a modal

import SwiftData
import SwiftUI

struct DayView: View {

    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isUserWelcomeDone") var isUserWelcomeDone = false
    
    @Query private var journalEntries: [JournalEntry]
    @State private var viewModel = ViewModel()
    
    @State private var isPresentingAddExercise = false
    @State private var isPresentingWorkout = false
    @State private var isPresentingPlanBuilder = false
    @State private var isPresentingWelcomeScreen = false
    @State private var isEditMode = false
    @State private var isAnimating = false
    
    @State var day: Int
    
    // Move to viewModel
    var workoutSchedule: [ExerciseType] {
        viewModel.weeklySchedule[day] ?? []
    }
    
    var isTodayEmpty: Bool {
        workoutSchedule.count == 0
    }
    
    var isTodayDone: Bool {
        withAnimation {
            viewModel.isTodayDone(journalEntries: journalEntries, exerciseTypes: workoutSchedule)
        }
    }
    
    var isTodayInProgress: Bool {
        withAnimation {
            workoutSchedule.count > 0 && viewModel.isTodayInProgress(journalEntries: journalEntries, exerciseTypes: workoutSchedule)
        }
    }
    
    var title: String {
        if isEditMode == true || day != Date().dayNumberOfWeek() ?? 0 {
            return "\(viewModel.dayName(for: day))s"
        }
        
        return "Today"
    }
    
    var progressions: [Progression] {
        viewModel.makeProgressions(exerciseTypes: workoutSchedule)
    }
    
    var firstNotDoneProgressionIndex: Int {
        let firstNotDoneProgressionIndex = viewModel.firstNotDoneProgressionIndex(journalEntries: journalEntries, progressions: progressions)
        if firstNotDoneProgressionIndex == -1 {
            return 0
        }
        return firstNotDoneProgressionIndex
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Load anmiation model to save flash of grey
                Icon(exerciseType: .pushup, stage: 5, size: 10, complete: false)
                    .opacity(0)
                NavigationView {
                    VStack {
                        Spacer()
                        List {
                            Section {
                                if !isTodayEmpty {
                                    ForEach(workoutSchedule.indices, id: \.self) { index in
                                        if index < workoutSchedule.count {
                                            let exerciseType = workoutSchedule[index]
                                            let delay = 0.25 + (0.05 * Double(index))
                                            ExerciseItem(
                                                viewModel: viewModel,
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
                                    }
                                    .onMove { fromOffsets, toOffset in
                                        viewModel.moveExercise(fromOffsets: fromOffsets, toOffset: toOffset, forDay: day)
                                    }
                                    .onDelete {
                                        viewModel.removeExerciseType(at: $0, forDay: day)
                                    }
                                }
                                
                                if workoutSchedule.count < 6 {
                                    let buttonDelay = 0.3 + (0.05 * Double(workoutSchedule.count))
                                    Button {
                                        isPresentingAddExercise = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: isEditMode ? 24 : 34))
                                            
                                            if workoutSchedule.count == 0 || isEditMode {
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
                                        AddExerciseSheet(viewModel: viewModel, day: day)
                                    }
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white.opacity(0))
                                            .padding(.bottom, 10)
                                    )
                                }
                                
                                if isEditMode && !isTodayEmpty {
                                    VStack {
                                        Text("Select an exercise to adjust level")
                                            .font(.callout)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                
                                if isTodayEmpty {
                                    VStack {
                                        Text("Rest Day")
                                            .font(.title.bold())
                                            .padding(.top, 40)
                                            .padding(.bottom, 10)
                                        Text("Take it easy! Recovery is important.")
                                            .font(.callout)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 40)
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                            }
                            .onAppear {
                                // isUserWelcomeDone = false
                                isAnimating = true
                                isPresentingWelcomeScreen = !isUserWelcomeDone
                            }
                        }
                        Spacer()
                        Spacer()
                        if isEditMode {
                            Button("Generate new plan") {
                                isPresentingPlanBuilder = true
                            }
                            .tint(.themeColor)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        } else if isTodayEmpty {
                            // Nothing currently
                        } else if isTodayDone {
                            Text("All done!")
                                .font(.callout) // TODO: Celebration animation
                        } else {
                            Button(isTodayInProgress ? "Continue Workout" : "Start Workout") {
                                isPresentingWorkout = true
                            }
                            .tint(.themeColor)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
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
                            } else {
                               NavigationLink {
                                   JournalView()
                                       .navigationTitle("Journal")
                                } label: {
                                    Text("Journal")
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.themeColor)
                                .controlSize(.small)
                                .tint(Color.themeColor)
                                .listRowBackground(Color.clear)
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
                    .background(colorScheme == .dark ? Color.darkBg : Color.lightBg)
                    .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
                }
                if isPresentingWelcomeScreen {
                    WelcomeScreen(
                        isPresentingWelcomeScreen: $isPresentingWelcomeScreen,
                        isPresentingPlanBuilder: $isPresentingPlanBuilder
                    )
                }
            }
            .sheet(isPresented: $isPresentingWorkout) {
                ProgressionViewer(
                    dayViewModel: viewModel,
                    viewToShow: .workoutView,
                    progressions: progressions,
                    startingIndex: firstNotDoneProgressionIndex,
                    startingLevel: viewModel.getLevel(for: progressions[firstNotDoneProgressionIndex].type),
                    screenWidth: geo.size.width
                )
            }
            .sheet(isPresented: $isPresentingPlanBuilder) {
                PlanBuilderView(
                    dayViewModel: viewModel,
                    isEditMode: $isEditMode
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
            day = Date().dayNumberOfWeek() ?? 0
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
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        .modelContainer(DataController.previewContainer)
}
