import SwiftUI
import SwiftData

struct ProgressionViewer: View {
    
    enum ViewsToShow {
        case changeProgression, workoutView
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var viewModel = ViewModel()
    
    @State var dayViewModel: DayView.ViewModel
    let viewToShow: ViewsToShow
    let progressions: [Progression]
    let startingIndex: Int
    let startingLevel: Level
    let progressScore: Double
    @State var screenWidth: CGFloat
    
    @State private var displayIndex = 0
    @State private var displayLevel: Level = .beginner
    
    @State private var offset = CGFloat.zero
    @State private var currentExerciseIndex: Int = 0
    @State private var currentAnimationOpacity: CGFloat = 1.0
    @State private var currentXOffset: Double = 0.0
    @State private var animationFileName: String = "not-set"
    @State private var isScrolling = false
    
    var body: some View {
        GeometryReader { geo in
            let halfHeight = UIScreen.portraitHeight < 700 ? 250 : geo.size.height / 2
            let maxWidth = geo.size.width - 40
            let animationHeight = halfHeight > maxWidth ? maxWidth : halfHeight
            ZStack {
                VStack {
                    HStack {
                        if animationFileName != "not-set" {
                            ZStack {
                                ZStack {
                                    Ellipse()
                                        .fill(colorScheme == .dark ? Color.darkAnimationBg : Color.lightAnimationBg)
                                        .frame(width: geo.size.width, height: geo.size.width / 1.5)
                                        .rotationEffect(.degrees(45))
                                        .offset(x: currentXOffset * 0.5, y: 20)
                                        .blur(radius: 10)
                                    AnimationView(
                                        progressionAnimationName: animationFileName,
                                        height: animationHeight
                                    )
                                    .opacity(isScrolling ? 0 : 1)
                                    .animation(.easeOut, value: isScrolling)
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
                                                    progressScore: progressScore,
                                                    startingIndex: startingIndex,
                                                    startingLevel: startingLevel,
                                                    scrollViewValue: scrollViewValue,
                                                    geo: geo,
                                                    dayViewModel: dayViewModel,
                                                    dismiss: dismiss
                                                )
                                            case .workoutView:
                                                RecordExercise(
                                                    progressions: progressions,
                                                    displayProgression: displayProgression,
                                                    startingIndex: 2,
                                                    scrollViewValue: scrollViewValue,
                                                    geo: geo,
                                                    dayViewModel: dayViewModel,
                                                    dismiss: dismiss,
                                                    isScrolling: $isScrolling
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
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                            }
                            .controlSize(.extraLarge)
                            .tint(.secondary)
                            .padding()
                        }
                        Spacer()
                    }
                }
            }
            .padding(.vertical)
            .containerRelativeFrame([.horizontal, .vertical])
            .background(colorScheme == .dark ? Color.darkBg : Color.lightBg)
        }
    }
}



#Preview("Change Progression") {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader { geo in
        ProgressionViewer(
            dayViewModel: DayView.ViewModel(),
            viewToShow: .changeProgression,
            progressions: Progressions().getProgressions(ofType: .pushup),
            startingIndex: 7,
            startingLevel: .intermediate,
            progressScore: 0.5,
            screenWidth: geo.size.width
        )
        .preferredColorScheme(.dark)
    }
}

#Preview("Record Workout") {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader { geo in
        ProgressionViewer(
            dayViewModel: DayView.ViewModel(),
            viewToShow: .workoutView,
            progressions: Progression.defaultProgressionMixedSet,
            startingIndex: 1,
            startingLevel: .intermediate,
            progressScore: 0.5,
            screenWidth: geo.size.width
        )
        .modelContainer(DataController.previewContainer)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview("Record Timed Workout") {
    func mainAction(_: Progression, _: Level, _: Int, _: DismissAction, _: ScrollViewProxy?) {}
    return GeometryReader { geo in
        ProgressionViewer(
            dayViewModel: DayView.ViewModel(),
            viewToShow: .workoutView,
            progressions: Progression.defaultProgressionSingleTypeTimed,
            startingIndex: 2,
            startingLevel: .intermediate,
            progressScore: 0.5,
            screenWidth: geo.size.width
        )
        .modelContainer(DataController.previewContainer)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

