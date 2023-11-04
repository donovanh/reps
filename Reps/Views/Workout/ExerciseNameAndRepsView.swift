import SwiftUI

struct ExerciseNameAndRepsView: View {
    
    let progression: Progression
    let reps: Int
    
    var body: some View {
        VStack {
            Text(String(localized: progression.name.rawValue))
                .font(.title)
                .fontWeight(.bold)
            
            Text("\(reps)")
                .font(.system(size: 128))
                .fontWeight(.heavy)
                .padding(.bottom, -40)
            
            if progression.showSecondsForReps == true {
                Text("seconds")
                    .font(.title)
            } else {
                if progression.showForEachSide == true {
                    Text("reps (each side)")
                        .font(.title)
                } else {
                    Text("reps")
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    ExerciseNameAndRepsView(
        progression: pullupDataSet[1],
        reps: 9000
    )
}
