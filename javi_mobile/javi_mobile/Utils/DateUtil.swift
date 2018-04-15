//
//  DateUtil.swift
//  streetparking
//
//  Created by Thang Do on 1/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

enum DateFormat {
    case iso8601, rfc822, incompleteRFC822, atom
    case firebase
    case custom(String)
    
    func stringValue() -> String {
        var dateFormat = ""
        switch self {
        case .iso8601:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .rfc822:
            dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .incompleteRFC822:
            dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
        case .atom:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case .firebase:
            dateFormat = "M/d/yyyy HH:mm:ss"
        case .custom(let string):
            dateFormat = string
        }
        return dateFormat
    }
}

class DateUtil {
    static func serverDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = DateFormat.atom.stringValue()
        return df
    }
    
    static func displayDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = DateFormat.custom("dd/MM").stringValue()
        return df
    }
    
    static func displayHoursFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = DateFormat.custom("H").stringValue()
        return df
    }
}

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? Date()
    }
    
    func startOfWeek() -> Date? {
        //let gregorian = Calendar(identifier: .gregorian)
        //guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        //return gregorian.date(byAdding: .day, value: 1, to: sunday)
        return self.previous(.monday, considerToday: true)
    }
    
    func endOfWeek() -> Date? {
//        let gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
//        return gregorian.date(byAdding: .day, value: 7, to: sunday)
        return self.next(.sunday, considerToday: true)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
}

//Another
extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}

