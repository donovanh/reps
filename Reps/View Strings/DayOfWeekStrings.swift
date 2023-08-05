//
//  DayOfWeekStrings.swift
//  Reps
//
//  Created by Donovan Hutchinson on 04/08/2023.
//

import Foundation
import SwiftUI

extension DayOfWeek {
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
}
