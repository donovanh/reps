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
                Text("Welcome to Reps")
                    .font(.largeTitle.bold())
                    .padding()
                Text("A guided approach to bodyweight exercises. Get strong at home with sets of exercises that progress with you.")
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Plan my weekly routine") {
                    markUserWelcomeDone()
                    isPresentingPlanBuilder = true
                }
                .tint(.themeColor)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
                Button("I'll manage it myself") {
                    markUserWelcomeDone()
                }
                .fontWeight(.bold)
                .foregroundColor(.white)
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
