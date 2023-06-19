//
//  Date.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 07/06/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation
import UIKit

open class DateUtils {
    class func timestampToDateString(short: Bool = false, timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET" // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) // Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = short ? "MM/dd" : "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func timestampToDate(timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    class func weeklyModeMinDate(timestamp: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: timestamp)
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: 8, to: date) ?? Date()
        return Calendar.current.date(byAdding: .day, value: -1, to: oneWeekLater) ?? Date()
    }
    
    class func weeklyModeMaxDate(timestamp: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: timestamp)
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: 6, to: date) ?? Date()
        return Calendar.current.date(byAdding: .day, value: 1, to: oneWeekLater) ?? Date()
    }
    
    class func monthlyModeMinDate(timestamp: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: timestamp)
        let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? Date()
        return Calendar.current.date(byAdding: .day, value: 0, to: oneMonthLater) ?? Date()
    }
    
    class func monthlyModeMaxDate(timestamp: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: timestamp)
        let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? Date()
        return Calendar.current.date(byAdding: .day, value: 0, to: oneMonthLater) ?? Date()
    }
}
