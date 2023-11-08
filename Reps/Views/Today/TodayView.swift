import SwiftUI
import SwiftData

/*
 TODO
 - Progression: mechanism for moving to the next difficulty level, then next stage
 - First, get journal entries
 - List today's progressions
 - For each exercise category, check if Journal contains entries that map to a completed day of sets/reps
 - If completed, show that stage / level with completed
 - If not, show the stage and level as defined in the user's settings
 
 
 - Fixture journal data to set up and easily test progression mechanism
 - Look into bug for when opening specific exercise from Today view the first in the list shows
 - Maybe show progress here in terms of how much along they are to being levelled up
 */

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @Query private var users: [User]
    @Query private var journalEntries: [JournalEntry]
    @Query private var workoutsByDay: [WorkoutsByDay]
    
    @State var todayExercises: [Exercise] = []
    @State private var showingPlanBuilder = false
    @State private var showingTodayRoutine = false
    @State private var showingSettingsSheet = false
    @State private var showingExerciseBrowserSheet = false
    
    @State private var isTodayInProgress = false
    @State private var isTodayComplete = false
    @State private var currentExerciseId: UUID?
    
    var body: some View {
        NavigationView {
            if let user = users.first {
                VStack {
                    let todaysWorkoutExercises = getWorkout(entries: workoutsByDay, forDate: getCurrentDate()) ?? [:]
                    if todayExercises.count > 0 {
                        ForEach(todayExercises, id: \.self) { exercise in
                            // Determine if exercise is "done" for today in journal
                            let isWorkoutExerciseComplete = checkIsExerciseComplete(for: exercise.type, inWorkout: todaysWorkoutExercises)
                            if isWorkoutExerciseComplete == true {
                                // Drive level and sets according to journal
                                let journalEntriesForType = getJournalEntries(entries: journalEntries, forDate: getCurrentDate(), ofType: exercise.type)
                                
                                if journalEntriesForType.count > 0 {
                                    let level = journalEntriesForType[0].level
                                    let stage = journalEntriesForType[0].stage
                                    let sets = getSets(forExerciseType: exercise.type, forStage: stage, forLevel: level)
                                    let setsDone = sets
                                    if let progression = getExercise(ofType: exercise.type, atStage: stage) {
                                        ExerciseItemView(
                                            progression: progression,
                                            exerciseType: exercise.type, levelStr: level.rawValue,
                                            setsDone: setsDone
                                        )
                                        .onTapGesture {
                                            currentExerciseId = exercise.id
                                            showingTodayRoutine = true
                                        }
                                        .onAppear {
                                            isTodayInProgress = true
                                        }
                                    }
                                } else {
                                    fatalError("Journal entries missing in Today view for complete exercise")
                                }
                            } else {
                                // Otherwise drive them based on user values
                                let level = user.getLevel(forType: exercise.type)
                                let sets = getSets(forExerciseType: exercise.type)
                                let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
                                
                                if let progression = getExercise(ofType: exercise.type, atStage: user.getStage(forType: exercise.type)) {
                                    ExerciseItemView(
                                        progression: progression,
                                        exerciseType: exercise.type, levelStr: level,
                                        setsDone: setsDone
                                    )
                                    .onTapGesture {
                                        currentExerciseId = exercise.id
                                        showingTodayRoutine = true
                                    }
                                    .onAppear {
                                        if setsDone < sets {
                                            currentExerciseId = exercise.id
                                        }
                                        if setsDone > 0 {
                                            isTodayInProgress = true
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        if isTodayComplete != true {
                            Button(isTodayInProgress ? "Continue Workout" : "Start Workout") {
                                if isTodayInProgress == true {
                                    for exercise in todayExercises {
                                        let sets = getSets(forExerciseType: exercise.type)
                                        let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
                                        if setsDone < sets {
                                            currentExerciseId = exercise.id
                                            break
                                        }
                                    }
                                }
                                showingTodayRoutine = true
                            }
                            .padding()
                        } else {
                            Text("You're all done for today!")
                            Button("Do more") {
                                currentExerciseId = todayExercises.first?.id
                                showingTodayRoutine = true
                            }
                            .padding()
                        }
                    } else {
                        if routines.count == 0 {
                            Button("Set up a new routine") {
                                showingPlanBuilder = true
                            }
                        } else {
                            Text("Rest day")
                                .font(.largeTitle)
                            Text("Maybe go for a walk!")
                        }
                    }
                    Button {
                        showingExerciseBrowserSheet = true
                    } label: {
                        Label("Browse Exercises", systemImage: "book")
                    }
                    .padding(.vertical, 20)
                }
                .navigationTitle("Your Day: \(getDayName(forDate: Date()))")
                .padding(.vertical, 10)
                .toolbar {
                    Button {
                        showingSettingsSheet = true
                    } label: {
                        Label("User Profile", systemImage: "person.crop.circle")
                    }
                }
            } else {
                Text("New user")
            }
        }
        .sheet(isPresented: $showingPlanBuilder) {
            PlanBuilderView(showingPlanBuilder: $showingPlanBuilder)
        }
        .sheet(isPresented: $showingTodayRoutine) {
            WorkoutView(
                showingTodayRoutine: $showingTodayRoutine,
                isTodayComplete: $isTodayComplete,
                isTodayInProgress: $isTodayInProgress,
                currentExerciseId: currentExerciseId,
                todayExercises: todayExercises,
                screenWidth: UIScreen.main.bounds.width + 8
            )
        }
        .sheet(isPresented: $showingSettingsSheet) {
            UserView()
        }
        .sheet(isPresented: $showingExerciseBrowserSheet) {
            ExerciseBrowserView(showingExerciseBrowserView: $showingExerciseBrowserSheet)
        }
        .onAppear {
            // isWorkoutInProgress = false
            if routines.isEmpty {
                print("Routine empty")
                applyEmptySchedule()
            }
            todayExercises = getTodayExercises()
            // TODO: Have this check WorkoutsByDay too
            isTodayComplete = checkIsTodayComplete(todayExercises: todayExercises)
        }
    }
    
    func getDayName(forDate date: Date) -> String {
        let calendar = Calendar.current
        let dayNum = calendar.component(.weekday, from: date)
        let f = DateFormatter()
        return f.weekdaySymbols[dayNum - 1]
    }
    
    func getDayNum() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.weekday, from: currentDate)
    }
    
    func getTodayExercises() -> [Exercise] {
        let dayNum = getDayNum()
        let routine = getRoutine(forDay: dayNum, fromRoutines: routines)
        return routine.exercises
    }
    
    func applyEmptySchedule() {
        for dayNum in 1...7 {
            let newRoutine = Routine(day: dayNum, exercises: [])
            context.insert(newRoutine)
        }
    }
    
    func getSets(forExerciseType type: ExerciseType) -> Int {
        if let user = users.first {
            if let progression = getExercise(ofType: type, atStage: user.getStage(forType: type)) {
                let levelStr = user.getLevel(forType: type)
                return progression.getSets(for: Level(rawValue: levelStr) ?? .beginner)
            }
        }
        return 0
    }
    
    func getSets(forExerciseType type: ExerciseType, forStage stage: Int, forLevel level: Level) -> Int {
        if let progression = getExercise(ofType: type, atStage: stage) {
            return progression.getSets(for: level)
        }
        return 0
    }
    
    func checkIsExerciseComplete(for type: ExerciseType, inWorkout entry: [ExerciseType : WorkoutCompleteStatus]) -> Bool {
        if let exerciseCompleteStatus = entry[type] {
            return exerciseCompleteStatus == WorkoutCompleteStatus.complete
        } else {
            return false
        }
    }
    
    func checkIsTodayComplete(todayExercises: [Exercise]) -> Bool {
        // TODO: change to checkIsExerciseComplete for each exercise.type in todayExercises
        for exercise in todayExercises {
            let sets = getSets(forExerciseType: exercise.type)
            let setsDone = getSetsDone(entries: journalEntries, forDate: Date(), ofType: exercise.type)
            if setsDone < sets {
                return false
            }
        }
        return true
    }
}

#Preview {
    TodayView()
        .modelContainer(DataController.previewContainer)
}
