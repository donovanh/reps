//
//  TimerView.swift
//  Reps
//
//  Created by Donovan Hutchinson on 18/02/2024.
//

// TODO: Ability to tweak number of recorded seconds

import SwiftUI

struct TimerView: View {
    
    @State private var viewModel = ViewModel()
    
    let displayProgression: Progression
    let level: Level
    let saveAction: (_ progression: Progression, _ level: Level, _ reps: Int) -> Void
    
    var body: some View {
        VStack {
            Picker(selection: $viewModel.selectedPickerOption) {
                ForEach(viewModel.pickerOptions, id: \.self) { option in
                    Text(option)
                }
            } label: {
                Text("Timer or manual entry")
            }
            .onChange(of: viewModel.selectedPickerOption) {
                if viewModel.selectedPickerOption == "Manual" {
                    viewModel.stopTimer()
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 80)
            .padding(.vertical)
            .onAppear {
                viewModel.targetSeconds = Double(displayProgression.getReps(for: level))
                viewModel.timeRemaining = viewModel.targetSeconds
            }
            if viewModel.selectedPickerOption == "Timer" {
                let buttonWidth = 80.0
                let isResetActive = viewModel.timeAchieved > 0 || viewModel.isCountdownRunning
                HStack {
                    Button {
                        viewModel.resetTimer()
                    } label: {
                        Text("Reset")
                            .frame(width: 60, height: 60)
                            .foregroundColor(isResetActive ? Color.themeColor : Color.secondary)
                            .overlay(
                                Circle()
                                .stroke(isResetActive ? Color.themeColor : Color.secondary, lineWidth: 1)
                            )
                    }
                    VStack {
                        Text("\(viewModel.timeDisplay)")
                            .font(.system(size: 42).bold())
                            .foregroundStyle(viewModel.timeAchieved > viewModel.targetSeconds ? .green : .primary)
                            .contentTransition(.numericText(countsDown: !(viewModel.timeAchieved > viewModel.targetSeconds)))
                            .padding(.top, -10)
                            .padding(.bottom, -5)
                            .monospacedDigit()
                            .onReceive(viewModel.timer) { time in
                                withAnimation {
                                    viewModel.incrementTimer()
                                }
                            }
                        Text("seconds")
                            .foregroundStyle(viewModel.timeAchieved > viewModel.targetSeconds ? .green : .primary)
                        
                    }
                    .frame(width: 125)
                    VStack {
                        if viewModel.isTimerRunning {
                            Button {
                                viewModel.stopTimer()
                            } label: {
                                Text("Stop")
                            }
                        } else {
                            Button {
                                if viewModel.countdownTarget > 0 {
                                    if viewModel.isCountdownRunning {
                                        viewModel.resetTimer()
                                    } else {
                                        viewModel.startCountdown()
                                    }
                                } else {
                                    viewModel.startTimer()
                                }
                            } label: {
                                if viewModel.isCountdownRunning {
                                    Text("\(viewModel.countdownTarget)")
                                        .font(.largeTitle)
                                        .contentTransition(.numericText(countsDown: true))
                                } else {
                                    Text(viewModel.timeAchieved > 0 ? "Resume" : "Start")
                                }
                            }
                        }
                    }
                    .frame(width: buttonWidth, height: buttonWidth)
                    .foregroundColor(Color.themeColor)
                    .overlay(
                        Circle()
                        .stroke(Color.themeColor, lineWidth: 1)
                    )
                    .onReceive(viewModel.countdownTimer) { time in
                        if viewModel.countdownTarget > 1 {
                            withAnimation {
                                viewModel.countdown()
                            }
                        } else {
                            viewModel.startTimer()
                        }
                    }
                }

                VStack {
                    Button {
                        saveAction(displayProgression, level, Int(viewModel.timeAchieved.rounded()))
                    } label: {
                        Text(viewModel.timeAchieved > 0 ? "Log \(viewModel.timeAchieved.formatted(.number.precision(.fractionLength(0)))) seconds" : "Start")
                    }
                    .foregroundColor(.white)
                    .tint(.themeColor)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .opacity(!viewModel.isTimerRunning && viewModel.timeAchieved > 0 ? 1 : 0)
                .disabled(viewModel.isTimerRunning || viewModel.timeAchieved == 0.0)
                .padding()

                
            } else {
                RepsView(displayProgression: displayProgression, level: level, saveAction: saveAction)
            }
        }
    }
}

#Preview {
    func saveAction(_: Progression, _: Level, _: Int) {}
    return TimerView(
        displayProgression: Progression.defaultProgressionSingleTypeTimed[1],
        level: .beginner,
        saveAction: saveAction
    )
}
