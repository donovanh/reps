import SwiftUI

struct ExerciseItemView: View {
    
    let progression: Progression
    let exerciseType: ExerciseType
    let levelStr: String
    let setsDone: Int
    
    var body: some View {
        let level = Level(rawValue: levelStr) ?? .beginner
        let reps = progression.getReps(for: level)
        let sets = progression.getSets(for: level)
        
        HStack {
            VStack(alignment: .leading) {
                Text(String(localized: progression.name.rawValue))
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text(String(localized: exerciseType.localizedStringResource))
                    .font(.caption)
            }
            
            Spacer()
            
            if (progression.showSecondsForReps == true) {
                Text("\(sets) x \(reps) seconds")
            } else {
                Text("\(sets) x \(reps) reps")
            }
            
            if (setsDone >= sets) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio (contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: 20)
                }
            } else {
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio (contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 20)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        ExerciseItemView(
            progression: pullupDataSet[1],
            exerciseType: .pullup,
            levelStr: Level.intermediate.rawValue,
            setsDone: 1
        )
        ExerciseItemView(
            progression: pushupDataSet[5],
            exerciseType: .pushup,
            levelStr: Level.progression.rawValue,
            setsDone: 1
        )
        ExerciseItemView(
            progression: squatDataSet[1],
            exerciseType: .squat,
            levelStr: Level.intermediate.rawValue,
            setsDone: 1
        )
    }
}
