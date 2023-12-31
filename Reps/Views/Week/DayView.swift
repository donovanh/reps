import SwiftUI
import SwiftData

struct DayView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.editMode) private var editMode
    
    @Query private var routines: [Routine]
    @Query private var users: [User]
    
    @State private var reorderedExercises: [Exercise] = []
    
    var day: Int
    
    @State private var isPresentingAddExercise: Bool = false
    
    var body: some View {
        let f = DateFormatter()
        let dayString = f.weekdaySymbols[day - 1]
        Section(dayString) {
            let routine = getRoutine(forDay: day, fromRoutines: routines)
            if (routine.exercises.count == 0) {
                Text("Rest Day")
            } else {
                ForEach(routine.exercises, id: \.id) { exercise in
                    ExerciseListItemView(exercise: exercise)
                }
                .onMove(perform: moveExercise(fromOffsets:toOffset:))
                .onDelete { indices in
                    for index in indices {
                        deleteExercise(fromRoutine: routine, atIndex: index)
                    }
                }
            }
            if !routineContainsAllExerciseTypes() {
                if editMode?.wrappedValue.isEditing == false {
                    Button("Add") {
                        setIsPresentingExercise()
                    }
                    .confirmationDialog("Adding exercise", isPresented: $isPresentingAddExercise) {
                        ForEach(ExerciseType.allCases, id: \.self) { exerciseType in
                            if (!routineContainsExercise(ofType: exerciseType)) {
                                Button(String(localized: exerciseType.localizedStringResource)) {
                                    addExercise(ofType: exerciseType)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteExercise(fromRoutine routine: Routine, atIndex index: Int) {
        routine.exercises.remove(at: index)
    }
    
    func setIsPresentingExercise() {
        isPresentingAddExercise = true
    }
    
    func routineContainsAllExerciseTypes() -> Bool {
        for type in ExerciseType.allCases {
            if (!routineContainsExercise(ofType: type)) {
                return false
            }
        }
        return true
    }
    
    func routineContainsExercise(ofType type: ExerciseType) -> Bool {
        let routine = getRoutine(forDay: day, fromRoutines: routines)
        for exercise in routine.exercises {
            if exercise.type == type {
                return true
            }
        }
        return false
    }
    
    func addExercise(ofType type: ExerciseType) {
        guard users.first != nil else { return }
        let newExercise = Exercise(id: UUID(), type: type)
        
        if let index = routines.firstIndex(where: { $0.day == day }) {
            routines[index].exercises.append(newExercise)
        } else {
            let newRoutine = Routine(day: day, exercises: [newExercise])
            context.insert(newRoutine)
        }
    }
    
    func moveExercise(fromOffsets source: IndexSet, toOffset destination: Int) {
        let routine = getRoutine(forDay: day, fromRoutines: routines)
        reorderedExercises = routine.exercises
        reorderedExercises.move(fromOffsets: source, toOffset: destination)
        routine.exercises.removeAll()
        routine.exercises += reorderedExercises
    }
}

#Preview {
    Form {
        DayView(day: 7)
            .modelContainer(DataController.previewContainer)
    }
}
