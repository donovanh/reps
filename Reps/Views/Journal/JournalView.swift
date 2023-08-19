//
//  JournalView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 15/08/2023.
//

import SwiftUI
import SwiftData
import Algorithms

struct JournalView: View {
    
    // TODO: Redo this maybe as a calendar with sheet containing day's summary
    // And some graphs
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var journalEntries: [JournalEntry]
    
    let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if journalEntries.count > 0 {
                        let groupedEntries = groupEntriesByYearMonthDay(entries: journalEntries)
                        
                        ForEach(Array(groupedEntries.keys.sorted()), id: \.self) { yearKey in
                            if let yearDate = self.yearFormatter.date(from: "\(yearKey)") {
                                Text(self.yearFormatter.string(from: yearDate))
                                    .font(.largeTitle)
                                    .bold()
                            }
                            ForEach(Array(groupedEntries[yearKey]!.keys.sorted()), id: \.self) { monthKey in
                                Text(monthFormatter.monthSymbols[monthKey - 1])
                                    .font(.title)
                                    .bold()
                                ForEach(Array(groupedEntries[yearKey]![monthKey]!.keys.sorted()), id: \.self) { dayKey in
                                    let dayEntries = groupedEntries[yearKey]![monthKey]![dayKey]!
                                    let chunkedDayEntries = getChunkedByExerciseType(entries: dayEntries)
                                    if let dayDate = self.dateFormatter.date(from: "\(yearKey)-\(monthKey)-\(dayKey)") {
                                        DisclosureGroup {
                                            ForEach(chunkedDayEntries, id: \.self) { dayEntries in
                                                EntryView(dayEntries: dayEntries)
                                            }
                                        } label: {
                                            Text(self.dayFormatter.string(from: dayDate))
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        // TODO: Icon for empty journal
                        Text("No journal entries yet!")
                    }
                }
                .padding()
            }
            .navigationTitle("Journal")
        }
    }
    
    func groupEntriesByYearMonthDay(entries: [JournalEntry]) -> [Int: [Int: [Int: [JournalEntry]]]] {
        var groupedEntries: [Int: [Int: [Int: [JournalEntry]]]] = [:]

        let calendar = Calendar.current
        let dateComponents: Set<Calendar.Component> = [.year, .month, .day]

        for entry in entries {
            let components = calendar.dateComponents(dateComponents, from: entry.date)

            if let year = components.year,
               let month = components.month,
               let day = components.day {
                if groupedEntries[year] == nil {
                    groupedEntries[year] = [:]
                }

                if groupedEntries[year]![month] == nil {
                    groupedEntries[year]![month] = [:]
                }

                if groupedEntries[year]![month]![day] == nil {
                    groupedEntries[year]![month]![day] = []
                }

                groupedEntries[year]![month]![day]!.append(entry)
            }
        }

        return groupedEntries
    }
    
    func getChunkedByExerciseType(entries: [JournalEntry]) -> [[JournalEntry]] {
        return entries.sorted(by: { $0.exerciseType > $1.exerciseType }).chunked {
            $0.exerciseType == $1.exerciseType
        }.map { Array($0) }
    }
}

struct EntryView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    let dayEntries: [JournalEntry]
    
    var body: some View {
        if users.first != nil {
            let entry = dayEntries[0]
            let progression = getExercise(ofType: entry.exerciseType, atStage: users.first?.getStage(forType: entry.exerciseType) ?? 1)
            let exerciseTypeName = ExerciseType(rawValue: entry.exerciseType)!.localizedStringResource
            if let progressionName = progression?.name {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(String(localized: progressionName.rawValue))
                            .bold()
                        Spacer()
                        Text(String(localized: exerciseTypeName))
                            .font(.caption)
                    }
                    Spacer()
                    HStack {
                        if progression?.showSecondsForReps == true {
                            Text("Seconds: ")
                        } else {
                            Text("Reps: ")
                        }
                        let repsString = dayEntries.map { "\($0.reps)" }.joined(separator: ", ")
                        Text(repsString)
                    }
                    .font(.caption)
                }
                .padding(10)
            }
        }
    }
    
}

//#Preview {
//    JournalView()
//}
