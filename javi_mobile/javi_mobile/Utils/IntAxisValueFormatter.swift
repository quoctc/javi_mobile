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

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateUtil.displayDateFormatter()
    public var labels = [String]()
    override init() {
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard labels.count > 0 else {
            return ""
        }
        guard value > 0 else { return labels[0] }
        return labels[Int(value) % labels.count]
    }
}

public class YearAxisValueFormatter: NSObject, IAxisValueFormatter {
    var monthsInYear = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard value > 0 else { return monthsInYear[0] }
        return monthsInYear[Int(value) % monthsInYear.count]
    }
}

public class WeekAxisValueFormatter: NSObject, IAxisValueFormatter {
    public var daysInWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard value > 0 else { return daysInWeek[0] }
        return daysInWeek[Int(value) % daysInWeek.count]
    }
}

public class DaysAxisValueFormatter: NSObject, IAxisValueFormatter {
    public var days = [String]()
    override public init() {
        super.init()
    }
    
    convenience init(from: Int, to: Int) {
        self.init()
        for i in from...to {
            self.days.append(String(i))
        }
        print(self.days)
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value) % days.count]
    }
}
