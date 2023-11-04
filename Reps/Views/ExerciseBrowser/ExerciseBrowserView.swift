import SwiftUI

struct ExerciseBrowserView: View {
    
    @State private var selectedExerciseType: ExerciseType = ExerciseType.pushup
    @State private var selectedProgression: Int = 1
    @State private var animationName: String = "pushup-01"
    @State private var isAnimating = false
    
    @Binding var showingExerciseBrowserView: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingExerciseBrowserView = false
                    } label: {
                        Text("Close")
                    }
                    .padding(20)
                }
                Spacer()
                AnimationView(
                    baseModel: "base-model",
                    currentProgressionAnimationName: animationName,
                    currentExerciseIndex: 1,
                    width: geo.size.width,
                    height: geo.size.width
                )
                .opacity(isAnimating ? 1 : 0)
                .onAppear {
                    setAnimationName()
                    withAnimation {
                        isAnimating = true
                    }
                }
                .onChange(of: selectedExerciseType) {
                    isAnimating = false
                    withAnimation {
                        isAnimating = true
                    }
                }
                .onChange(of: selectedProgression) {
                    isAnimating = false
                    withAnimation {
                        isAnimating = true
                    }
                }
                Form {
                    VStack {
                        Picker("Exercise Type", selection: $selectedExerciseType) {
                            ForEach(ExerciseType.allCases, id: \.self) { exercise in
                                Text(exercise.localizedStringResource)
                                    .tag(exercise)
                            }
                        }
                        .onChange(of: selectedExerciseType) {
                            selectedProgression = 1
                            setAnimationName()
                        }
                        Picker("Progression", selection: $selectedProgression) {
                            let progressions = getExercises(ofType: selectedExerciseType)
                            ForEach(progressions, id: \.self) { progression in
                                Text(String(localized: progression.name.rawValue))
                                    .tag(progression.stage)
                            }
                        }
                        .onChange(of: selectedProgression) {
                            setAnimationName()
                        }
                    }
                }
            }
        }
    }
    
    func setAnimationName() {
        let progression = getExercise(ofType: selectedExerciseType, atStage: selectedProgression)
        animationName = progression?.animationFileName ?? "pushup-01"
    }
}

#Preview {
    ExerciseBrowserView(showingExerciseBrowserView: .constant(true))
}
