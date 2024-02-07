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
    @State var screenWidth: CGFloat
    
    @State private var displayIndex = 0
    @State private var displayLevel: Level = .beginner
    
    @State private var offset = CGFloat.zero
    @State private var currentExerciseIndex: Int = 0
    @State private var currentAnimationOpacity: CGFloat = 1.0
    @State private var currentXOffset: Double = 0.0
    @State private var animationFileName: String = "not-set"
    
    var body: some View {
        GeometryReader { geo in
            let halfHeight = geo.size.height / 2
            let maxWidth = geo.size.width - 40
            let animationHeight = halfHeight > maxWidth ? maxWidth : halfHeight
            ZStack {
                VStack {
                    HStack {
                        if animationFileName != "not-set" {
                            ZStack {
                                ZStack {
                                    Ellipse()
                                        .fill(Color.lightAnimationBg)
                                        .frame(width: geo.size.width, height: geo.size.width / 1.5)
                                        .rotationEffect(.degrees(45))
                                        .offset(x: currentXOffset * 0.5, y: 20)
                                        .blur(radius: 14)
                                    AnimationView(
                                        progressionAnimationName: animationFileName,
                                        height: animationHeight
                                    )
                                    .offset(x: currentXOffset, y: 0)
                                }
                                .opacity(currentAnimationOpacity)
                            }
                            
                        }
                    }
                    Spacer()
                }
                GeometryReader { geo in
                    ScrollViewReader { scrollViewValue in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(progressions, id: \.self) { displayProgression in
                                    Section {
                                        ZStack {
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
                                                    startingIndex: 2,
                                                    scrollViewValue: scrollViewValue,
                                                    geo: geo,
                                                    userExerciseStages: userExerciseStages,
                                                    dismiss: dismiss
                                                )
                                            }
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
                                animationFileName = progressions[displayIndex].animationFileName
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .onAppear {
                            displayIndex = startingIndex
                            displayLevel = startingLevel
                            animationFileName = progressions[displayIndex].animationFileName
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
                    }
                }
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "multiply.circle")
                                    .foregroundStyle(Color.secondaryButtonBg)
                                    .font(.headline)
                            }
                            .padding()
                        }
                        Spacer()
                    }
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(Color.lightBg)
        }
    }
}



#Preview("Change Progression") {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader { geo in
        ProgressionViewer(
            userExerciseStages: UserExerciseStages(),
            viewToShow: .changeProgression,
            progressions: getProgressions(ofType: .pushup),
            startingIndex: 7,
            startingLevel: .intermediate,
            screenWidth: geo.size.width
        )
    }
}

#Preview("Record Workout") {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader { geo in
        ProgressionViewer(
            userExerciseStages: UserExerciseStages(),
            viewToShow: .workoutView,
            progressions: Progression.defaultProgressionMixedSet,
            startingIndex: 1,
            startingLevel: .intermediate,
            screenWidth: geo.size.width
        )
    }
}
