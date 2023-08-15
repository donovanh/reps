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
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var journalEntries: [JournalEntry]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if journalEntries.count > 0 {
                        let chunkedByYear = getChunkedByYear(entries: journalEntries)
                        ForEach(chunkedByYear, id: \.self) { yearEntries in
                            let year = getDatePartString(yearEntries.first?.date ?? Date(), format: "YYYY")
                            Text(year)
                                .font(.largeTitle)
                            let chunkedByMonth = getChunkedByMonth(entries: yearEntries)
                            ForEach(chunkedByMonth, id: \.self) { monthEntries in
                                let month = getDatePartString(monthEntries.first?.date ?? Date(), format: "LLLL")
                                Section(month) {
                                    MonthView(entries: monthEntries)
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
    
    func getDatePartString(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getChunkedByYear(entries: [JournalEntry]) -> [[JournalEntry]] {
        return entries.chunked {
            Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .year)
        }.map { Array($0) }
    }
    
    func getChunkedByMonth(entries: [JournalEntry]) -> [[JournalEntry]] {
        return entries.chunked {
            Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .month)
        }.map { Array($0) }
    }
}

struct MonthView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    
    let entries: [JournalEntry]
    
    var body: some View {
        let chunkedDays = getChunkedByDay(entries: entries)
        ForEach(chunkedDays, id: \.self) { dayEntries in
            DisclosureGroup {
                // Chunk by exerciseType, display each type for the day as a single item
                let chunkedDayEntries = getChunkedByExerciseType(entries: entries)
                
                ForEach(chunkedDayEntries, id: \.self) { exerciseTypeEntries in
                    let entry = exerciseTypeEntries[0]
                    if users.first != nil {
                        let progression = getExercise(ofType: entry.exerciseType, atStage: users.first?.getStage(forType: entry.exerciseType) ?? 1)
                        let exerciseTypeName = ExerciseType(rawValue: entry.exerciseType)!.localizedStringResource
                        if let progressionName = progression?.name {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(String(localized: progressionName.rawValue))
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
                                    let repsString = exerciseTypeEntries.map { "\($0.reps)" }.joined(separator: ", ")
                                    Text(repsString)
                                }
                                .font(.caption)
                            }
                            .padding(10)
                        }
                    }
                }
            } label: {
                Text("\(getDateFormatted(dayEntries.first!.date))")
            }
        }
    }
    
    func getDateFormatted(_ date: Date) -> String {
        let weekDay = date.formatted(Date.FormatStyle().weekday(.wide))
        let dayNum = date.formatted(Date.FormatStyle().day(.defaultDigits))
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let dayWithOrdinal = formatter.string(from: NSNumber(value: Int(dayNum) ?? 0))
        return "\(weekDay), \(dayWithOrdinal!)"
    }
    
    func getChunkedByDay(entries: [JournalEntry]) -> [[JournalEntry]] {
        return entries.chunked {
            Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .day)
        }.map { Array($0) }
    }
    
    func getChunkedByExerciseType(entries: [JournalEntry]) -> [[JournalEntry]] {
        return entries.sorted(by: { $0.exerciseType > $1.exerciseType }).chunked {
            $0.exerciseType == $1.exerciseType
        }.map { Array($0) }
    }
}

//#Preview {
//    JournalView()
//}
