//
//  ProgressionScores.swift
//  Reps
//
//  Created by Donovan Hutchinson on 02/03/2024.
//

import SwiftData
import SwiftUI

// TODO: Revisit this perhaps if wanting to show a wider set of graphs for historical purposes,
// Otherwise just focus on current progressions, or make a viewer mode to navigate back through the history and generate data as needed

struct ProgressionScores: View {
    @Query private var journalEntries: [JournalEntry]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("All progression scores")
                Section {
                    // Optimise - create a function like generateScores but for a specific progression / level
                    // Loop over all 6 exercise types and generate the latest scores for the current progression
                    // Later a way to explore previous progressions might be useful, for now it's overkill
                    // Optimse 2: Generate static files containing a year's worth of training data
                    let groupedResults = Dictionary(grouping: JournalEntry.generateScores(entries: journalEntries)) { entry in
                        return entry.key.type
                    }
                    ForEach(Array(groupedResults), id: \.key) { exerciseType, progressionTuple in
                        Text("\(exerciseType.rawValue)")
                            .font(.title.bold())
                        
                        ForEach(Array(progressionTuple), id: \.key) { progression, level in
                            SingleProgressionScores(progression: progression, levelScores: level)
                        }
                        
                    }
                }
            }
            .frame(width: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
        .onAppear {
            // TODO: Optimisation: Have the heavy lifting happen once on load then
            // Each exercise update the current value
        }
    }
}

struct SingleProgressionScores: View {
    var progression: Progression
    var levelScores: [Level : [JournalEntry.ProgressionScore]]
    
    var body: some View {
        Text(progression.name.rawValue)
            .font(.title2)
        ForEach(Array(levelScores), id: \.key) { level, progressionScores in
            Text("\(level.rawValue)")
                // Join scores on the same day
                ForEach(progressionScores) { progressionScore in
                    Text(" \(progressionScore.score) - \(progressionScore.date)")
                        .font(.caption)
                }
        }
    }
}

#Preview {
    ProgressionScores()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        .modelContainer(DataController.previewContainer)
}
