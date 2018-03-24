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
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    func endOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
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

