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
    
    let progressions: [Progression]
    let displayProgression: Progression
    let startingIndex: Int
    let scrollViewValue: ScrollViewProxy
    let geo: GeometryProxy
    @State var dayViewModel: DayView.ViewModel
    let dismiss: DismissAction
    @Binding var isScrolling: Bool
    
    var nextProgressionIndex: Int {
        dayViewModel.nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progressions[0])
    }
    
    var level: Level {
        dayViewModel.getLevel(for: displayProgression.type)
    }
    
    var body: some View {
        let targetReps = displayProgression.getReps(for: level)
        let sets = displayProgression.getSets(for: level)
        let setsDone = JournalEntry.getSetsDone(entries: journalEntries, forDate: Date(), ofType: displayProgression.type, ofStage: displayProgression.stage, ofLevel: level)
        let halfHeight = UIScreen.portraitHeight < 700 ? 250 : geo.size.height / 2

        VStack {
            HStack {
                Spacer()
                Text(String(localized: displayProgression.name.rawValue))
                    .font(.largeTitle.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, halfHeight + 10)
                Spacer()
            }
            
            Text("\(targetReps) \(displayProgression.showSecondsForReps == true ? "seconds" : "reps")")
                .font(.title2)
            
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
            
            if displayProgression.showSecondsForReps == true {
                TimerView(displayProgression: displayProgression, level: level, saveAction: saveReps)
            } else {
                RepsView(displayProgression: displayProgression, level: level, saveAction: saveReps, reps: reps)
            }
            
            Spacer()
         }
        .onAppear {
            stage = displayProgression.stage
            reps = displayProgression.getReps(for: level)
        }
    }
    
    func scrollTo(_ progression: Progression) {
        isScrolling = true
        Task {
            try await Task.sleep(for: .seconds(0.25))
            withAnimation {
                scrollViewValue.scrollTo(progression)
            } completion: {
                Task {
                    try await Task.sleep(for: .seconds(0.25))
                    isScrolling = false
                }
            }
        }
    }
    
    func saveReps(progression: Progression, level: Level, reps: Int) {
        // Check if progression is done already
        let progressionAlreadyDone = dayViewModel.isProgressionDone(journalEntries: journalEntries, progression: progression)
        let nextProgressionIndex = dayViewModel.nextUnfinishedProgressionIndex(journalEntries: journalEntries, progressions: progressions, progression: progression)
        if nextProgressionIndex > -1 {
            scrollTo(progressions[nextProgressionIndex])
        } else {
            if progressionAlreadyDone {
                // All are done and this was already done, so dismiss
                addJournalEntry(progression: progression, reps: reps)
                dismiss()
                return
            } else {
                // Check if it's now done
                let sets = displayProgression.getSets(for: level)
                let setsDone = JournalEntry.getSetsDone(entries: journalEntries, forDate: Date(), ofType: displayProgression.type, ofStage: displayProgression.stage, ofLevel: level)
 
                if setsDone + 1 >= sets {
                    addJournalEntry(progression: progression, reps: reps)
                    dismiss()
                    return
                }
            }
        }
        // Lastly update the context, but with a slight delay to visible UI change and potential scrolling jumpiness
        Task {
            try await Task.sleep(for: .seconds(0.1))
            addJournalEntry(progression: progression, reps: reps)
        }
    }
    
    func addJournalEntry(progression: Progression, reps: Int) {
        context.insert(
            JournalEntry(
                date: Date(),
                exerciseType: progression.type,
                stage: progression.stage,
                level: level,
                reps: reps
            )
        )
        dayViewModel.calculateProgressionScores(journalEntries: journalEntries)
    }
}

#Preview("Reps") {
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
                dismiss: dismiss,
                isScrolling: .constant(false)
            )
            .modelContainer(DataController.previewContainer)
        }
    }
}

#Preview("Seconds") {
    @Environment(\.dismiss) var dismiss
    return ScrollViewReader { scrollViewValue in
        GeometryReader { geo in
            RecordExercise(
                progressions: Progression.defaultProgressionMixedSet,
                displayProgression: Progression.defaultProgressionSingleTypeTimed[2],
                startingIndex: 2,
                scrollViewValue: scrollViewValue,
                geo: geo,
                dayViewModel: DayView.ViewModel(),
                dismiss: dismiss,
                isScrolling: .constant(false)
            )
            .modelContainer(DataController.previewContainer)
        }
    }
}
