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
            MainView()
        }
        .modelContainer(for: [Routine.self, User.self])
    }
}
