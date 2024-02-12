//
//  RepsApp.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import SwiftUI
import SwiftData

@main
struct RepsApp: App {
    
    var body: some Scene {
        WindowGroup {
//            Icon(exerciseType: .pushup, stage: 6, size: 900, complete: true)
//                .background(Color.darkBg)
//                .padding()
            DayView(day: Date().dayNumberOfWeek() ?? 0)
                .background(Color.blue.edgesIgnoringSafeArea(.all))
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
        .modelContainer(for: [JournalEntry.self])
    }
}
