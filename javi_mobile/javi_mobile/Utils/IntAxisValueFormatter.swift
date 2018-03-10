//
//  IntAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

public class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
}

public class YearAxisValueFormatter: NSObject, IAxisValueFormatter {
    var monthsInYear = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return monthsInYear[Int(value) % monthsInYear.count]
    }
}

public class MonthAxisValueFormatter: NSObject, IAxisValueFormatter {
    var daysInMonth = ["1-7", "8-14", "15-21", "22-28"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return daysInMonth[Int(value) % daysInMonth.count]
    }
}

public class WeekAxisValueFormatter: NSObject, IAxisValueFormatter {
    var daysInWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return daysInWeek[Int(value) % daysInWeek.count]
    }
}
