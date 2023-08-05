//
//  DayView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 25/07/2023.
//

import SwiftUI
import SwiftData

struct DayView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.editMode) private var editMode
    
    @Query private var routines: [Routine]
    @Query private var users: [User]
    
    @State private var reorderedExercises: [Exercise] = []
    
    var day: DayOfWeek
    
    @State private var isPresentingAddExercise: Bool = false
    
    var body: some View {
        Section(String(localized: day.localizedStringResource)) {
            let routine = getRoutine(forDay: day.rawValue, fromRoutines: routines)
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
                    .confirmationDialog("Adding exercise \(day.localizedStringResource)", isPresented: $isPresentingAddExercise) {
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
        let routine = getRoutine(forDay: day.rawValue, fromRoutines: routines)
        for exercise in routine.exercises {
            if exercise.type == type.rawValue {
                return true
            }
        }
        return false
    }
    
    func addExercise(ofType type: ExerciseType) {
        guard users.first != nil else { return }
        let newExercise = Exercise(id: UUID(), type: type.rawValue)
        
        if let index = routines.firstIndex(where: { $0.day == day.rawValue }) {
            routines[index].exercises.append(newExercise)
        } else {
            let newRoutine = Routine(day: day.rawValue, exercises: [newExercise])
            context.insert(newRoutine)
        }
    }
    
    func moveExercise(fromOffsets source: IndexSet, toOffset destination: Int) {
        let routine = getRoutine(forDay: day.rawValue, fromRoutines: routines)
        reorderedExercises = routine.exercises
        reorderedExercises.move(fromOffsets: source, toOffset: destination)
        routine.exercises.removeAll()
        routine.exercises += reorderedExercises
    }
}

//#Preview {
//    DayView(day: DayOfWeek.monday)
//}
