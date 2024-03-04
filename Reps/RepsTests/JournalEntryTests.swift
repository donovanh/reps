//
//  JournalEntryTests.swift
//  Reps
//
//  Created by Donovan Hutchinson on 02/03/2024.
//

import XCTest
@testable import Reps

class JournalEntryTests: XCTestCase {
    
    // TODO: Think of a reasonably simple scoring system
    
    // IDEA: Each time an exercise is recorded, adjust the progression's score
    // WHat then if they don't use the app, how does it impact the score?
    // On opening app, check back through journal entries for each exercise type,
    // and for each week, make some adjustment back toward 0.5 (neither up nor down)
    // Store ProgressionScore array in SwiftData

//    func testReadinessScore() {
//        // Mock data for testing
//        // Pushups, level 0, .beginner
//        // Not missing any weeks
//        // Hitting reps 3 times per week
//        // Expected result after 4 weeks, score should be 1
//        let currentDate = Date()
//        let entries: [JournalEntry] = [
//            // Current week
//            JournalEntry(date: currentDate, exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -1), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -2), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            // Week-1
//            JournalEntry(date: currentDate.daysOffset(offset: -7), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -8), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -9), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            // Week-2
//            JournalEntry(date: currentDate.daysOffset(offset: -14), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -15), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -16), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            // Week-3
//            JournalEntry(date: currentDate.daysOffset(offset: -21), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -22), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10),
//            JournalEntry(date: currentDate.daysOffset(offset: -23), exerciseType: .pushup, stage: 0, level: .beginner, reps: 10)
//        ]
//
//        // Replace with your specific exercise type
//        let exerciseType: ExerciseType = .pushup
//
//        // Replace with your specific past weeks value
//        let pastWeeks = 1
//
//        let score = JournalEntry.readinessScore(forExerciseType: exerciseType, fromEntries: entries, pastWeeks: pastWeeks)
//
//        // Replace with your expected readiness score based on the test data
//        XCTAssertEqual(score, 0.5, accuracy: 0.01, "Readiness score is not as expected")
//    }

    // Add more test cases as needed

}
