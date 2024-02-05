import SwiftUI
import SwiftData

struct ProgressionViewer: View {
    
    enum ViewsToShow {
        case changeProgression, workoutView
    }
    
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    
    @State var userExerciseStages: UserExerciseStages
    let viewToShow: ViewsToShow
    let progressions: [Progression]
    let startingIndex: Int
    let startingLevel: Level
    let screenWidth: CGFloat
    
    @State private var displayIndex = 0
    @State private var displayLevel: Level = .beginner

    @State private var offset = CGFloat.zero
    @State private var currentExerciseIndex: Int = 0
    @State private var currentAnimationOpacity: CGFloat = 1.0
    @State private var currentXOffset: Double = 0.0
    @State private var currentProgressionAnimationName: String?
    
    var scrollWidth: CGFloat {
        viewModel.calculateScrollWidth(screenWidth: screenWidth, numberOfProgressions: progressions.count)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    AnimationView(
                            progressionAnimationName: currentProgressionAnimationName ?? "pushup-01",
                            currentExerciseIndex: displayIndex
                        )
                        .frame(height: geo.size.height / 2)
                        .padding(.horizontal)
                        .opacity(currentAnimationOpacity)
                        .offset(x: currentXOffset, y: 0)
                    Spacer()
                }
                ScrollViewReader { scrollViewValue in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(progressions, id: \.self) { displayProgression in
                                HStack {
                                    switch viewToShow {
                                    case .changeProgression:
                                        ChangeProgression(
                                            progressions: progressions,
                                            displayProgression: displayProgression,
                                            level: $displayLevel,
                                            startingIndex: startingIndex,
                                            startingLevel: startingLevel,
                                            scrollViewValue: scrollViewValue,
                                            geo: geo,
                                            userExerciseStages: userExerciseStages,
                                            dismiss: dismiss
                                        )
                                    case .workoutView:
                                        RecordExercise(
                                            progressions: progressions,
                                            displayProgression: displayProgression,
                                            level: displayLevel,
                                            startingIndex: 2,
                                            scrollViewValue: scrollViewValue,
                                            geo: geo,
                                            userExerciseStages: userExerciseStages,
                                            dismiss: dismiss
                                        )
                                    }
                                }
                                .id(displayProgression)
                                .frame(width: geo.size.width)
                            }
                        }
                        .background(GeometryReader {
                            Color.clear.preference(key: ProgressionViewer.ViewModel.ViewOffsetKey.self,
                                value: -$0.frame(in: .named("scroll")).origin.x)
                        })
                        .onPreferenceChange(ProgressionViewer.ViewModel.ViewOffsetKey.self) {
                            displayIndex = viewModel.visibleExerciseIndex(screenWidth: screenWidth, forOffset: $0)

                            // Animation settings
                            currentXOffset = viewModel.calculateXOffset(screenWidth: screenWidth, forOffset: $0)
                            currentAnimationOpacity = viewModel.calculateOpacityOfAnimation(screenWidth: screenWidth, forOffset: $0, numberOfExercises: progressions.count)
                            currentProgressionAnimationName = progressions[displayIndex].animationFileName
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .onAppear {
                        displayIndex = startingIndex
                        displayLevel = startingLevel
                        DispatchQueue.main.async() {
                            scrollViewValue.scrollTo(progressions[startingIndex])
                        }
                    }
                    
                    Spacer()
                    
                    // Progress Indicator
                    HStack {
                        ForEach(progressions, id: \.self) { progression in
                            let displayProgression = progressions[displayIndex]
                            Circle()
                                .background(.thickMaterial)
                                .opacity(displayProgression == progression ? 0.75 : 0.25)
                                .frame(width: 10)
                                .padding(2)
                                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: displayIndex)
                        }
                    }
                    .padding(.bottom)
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader{ geo in
        ProgressionViewer(
            userExerciseStages: UserExerciseStages(),
            viewToShow: .changeProgression,
            progressions: getProgressions(ofType: .pushup),
            startingIndex: 2,
            startingLevel: .intermediate,
            screenWidth: geo.size.width
        )
    }
}
