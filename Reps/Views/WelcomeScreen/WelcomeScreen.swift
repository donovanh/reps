//
//  WelcomeScreen.swift
//  Reps
//
//  Created by Donovan Hutchinson on 10/02/2024.
//
// TODO: Open the plan builder
// TODO: Skip plan builder
// TODO: Animate in and away

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("isUserWelcomeDone") var isUserWelcomeDone = false
    
    @Binding var isPresentingWelcomeScreen: Bool
    @Binding var isPresentingPlanBuilder: Bool
    
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.darkBg)
                .ignoresSafeArea()
            VStack {
                Text("Welcome!")
                    .font(.largeTitle.bold())
                    .padding()
                Text("Reps is designed to help you record and progress bodyweight exercises.")
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Let's get started!")
                Button("Create my weekly routine") {
                    markUserWelcomeDone()
                    isPresentingPlanBuilder = true
                }
                .tint(.themeColor)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
                Button("I'll manage it myself") {
                    markUserWelcomeDone()
                }
            }
        }
        .opacity(isShowing ? 1 : 0)
        .animation(.easeOut, value: isShowing)
        .onAppear {
            isShowing = true
        }
    }
    
    func markUserWelcomeDone() {
        isShowing = false
        isPresentingWelcomeScreen = false
        isUserWelcomeDone = true
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(.black.opacity(0.9))
            .ignoresSafeArea()
        WelcomeScreen(
            isPresentingWelcomeScreen: .constant(true),
            isPresentingPlanBuilder: .constant(false)
        )
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
