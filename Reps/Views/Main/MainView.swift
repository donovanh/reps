//
//  MainView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 26/07/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            TabView {
                TodayView()
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                            Text("Today")
                        }
                    }
                
                WeekView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book.pages")
                            Text("Week")
                        }
                    }
                
                JournalView()
                    .tabItem {
                        VStack {
                            Image(systemName: "chart.bar.xaxis")
                            Text("Journal")
                        }
                    }
            }
        }
    }
}

//#Preview {
//    MainView()
//}
