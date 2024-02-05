//
//  JournalView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 15/08/2023.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    
    var body: some View {
        Text("Journal TODO")
    }
}

#Preview {
    JournalView()
        .modelContainer(DataController.previewContainer)
}
