//
//  DateExtensions.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/11/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import Foundation

enum FBSDateFormat: String {
    case dashYMD = "yyyy-MM-dd"
    case slashMDY = "MM/dd/yyyy"
}

extension Date {
    static func getDateFromDateStr(_ dateStr: String, _ dateFormat: FBSDateFormat) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter.date(from: dateStr)
    }
    
    static func getDateStrFromDate(_ date: Date, _ dateFormat: FBSDateFormat) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter.string(from: date)
    }
    
    static func getNextDateStr(_ dateStr: String, _ dateFormat: FBSDateFormat) -> String? {
        return Date.getNextNDaysDateStr(1, dateStr, dateFormat)
    }
    
    static func getNextNDaysDateStr(_ nextNDays: Int, _ dateStr: String, _ dateFormat: FBSDateFormat) -> String? {
        guard nextNDays > 0, let sureDate = Date.getDateFromDateStr(dateStr, dateFormat) else {
            return nil
        }
        
        return Date.getDateStrFromDate(sureDate.addingTimeInterval(Double(nextNDays) * 3600 * 24), dateFormat)
    }
}
