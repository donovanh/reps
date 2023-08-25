//
//  PlanOverviewView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/08/2023.
//

import SwiftUI

struct PlanOverviewView: View {
    
    @Binding var level: ExperienceLevel
    @Binding var schedule: Schedule
    
    var body: some View {
        Text("Apply this plan")
            .font(.title)
        Text("Level: \(level.rawValue)")
        Text("Schedule: \(schedule.rawValue)")
        Text("Note: You can adjust these as needed in your weekly overview.")
    }
}

//#Preview {
//    PlanOverviewView()
//}
