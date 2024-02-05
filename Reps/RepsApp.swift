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
            //AnimationView2()
            DayView(day: Date().dayNumberOfWeek() ?? 0)
        }
        .modelContainer(for: [JournalEntryV2.self])
    }
}
