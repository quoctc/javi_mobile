import Foundation

extension Calendar {
    func dateRange(startDate: Date, endDate: Date, component: Calendar.Component, step: Int) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate, component: component, step: step, multiplier: 0)
        return dateRange
    }
}

struct DateRange : Sequence, IteratorProtocol {
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var component: Calendar.Component
    var step: Int
    var multiplier: Int
    
    mutating func next() -> Date? {
        guard let nextDate = calendar.date(byAdding: component, value: step * multiplier, to: startDate)
            else {
                return nil
        }
        
        if nextDate > endDate {
            return nil
        } else {
            multiplier += 1
            return nextDate
        }
    }
}
