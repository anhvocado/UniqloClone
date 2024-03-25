//
//  Date+Extension .swift
//  VideoApp
//
//  Created by IchNV on 6/4/20.
//  Copyright © 2020 IchNV-D1. All rights reserved.
//

import UIKit
import Foundation

// MARK: - General
extension Date {
    // MARK: - Variables
    static let currentCalendar = Calendar(identifier: .gregorian)
    static let currentTimeZone = TimeZone.ReferenceType.local
    
    init(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.hour = hour
        dc.minute = minute
        dc.second = second
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    func components(calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            era: calendar.component(.era, from: self),
                                            year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self),
                                            day: calendar.component(.day, from: self),
                                            hour: calendar.component(.hour, from: self),
                                            minute: calendar.component(.minute, from: self),
                                            second: calendar.component(.second, from: self),
                                            nanosecond: calendar.component(.nanosecond, from: self),
                                            weekday: calendar.component(.weekday, from: self),
                                            weekdayOrdinal: calendar.component(.weekdayOrdinal, from: self),
                                            quarter: calendar.component(.quarter, from: self),
                                            weekOfMonth: calendar.component(.weekOfMonth, from: self),
                                            weekOfYear: calendar.component(.weekOfYear, from: self),
                                            yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self))
        return dateComponents
    }
    
    func stringBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> String {
        let dateFormatter = DateFormatter()
        // fix https://prograils.com/posts/the-curious-case-of-the-24-hour-time-format-in-swift
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        dateFormatter.amSymbol = ""
        dateFormatter.pmSymbol = ""
        dateFormatter.locale = Locale(identifier: "en_US")
        // end fix
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
