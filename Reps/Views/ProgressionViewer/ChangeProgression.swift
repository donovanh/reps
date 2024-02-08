//
//  A view to be displayed within ProgressionViewer
//  Allows user to change progression level and stage
//

import SwiftUI

struct ChangeProgression: View {

    let progressions: [Progression]
    let displayProgression: Progression
    @Binding var level: Level
    let startingIndex: Int
    let startingLevel: Level
    let scrollViewValue: ScrollViewProxy
    let geo: GeometryProxy
    @State var userExerciseStages: UserExerciseStages
    let dismiss: DismissAction
    
    @State private var viewModel = ProgressionViewer.ViewModel()
    @State private var stage = 1
    
    var body: some View {
        let reps = displayProgression.getReps(for: level)
        let sets = displayProgression.getSets(for: level)
        let isCurrentLevel = stage == startingIndex && level == startingLevel

        VStack {
            Text(String(localized: displayProgression.name.rawValue))
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.top, (geo.size.height / 2) + 10)
            
            HStack {
                Spacer()
                Button {
                    let prev = viewModel.getPrevStageLevel(stage: stage, level: level)
                    withAnimation {
                        level = prev.level
                        scrollViewValue.scrollTo(progressions[prev.stage])
                    }
                } label: {
                    Image(systemName: "arrow.left")
                }
                .foregroundColor(.themeColor)
                .tint(.themeColor)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .opacity(stage == 0 && level == .beginner ? 0.25 : 1)
                .disabled(stage == 0 && level == .beginner)
                Spacer()
                VStack {
                    Text("\(sets) x \(reps) \(displayProgression.showSecondsForReps == true ? "seconds" : "reps")")
                        .font(.title2.bold())
                        .contentTransition(.numericText())
                    Text(String(localized: level.localizedStringResource))
                }
                Spacer()
                Button {
                    let next = viewModel.getNextStageLevel(stage: stage, level: level)
                    withAnimation {
                        level = next.level
                        scrollViewValue.scrollTo(progressions[next.stage])
                    }
                } label: {
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.themeColor)
                .tint(.themeColor)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .opacity(stage == 9 && level == .progression ? 0.25 : 1)
                .disabled(stage == 9 && level == .progression)
                Spacer()
            }
            .padding()
            if isCurrentLevel {
                Text("Current level")
            } else {
                Text(" ")
            }
            Spacer()
            Button(isCurrentLevel ? "Keep level" : "Change level") {
                saveProgression(newProgression: displayProgression, newLevel: level, dismiss: dismiss)
            }
            .foregroundColor(.white)
            .tint(.themeColor)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            Spacer()
        }
        .onAppear {
            stage = displayProgression.stage
        }
    }
    
    func saveProgression(newProgression: Progression, newLevel: Level, dismiss: DismissAction) {
        userExerciseStages.setStageAndLevel(for: newProgression.type, stage: newProgression.stage, level: newLevel)
        dismiss()
    }
}

#Preview {
    @Environment(\.dismiss) var dismiss
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return ScrollViewReader { scrollViewValue in
        GeometryReader { geo in
            ChangeProgression(
                progressions: Progression.defaultProgressionSingleType,
                displayProgression: Progression.defaultProgressionSingleType[1],
                level: .constant(.intermediate),
                startingIndex: 3,
                startingLevel: .intermediate,
                scrollViewValue: scrollViewValue,
                geo: geo,
                userExerciseStages: UserExerciseStages(),
                dismiss: dismiss
            )
        }
    }
}
