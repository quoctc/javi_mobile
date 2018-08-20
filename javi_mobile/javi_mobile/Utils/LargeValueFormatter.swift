//
//  LargeValueFormatter.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import Charts

private let MAX_LENGTH = 5

@objc protocol Testing123 { }

public class LargeValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    public var suffix = ["", "k", "m", "b", "t"]
    
    /// An appendix text to be added at the end of the formatted value.
    public var appendix: String?
    
    public init(appendix: String? = nil) {
        self.appendix = appendix
    }
    
    func formatPoints(num: Double) ->String{
        var thousandNum = num/1000
        var millionNum =  num/1000000
        var billionNum =  num/100000000
        var trillionNum = num/10000000000
        if num >= 1000 && num < 1000000 {
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))\(suffix[1])")
            }
            return("\(thousandNum.roundToPlaces(places: 1))\(suffix[1])")
        }
        if num >= 1000000 && num < 100000000 {
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))\(suffix[1])")
            }
            return ("\(millionNum.roundToPlaces(places: 1))\(suffix[1])")
        }
        if num >= 100000000 && num < 10000000000 {
            if(floor(billionNum) == billionNum){
                return("\(Int(thousandNum))\(suffix[2])")
            }
            return ("\(billionNum.roundToPlaces(places: 1))\(suffix[2])")
        }
        if num > 10000000000 {
            if(floor(trillionNum) == trillionNum){
                return("\(Int(thousandNum))\(suffix[3])")
            }
            return ("\(trillionNum.roundToPlaces(places: 1))\(suffix[3])")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
        
    }
    
//    fileprivate func format(value: Double) -> String {
//        var sig = value
//        var length = 0
//        let maxLength = suffix.count - 1
//
//        while sig >= 1000.0 && length < maxLength {
//            sig /= 1000.0
//            length += 1
//        }
//
//        var r = String(format: "%2.f", sig) + suffix[length]
//
//        if let appendix = appendix {
//            r += appendix
//        }
//
//        return r
//    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatPoints(num: value)//format(value: value)
    }
    
    public func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String {
        return formatPoints(num: value)//format(value: value)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
