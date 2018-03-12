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
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

