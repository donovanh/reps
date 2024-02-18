//
//  A view to be displayed within ProgressionViewer
//  Allows user to record reps for a set of progressions
//

import SwiftData
import SwiftUI

struct RecordExercise: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    
    @Query private var journalEntries: [JournalEntry]
    @State private var viewModel = ProgressionViewer.ViewModel()
    @State private var stage = 1
    @State private var reps: Int = 0
    @State private var isSavingExercise = false
    @State private var savingTask: Task<Void, Error>?
    
    let progressions: [Progression]
    let displayProgression: Progression
    let startingIndex: Int
    let scrollViewValue: ScrollViewProxy
    let geo: GeometryProxy
    @State var dayViewModel: DayView.ViewModel
    let dismiss: DismissAction
    
    var nextProgressionIndex: Int {
        dayViewModel.nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progressions[0])
    }
    
    var level: Level {
        dayViewModel.getLevel(for: displayProgression.type)
    }
    
    var body: some View {
        let targetReps = displayProgression.getReps(for: level)
        let sets = displayProgression.getSets(for: level)
        let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: displayProgression.type, ofStage: displayProgression.stage, ofLevel: level)

        VStack {
            HStack {
                Spacer()
                Text(String(localized: displayProgression.name.rawValue))
                    .font(.largeTitle.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.top, (geo.size.height / 2) + 10)
                Spacer()
            }
            
            Text("\(targetReps) \(displayProgression.showSecondsForReps == true ? "seconds" : "reps")")
                .font(.title2)
                .padding(.bottom)
            Spacer()
            
            HStack {
                if sets > 1 && setsDone < sets {
                    Text("Set \(setsDone + 1) of \(sets)")
                } else if sets == 1 && setsDone == 0 {
                    Text("1 set")
                } else {
                    Text("All sets done")
                }
            }
            .padding(.bottom)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        decrementReps()
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .foregroundColor(.themeColor)
                    .tint(.themeColor)
                    .font(.system(size: 48))
                    .controlSize(.large)
                    .buttonRepeatBehavior(.enabled)
                    VStack {
                        Text("\(reps)")
                            .font(.system(size: 64).bold())
                            .padding(.top, -10)
                            .padding(.bottom, -15)
                            .contentTransition(.numericText())
                        if (displayProgression.showSecondsForReps == true) {
                            Text("\(reps > 1 ? "seconds" : "second")")
                        } else {
                            Text("\(reps > 1 ? "reps" : "rep")")
                        }
                    }
                    .frame(width: 125)
                    Button {
                        incrementReps()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .foregroundColor(.themeColor)
                    .tint(.themeColor)
                    .font(.system(size: 48))
                    .controlSize(.large)
                    .buttonRepeatBehavior(.enabled)
                    Spacer()
                }
                .padding(.bottom)
            }
            .presentationDragIndicator(.automatic)
            
            Spacer()
            if !isSavingExercise {
                Button {
                    savingTask = Task {
                        withAnimation {
                            isSavingExercise = true
                        }
                        try await Task.sleep(for: .seconds(2))
                        saveReps(progressions: progressions, progression: displayProgression, level: level, reps: reps, dismiss: dismiss, scrollViewProxy: scrollViewValue)
                        withAnimation {
                            isSavingExercise = false
                        }
                    }
                } label: {
                    let TextView = displayProgression.showSecondsForReps == true
                    ? Text("Log ^[\(reps) second](inflect: true)")
                    : Text("Log ^[\(reps) rep](inflect: true)")
                    
                    TextView
                        .contentTransition(.numericText())
                }
                .foregroundColor(.white)
                .tint(.themeColor)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else {
                Text("Saving...")
                    .font(.title)
                Button("Cancel") {
                    isSavingExercise = false
                    savingTask?.cancel()
                }
                .tint(.themeColor)
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            

            Spacer()
         }
        .onAppear {
            stage = displayProgression.stage
            reps = displayProgression.getReps(for: level)
        }
    }
    
    func incrementReps() {
        if reps < 999 {
            withAnimation {
                reps += 1
            }
        }
    }
    
    func decrementReps() {
        if reps > 1 {
            withAnimation {
                reps -= 1
            }
        }
    }
    
    func saveReps(progressions: [Progression], progression: Progression, level: Level, reps: Int, dismiss: DismissAction, scrollViewProxy: ScrollViewProxy?) {
        // Check if progression is done already
        let progressionAlreadyDone = dayViewModel.isProgressionDone(journalEntries: journalEntries, progression: progression)
        let nextProgression = dayViewModel.nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progression)
        if (nextProgression > -1) {
            withAnimation {
                scrollViewValue.scrollTo(progressions[nextProgression])
            }
        } else {
            if progressionAlreadyDone {
                // All are done and this was already done, so dismiss
                dismiss()
            } else {
                // Check if it's now done
                let sets = displayProgression.getSets(for: level)
                let setsDone = journalEntryMethods().getSetsDone(entries: journalEntries, forDate: Date(), ofType: displayProgression.type, ofStage: displayProgression.stage, ofLevel: level)
 
                if setsDone + 1 >= sets {
                    dismiss()
                }
            }
        }
        // Lastly update the context, but with a slight delay to remove UI jumpiness
        Task {
            try await Task.sleep(for: .seconds(0.5))
            context.insert(
                JournalEntry(
                    date: Date(),
                    exerciseType: progression.type,
                    stage: progression.stage,
                    level: level,
                    reps: reps
                )
            )
        }
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return ScrollViewReader { scrollViewValue in
        GeometryReader { geo in
            RecordExercise(
                progressions: Progression.defaultProgressionMixedSet,
                displayProgression: Progression.defaultProgressionMixedSet[2],
                startingIndex: 2,
                scrollViewValue: scrollViewValue,
                geo: geo,
                dayViewModel: DayView.ViewModel(),
                dismiss: dismiss
            )
            .modelContainer(DataController.previewContainer)
        }
    }
}
