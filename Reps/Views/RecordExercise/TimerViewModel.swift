//
//  TimerViewModel.swift
//  Reps
//
//  Created by Donovan Hutchinson on 18/02/2024.
//

import Foundation
import SwiftUI

extension TimerView {
    @Observable
    class ViewModel {
        var pickerOptions = ["Timer", "Manual"]
        var selectedPickerOption = "Timer"
        
        var targetSeconds = 0.0
        var timeAchieved = 0.0
        var isTimerRunning = false
        var timer = Timer.publish(every: 1 / 30, on: .main, in: .common)
        
        var countdownTarget = 5
        var isCountdownRunning = false
        var countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
        
        var timeRemaining = 0.0
        var hasPlayedSuccessSound = false
        
        var timeDisplay: String {
            let timeValue = timeAchieved > targetSeconds ? timeAchieved : timeRemaining
            return timeValue.formatted(.number.precision(.fractionLength(timeAchieved == 0.0 ? 0 : 1)))
        }
        
        // Audio
        let countdownSound = Bundle.main.audioPlayer(for: "tone1.wav", volume: 0.25)
        let timerStartSound = Bundle.main.audioPlayer(for: "confirmation_003.wav", volume: 0.75)
        let timerSuccessSound = Bundle.main.audioPlayer(for: "confirmation_004.wav", volume: 1)
        
        func startCountdown() {
            countdownSound.play()
            isCountdownRunning = true
            countdownTarget = 5
            countdownTimer =  Timer.publish(every: 1, on: .main, in: .common)
            _ = countdownTimer.connect()
        }
        
        func countdown() {
            countdownSound.play()
            countdownTarget -= 1
        }
        
        func stopCountdown() {
            isCountdownRunning = false
            countdownTarget = 5
            _ = countdownTimer.connect().cancel()
            countdownTimer =  Timer.publish(every: 1, on: .main, in: .common)
        }
        
        func startTimer() {
            timerStartSound.play()
            isCountdownRunning = true
            UIApplication.shared.isIdleTimerDisabled = true
            countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            
            isTimerRunning = true
            applyTimer()
            _ = timer.connect()
        }
        
        func incrementTimer() {
            timeAchieved += 1 / 30
            timeRemaining = max(0, targetSeconds - timeAchieved)
            if timeRemaining == 0.0 && !hasPlayedSuccessSound {
                hasPlayedSuccessSound = true
                timerSuccessSound.play()
            }
        }
        
        func resetTimer() {
            stopCountdown()
            isTimerRunning = false
            hasPlayedSuccessSound = false
            timeAchieved = 0.0
            timeRemaining = targetSeconds
            applyTimer()
        }
        
        func stopTimer() {
            stopCountdown()
            isTimerRunning = false
            UIApplication.shared.isIdleTimerDisabled = false
            timer.connect().cancel()
            applyTimer()
        }
        
        func applyTimer() {
            timer = Timer.publish(every: 1 / 30, on: .main, in: .common)
        }
    }
}
