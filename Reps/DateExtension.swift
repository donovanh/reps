//
//  DateExtension.swift
//  Reps
//
//  Created by Donovan Hutchinson on 01/02/2024.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    func daysOffset(offset: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: offset, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
}
