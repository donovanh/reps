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
                            Image(systemName: "book.circle.fill")
                            Text("Today")
                        }
                    }
                
                WeekView()
                    .tabItem {
                        VStack {
                            Image(systemName: "menucard")
                            Text("Week")
                        }
                    }
                
                UserView()
                    .tabItem {
                        VStack {
                            Image(systemName: "info.circle")
                            Text("Settings")
                        }
                    }
            }
        }
    }
}

#Preview {
    MainView()
}
