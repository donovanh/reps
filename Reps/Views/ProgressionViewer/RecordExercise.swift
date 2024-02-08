//
//  A view to be displayed within ProgressionViewer
//  Allows user to record reps for a set of progressions
//

import SwiftData
import SwiftUI

struct RecordExercise: View {
    
    let progressions: [Progression]
    let displayProgression: Progression
    let startingIndex: Int
    let scrollViewValue: ScrollViewProxy
    let geo: GeometryProxy
    @State var userExerciseStages: UserExerciseStages
    let dismiss: DismissAction
    
    @Environment(\.modelContext) private var context
    @Query private var journalEntries: [JournalEntry]
    @State private var viewModel = ProgressionViewer.ViewModel()
    @State private var stage = 1
    @State private var reps: Int = 0
    
    var nextProgressionIndex: Int {
        DayView.ViewModel().nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progressions[0], userExerciseStages: userExerciseStages)
    }
    
    var level: Level {
        userExerciseStages.level(for: displayProgression.type)
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
            Button {
                saveReps(progressions: progressions, progression: displayProgression, level: level, reps: reps, dismiss: dismiss, scrollViewProxy: scrollViewValue)
            } label: {
                if (displayProgression.showSecondsForReps == true) {
                    Text("Log ^[\(reps) second](inflect: true)")
                        .contentTransition(.numericText())
                } else {
                    Text("Log ^[\(reps) rep](inflect: true)")
                        .contentTransition(.numericText())
                }
            }
            .foregroundColor(.white)
            .tint(.themeColor)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

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
        let progressionAlreadyDone = DayView.ViewModel().isProgressionDone(journalEntries: journalEntries, progression: progression, userExerciseStages: userExerciseStages)
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type,
                stage: progression.stage,
                level: level,
                reps: reps
            )
        )
        let nextProgression = DayView.ViewModel().nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progression, userExerciseStages: userExerciseStages)
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
                userExerciseStages: UserExerciseStages(),
                dismiss: dismiss
            )
            .modelContainer(DataController.previewContainer)
        }
    }
}
