//
//  JournalView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 15/08/2023.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    
    @Query private var journalEntries: [JournalEntry]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.darkBg)
                .ignoresSafeArea()
            VStack {
                Text("Coming soon")
                    .font(.title.bold())
                Text("You have recorded **\(journalEntries.count)** sets so far.")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 80)
                    .multilineTextAlignment(.center)
            }
        }
        .background(Color.darkBg)
    }
}

#Preview {
    JournalView()
        .modelContainer(DataController.previewContainer)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
