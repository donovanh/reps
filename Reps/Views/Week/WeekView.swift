//
//  ContentView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import SwiftUI
import SwiftData

struct WeekView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @State private var isPresentingAddExercise: Bool = false
    @State private var showingPlanBuilder = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Button {
                            showingPlanBuilder.toggle()
                        } label: {
                            Text("Build new plan")
                        }
                        Spacer()
                        EditButton()
                    }
                    .padding()
                    List {
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            DayView(day: day)
                        }
                    }
                }
            }
            .navigationTitle("Weekly Plan")
        }
        .sheet(isPresented: $showingPlanBuilder) {
            PlanBuilderView(showingPlanBuilder: $showingPlanBuilder)
        }
    }
}

//
//#Preview {
//    WeekView()
//        .modelContainer(for: Routine.self)
//}
