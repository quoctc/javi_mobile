//
//  MainViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 3/9/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import Charts

class MainViewController: UIViewController {

    @IBOutlet var chartView: BarChartView!
    @IBOutlet weak var filterDateButton: UIButton!
    var shouldHideData: Bool = false
    var xLabels = [String]()
    enum ChartType: Int {
        case day = 0
        case week
        case month
        case year
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialChart()
        filterDateButton.setTitle("Hôm nay", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialChart() {
        
        //chartView.delegate = self
        chartView.chartDescription?.enabled =  false
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        //chart colors
        chartView.backgroundColor = UIColor.black
        chartView.legend.textColor = UIColor(color: Colors.colorWhite, alpha: 50)
        chartView.gridBackgroundColor = UIColor(color: Colors.colorWhite, alpha: 50)
        
        let legend = chartView.legend
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.font = UIFont.robotoLight(size: 8) ?? .systemFont(ofSize: 8, weight: .light)
        legend.yOffset = 10
        legend.xOffset = 10
        legend.yEntrySpace = 0
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont.robotoLight(size: 10) ?? .systemFont(ofSize: 10, weight: .light)
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.granularityEnabled = true
        xAxis.granularity = 1.0 // only intervals of 1 day
        xAxis.labelTextColor = UIColor(color: Colors.colorWhite, alpha: 50)
        xAxis.labelPosition = .bottom
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.robotoLight(size: 10) ??  .systemFont(ofSize: 10, weight: .light)
        leftAxis.valueFormatter = LargeValueFormatter()
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = UIColor(color: Colors.colorWhite, alpha: 50)
        
        chartView.rightAxis.enabled = false
        
        setDayDataCount(Date(), endDay: nil)
    }
    
    func setDayDataCount(_ startDay: Date, endDay: Date?) {
        let groupSpace = 0.08
        let barSpace = 0.03
        let barWidth = 0.276
        // (0.276 + 0.03) * 3 + 0.08 = 1.00 -> interval per "group"
        
        let randomMultiplier: UInt32 = 100
        
//        let block: (Date) -> BarChartDataEntry = { (date) -> BarChartDataEntry in
//            return BarChartDataEntry(x: date.timeIntervalSince1970, y: Double(arc4random_uniform(randomMultiplier)))
//        }
        
        //let next7Days = Calendar.current.date(byAdding: .day, value: 7, to: today)!
//        let next7Days = endDay
        var numberOfDays = 0
        var dateRange: DateRange
        if let endDay = endDay {
            let component = Calendar.current.dateComponents([.day], from: startDay, to: endDay)
            if let days = component.day {
                numberOfDays = days
            }
            dateRange = Calendar.current.dateRange(startDate: startDay, endDate: endDay, component: .day, step: 1)
        }
        else {
            dateRange = Calendar.current.dateRange(startDate: startDay, endDate: startDay, component: .day, step: 1)
        }
//        let yVals1 = dateRange.map(block)
//        let yVals2 = dateRange.map(block)
//        let yVals3 = dateRange.map(block)
        var yVals1 = [BarChartDataEntry]()
        var yVals2 = [BarChartDataEntry]()
        var yVals3 = [BarChartDataEntry]()
        var i = 0
        var dateLabels = [String]()
        for date in dateRange {
            dateLabels.append(DateUtil.displayDateFormatter().string(from: date))
            let yval1 = BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
            yVals1.append(yval1)
            let yval2 = BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
            yVals2.append(yval2)
            let yval3 = BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
            yVals3.append(yval3)
            i += 1
        }
        (chartView.xAxis.valueFormatter as! DateValueFormatter).labels = dateLabels
        
        let set1 = BarChartDataSet(values: yVals1, label: "A")
        set1.setColor(UIColor.yellow)
        
        let set2 = BarChartDataSet(values: yVals2, label: "B")
        set2.setColor(UIColor.green)
        
        let set3 = BarChartDataSet(values: yVals3, label: "C")
        set3.setColor(UIColor(color: Colors.colorLightBlue))
        
        let data = BarChartData(dataSets: [set1, set2, set3])
        data.setValueFont(UIFont.robotoLight(size: 10))
        data.setValueTextColor(UIColor(color: Colors.colorWhite, alpha: 50))
        data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = barWidth
        //data.groupBars(fromX: today.timeIntervalSince1970, groupSpace: groupSpace, barSpace: barSpace)
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
//        // restrict the x-axis range
        chartView.xAxis.axisMinimum = 0//today.timeIntervalSince1970
//        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum = Double(numberOfDays+1)//next7Days.timeIntervalSince1970
        
        chartView.data = data
        chartView.xAxis.setLabelCount(numberOfDays+1, force: false)
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let groupSpace = 0.08 //space between groups
        let barSpace = 0.03 // space between bars
        let barWidth = 0.276 // width of each bars
        
        let randomMultiplier = range
        let startValue = 0
        let endValue = count
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
        }
        let yVals1 = (startValue ..< endValue).map(block)
        let yVals2 = (startValue ..< endValue).map(block)
        let yVals3 = (startValue ..< endValue).map(block)
        
        let set1 = BarChartDataSet(values: yVals1, label: "A")
        set1.setColor(UIColor.yellow)
        
        let set2 = BarChartDataSet(values: yVals2, label: "B")
        set2.setColor(UIColor.green)
        
        let set3 = BarChartDataSet(values: yVals3, label: "C")
        set3.setColor(UIColor(color: Colors.colorLightBlue))
        
        let data = BarChartData(dataSets: [set1, set2, set3])
        data.setValueFont(UIFont.robotoLight(size: 10))
        data.setValueTextColor(UIColor(color: Colors.colorWhite, alpha: 50))
        data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = barWidth
        
        // restrict the x-axis range
        chartView.xAxis.axisMinimum = Double(startValue)
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum =  Double(endValue)//Double(startValue) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
        
        data.groupBars(fromX: Double(startValue), groupSpace: groupSpace, barSpace: barSpace)
        
        chartView.data = data
        chartView.xAxis.setLabelCount(count + 1, force: false)
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    @IBAction func changeChartType(_ sender: UISegmentedControl) {
        var chartFormater: IAxisValueFormatter?
        var count = 1
        var title = "Hôm nay"
        switch ChartType(rawValue: sender.selectedSegmentIndex)! {
        case .day:
            count = 1
            title = "Hôm nay"
            xLabels = ["Hôm nay"]
            break
        case .week:
            chartFormater = WeekAxisValueFormatter()
            count = 7
            xLabels = (chartFormater as! WeekAxisValueFormatter).daysInWeek
            title = "Tuần này"
            break
        case .month:
            chartFormater = DateValueFormatter()
            title = "Tháng này"
            break
        case .year:
            chartFormater = YearAxisValueFormatter()
            count = 12
            title = "Năm này"
            break
        }
        filterDateButton.setTitle(title, for: .normal)
        chartView.xAxis.valueFormatter = chartFormater
        if chartFormater is DateValueFormatter {
            setDayDataCount(Date().startOfMonth(), endDay: Date().endOfMonth())
        }
        else {
            setDataCount(count, range: UInt32(100))
        }
    }
    
    //Start to update filter date
    func updateFilterDate(fromDate: Date?, toDate: Date?) {
        guard let fromDate = fromDate, let toDate = toDate  else {
            return
        }
        guard NSCalendar.current.compare(fromDate, to: toDate, toGranularity: .day) == .orderedAscending else {
            return
        }
        print("started to update date: \(fromDate.toString()) - to date: \(toDate.toString())")
        filterDateButton.setTitle("từ \(fromDate.toString(dateStyle: .short, timeStyle: .none)) đến \(toDate.toString(dateStyle: .short, timeStyle: .none))", for: .normal)
        chartView.xAxis.valueFormatter = DateValueFormatter()
        setDayDataCount(fromDate, endDay: toDate)
    }
    
    @IBAction func backToPreviousViewController(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

