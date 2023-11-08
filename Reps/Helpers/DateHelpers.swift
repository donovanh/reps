//
//  DateHelpers.swift
//  Reps
//
//  Created by Donovan Hutchinson on 07/11/2023.
//

import Foundation

func getCurrentDate() -> Date {
    let currentDate = Date()
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
    
    if let date = calendar.date(from: dateComponents) {
        return date
    } else {
        fatalError("Failed to construct a date from components")
    }
}
