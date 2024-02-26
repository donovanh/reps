//
//  TrainingLog.swift
//  Reps
//
//  Created by Donovan Hutchinson on 25/02/2024.
//

import SwiftUI

struct TrainingLog: View {
    var monthGroupedEntries: [(date: Date, formattedDate: String, entries: [GroupedJournalEntries])]
    
    var body: some View {
        Text("Daily log")
            .font(.title.bold())
            .padding(.top)
            .padding(.leading)
        List {
            ForEach(monthGroupedEntries, id: \.date) { month in
                Section(month.formattedDate) {
                    ForEach(month.entries, id: \.date) { (entriesByExerciseType: GroupedJournalEntries) in
                        DisclosureGroup(entriesByExerciseType.dateFormatted) {
                            ForEach(entriesByExerciseType.entries.keys.sorted(), id: \.self) { (exerciseType: ExerciseType) in
                                if let entries: [JournalEntry] = entriesByExerciseType.entries[exerciseType] {
                                    TrainingLogEntryView(exerciseType: exerciseType, entries: entries)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    
}

struct TrainingLogEntryView: View {
    
    let exerciseType: ExerciseType
    let entries: [JournalEntry]
    
    var body: some View {
        
        let entriesByStage = Dictionary(grouping: entries, by: { $0.stage })

        ForEach(Array(entriesByStage), id: \.key) { entryTuple in
            let stage = entryTuple.key
            let entries = entryTuple.value
            
            let progression = getProgression(forType: exerciseType, atStage: stage)
            
            HStack {
                Text(String(localized: progression.name.rawValue))
                Spacer()
                ForEach(entries, id: \.id) { (entry: JournalEntry) in
                    Text("\(entry.reps)\(progression.showSecondsForReps == true ? "s" : "")")
                }
            }
        }
        
    }
    
    func getProgression(forType type: ExerciseType, atStage stage: Int) -> Progression {
        return Progressions().getProgression(ofType: type, atStage: stage) ?? Progression.defaultProgression
    }
}

#Preview {
    TrainingLog(monthGroupedEntries: [])
}
