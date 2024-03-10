//
//  JournalView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 15/08/2023.
//

import SwiftUI
import SwiftData

// TODO: Display a raw data log view with dates and number of details of sets recorded per day
// TODO: Make this standalone

// TODO: Create a export CSV option
// TODO: Create an import option also

// TODO: Display a days completed view of the current week
// TODO: Display a month view with days marked complete, incomplete or empty

struct JournalView: View {
    
    @Query private var journalEntries: [JournalEntry]
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.darkBg)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "chevron.left.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                Text("You have recorded **\(journalEntries.count)** sets so far.")
                    .padding()
                TrainingLog(monthGroupedEntries: monthGroupedEntries)
                .navigationTitle("Journal")
            }
        }
        .background(Color.darkBg)
    }
    
    private var monthGroupedEntries: [(date: Date, formattedDate: String, entries: [GroupedJournalEntries])] {
        let groupedByMonth = Dictionary(grouping: groupedEntries) { groupedEntry in
            let components = Calendar.current.dateComponents([.year, .month], from: groupedEntry.date)
            return Calendar.current.date(from: components)!
        }

        let sortedMonths = groupedByMonth.keys.sorted(by: >)

        return sortedMonths.map { month in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM, YYYY"
            let dateFormatted = formatter.string(from: month)
            
            let entries = groupedByMonth[month]!
            return (month, dateFormatted, entries)
        }
    }
    
    private var groupedEntries: [GroupedJournalEntries] {
        let groupedByDay = Dictionary(grouping: journalEntries) { entry in
            return Calendar.current.startOfDay(for: entry.date)
        }

        let sortedGroups = groupedByDay.keys.sorted(by: >)

        return sortedGroups.map { date in
            let entries = groupedByDay[date]!
            let entriesByExerciseType = Dictionary(grouping: entries, by: { $0.exerciseType })
            return GroupedJournalEntries(date: date, entries: entriesByExerciseType)
        }
    }
}

struct GroupedJournalEntries: Identifiable {
    let id = UUID()
    let date: Date
    let entries: [ExerciseType: [JournalEntry]]

    var dateFormatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        let day = Calendar.current.component(.day, from: date)
        let ordinalDay = numberFormatter.string(from: NSNumber(value: day)) ?? "\(day)"

        return "\(formatter.string(from: date)), \(ordinalDay)"
    }
}

#Preview {
    JournalView()
        .modelContainer(DataController.previewContainer)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
