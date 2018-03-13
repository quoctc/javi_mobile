//
//  DateExtension.swift
//  streetparking
//
//  Created by Thang Do on 1/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

extension Date {
    public var timeAgoSimple: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            return stringFromFormat("%dyr", withValue: components.year!)
        }
        
        if components.month! > 0 {
            return stringFromFormat("%dmo", withValue: components.month!)
        }
        
        // TODO: localize for other calanders
        if components.day! >= 7 {
            let value = components.day!/7
            return stringFromFormat("%dw", withValue: value)
        }
        
        if components.day! > 0 {
            return stringFromFormat("%dd", withValue: components.day!)
        }
        
        if components.hour! > 0 {
            return stringFromFormat("%dh", withValue: components.hour!)
        }
        
        if components.minute! > 0 {
            return stringFromFormat("%dm", withValue: components.minute!)
        }
        
        if components.second! > 0 {
            return stringFromFormat("%ds", withValue: components.second! )
        }
        
        return ""
    }
    
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            if components.year! == 1 {
                return stringFromFormat("%d year ago", withValue: components.year!)
            } else {
                return stringFromFormat("%d years ago", withValue: components.year!)
                
            }
        }
        
        if components.month! > 0 {
            if components.month! == 1 {
                return stringFromFormat("%d month ago", withValue: components.month!)
            } else {
                return stringFromFormat("%d months ago", withValue: components.month!)
            }
        }
        
        if components.day! >= 7 {
            let week = components.day!/7
            if week == 1 {
                return stringFromFormat("%d week ago", withValue: week)
            } else {
                return stringFromFormat("%d weeks ago", withValue: week)
            }
        }
        
        if components.day! > 0 {
            if components.day! == 1 {
                return stringFromFormat("%d day ago", withValue: components.day!)
            } else {
                return stringFromFormat("%d days ago", withValue: components.day!)
            }
        }
        
        if components.hour! > 0 {
            if components.hour! == 1 {
                return stringFromFormat("%d hour ago", withValue: components.hour!)
            } else {
                return stringFromFormat("%d hours ago", withValue: components.hour!)
            }
        }
        
        if components.minute! > 0 {
            if components.minute! == 1 {
                return stringFromFormat("%d minute ago", withValue: components.minute!)
            } else {
                return stringFromFormat("%d minutes ago", withValue: components.minute!)
            }
        }
        
        if components.second! > 0 {
            if components.second! < 5 {
                return NSLocalizedString("Just now", comment: "")
            } else {
                return stringFromFormat("%d seconds ago", withValue: components.second!)
            }
        }
        
        return ""
    }
    
    fileprivate func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    
    fileprivate func stringFromFormat(_ format: String, withValue value: Int) -> String {
        return String(format: NSLocalizedString(format, comment: ""), value)
    }
    
    func toString(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    func toString() -> String {
        return self.toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    func toString(format: DateFormat) -> String {
        var dateFormat: String
        switch format {
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
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.string(from: self)
    }
    func yearDifferent() -> Int {
        let components = self.dateComponents()
        return components.year ?? 1
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}

