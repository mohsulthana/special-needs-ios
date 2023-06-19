//
//  Date+Extension.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 07/06/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

extension Date {
    func firstDayThisWeek() -> Date {
        let now = Date()
        var calendar = Calendar(identifier: .iso8601)
        let yearForWeekOfYear = calendar.component(.yearForWeekOfYear, from: now)
        let weekNumber  = calendar.component(.weekOfYear, from: now)
        let startDate = DateComponents(calendar: calendar, weekOfYear: weekNumber, yearForWeekOfYear: yearForWeekOfYear).date!
        return startDate
    }
    
    func lastDayThisWeek() -> Date {
        let now = Date()
        var calendar = Calendar(identifier: .iso8601)
        let yearForWeekOfYear = calendar.component(.yearForWeekOfYear, from: now)
        let weekNumber  = calendar.component(.weekOfYear, from: now)
        let startDate = DateComponents(calendar: calendar, weekOfYear: weekNumber, yearForWeekOfYear: yearForWeekOfYear).date!
        let endDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate)!
        return endDate
    }
}
