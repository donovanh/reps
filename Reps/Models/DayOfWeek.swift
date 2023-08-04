//
//  DayOfWeek.swift
//  Reps
//
//  Created by Donovan Hutchinson on 23/07/2023.
//

import Foundation

enum DayOfWeek: String, Codable, CaseIterable  {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}

//func getDay(byIndex index: Int) -> String {
//    switch index {
//        case 0: return DayOfWeek.monday.rawValue
//        case 1: return DayOfWeek.tuesday.rawValue
//        case 2: return DayOfWeek.wednesday.rawValue
//        case 3: return DayOfWeek.thursday.rawValue
//        case 4: return DayOfWeek.friday.rawValue
//        case 5: return DayOfWeek.saturday.rawValue
//        case 6: return DayOfWeek.sunday.rawValue
//        default: return DayOfWeek.sunday.rawValue
//    }
//}
