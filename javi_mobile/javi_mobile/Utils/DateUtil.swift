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
        df.dateFormat = DateFormat.custom("MM/dd/yy").stringValue()
        return df
    }
    
    static func parkingRemainTimeString(from interval: TimeInterval) -> String {
        let hours: Int = Int(interval/(60*60))
        let minutes: Int = (Int(interval) - hours*60*60)/60
        let seconds: Int = Int(interval) - hours*60*60 - minutes*60
        var remainTimeString = ""
        if seconds != 0 {
            remainTimeString = "\(seconds)s"
        }
        if minutes != 0 {
            remainTimeString = "\(minutes)m \(remainTimeString)"
        }
        if hours != 0 {
            remainTimeString = "\(hours)h \(remainTimeString)"
        }
        if remainTimeString.isEmpty {
            remainTimeString = "0s"
        }
        return remainTimeString
    }
}
