//
//  WeeklyOverview.swift
//  Reps
//
//  Created by Donovan Hutchinson on 09/03/2024.
//

import SwiftData
import SwiftUI

// TODO: Drive starting day of week by locale (sunday for certain country(s)
// TODO: Use geo to make it fit neatly

struct WeeklyOverview: View {
    
    @State var viewModel: DayView.ViewModel
    
    @Query private var journalEntries: [JournalEntry]
    private let todayNum: Int = Date().dayNumberOfWeek() ?? 1
    
    struct DailyStatus: Hashable {
        var dayNum: Int
        var count: Int
        var done: Int
    }
    
    var startingDayNum: Int {
        switch Locale.current.firstDayOfWeek {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .saturday:
            return 7
        default:
            return 1
        }
    }
    
    var weeklyStatus: [DailyStatus] {
        var result: [DailyStatus] = []
        
        for day in startingDayNum..<(startingDayNum + 7) {
            let adjustedDay = (day - 1) % 7 + 1 // Map to the 1-7 range
            result.append(
                DailyStatus(
                    dayNum: adjustedDay,
                    count: schedule(forDay: adjustedDay).count,
                    done: getExercisesCompleteCount(forDayNum: adjustedDay, currentDayNum: todayNum)
                )
            )
        }
        return result
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                ForEach(weeklyStatus, id: \.self) { dailyStatus in
                    let progress = dailyStatus.count > 0 ? Double(dailyStatus.done) / Double(dailyStatus.count) : 0
                    let dayName = viewModel.shortDayName(for: dailyStatus.dayNum)
                    CircularProgressView(
                        progress: progress,
                        size: 20,
                        bgColor: .gray,
                        highlightColor: Color.themeColor,
                        displayNum: dailyStatus.count,
                        label: dayName,
                        active: todayNum == dailyStatus.dayNum
                    )
                    .frame(maxWidth: geo.size.width / 7)
                }
            }
            .padding()
        }
        .frame(height: 80)
    }
    
    func schedule(forDay day: Int) -> [ExerciseType] {
        viewModel.weeklySchedule[day] ?? []
    }
    
    func getExercisesCompleteCount(forDayNum dayNum: Int, currentDayNum: Int) -> Int {
        // If day num is less than or equal to current day,
        if dayNum > currentDayNum {
            return 0
        }
        var setsDoneCount = 0
        // Get offset from today's day
        let offset = currentDayNum - dayNum
        
        // Calculate date that many days back
        let targetDate = Date().daysOffset(offset: 0 - offset)
        
        // For that day of the week get the schedule
        let daysExerciseTypes = schedule(forDay: dayNum)
        
        for exerciseType in daysExerciseTypes {
            // get required sets
            let progression = viewModel.getProgression(for: exerciseType)
            let level = viewModel.getLevel(for: exerciseType)
            let requiredSets = progression.getSets(for: level)
            let setsDone = JournalEntry.getSetsDone(
                entries: journalEntries,
                forDate: targetDate,
                ofType: exerciseType,
                ofStage: progression.stage,
                ofLevel: level
            )
            
            if setsDone >= requiredSets {
                setsDoneCount += 1
            }
        }

        return setsDoneCount
    }
    
}

#Preview {
    WeeklyOverview(
        viewModel: DayView.ViewModel()
    )
}
