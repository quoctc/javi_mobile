//
//  MainViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 3/9/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

class MainViewController: UIViewController {

    @IBOutlet var chartView: BarChartView! //view to show chart data
    @IBOutlet weak var filterDateButton: UIButton! //button to filter chart data
    var shouldHideData: Bool = false
    var xLabels = [String]()
    var isFirstTime = true
    
    /// types of chart (use for filter)
    ///
    /// - day
    /// - week
    /// - month
    /// - year
    /// - custom
    enum ChartType: Int {
        case day = 0
        case week
        case month
        case year
        case custom
    }
    
    var currentChartType: ChartType = .day
    /// settings for chart
    struct mapSettings {
        static let groupSpace = 0.08
        static let barSpace = 0.03
        static let barWidth = 0.276 // (0.276 + 0.03) * 3 + 0.08 = 1.00 -> interval per "group"
    }
    
    @IBOutlet weak var segmentQuickFilter: UISegmentedControl!
    var selectedChartType: ChartType = .day
    var filteredDates: [Date] = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialChart()
        filterDateButton.setTitle("Hôm nay", for: .normal)
        self.getData(fromService: DataService(), fromDate: Date().startOfDay, toDate: Date().endOfDay) { [weak self] (data) in
            //group data by day
            if let data = data, let dataDict = self?.groupData(by: .day, data: data) {
                self?.setDayDataCount(data: dataDict, startDay: Date().startOfDay, endDay: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Initial chart view at the firstime load
    func initialChart() {
        
        //chartView.delegate = self
        chartView.chartDescription?.enabled =  false
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        
        chartView.maxVisibleCount = 50
        chartView.delegate = self
        
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
    }
    
    /// filling data to chart - for custome filtered chart type
    ///
    /// - Parameters:
    ///   - data: data that want to show on chart
    ///   - startDay: start day in the chart
    ///   - endDay: end day in the chart
    func setDayDataCount(data: [String: [Sensor]], startDay: Date, endDay: Date?) {
        var numberOfDays = 0
        var dateRange: DateRange
        //calculate day range from start to end
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
        var yVals1 = [BarChartDataEntry]()
        var yVals2 = [BarChartDataEntry]()
        var yVals3 = [BarChartDataEntry]()
        var i = 0
        var dateLabels = [String]()
        for date in dateRange {
            //let day = Calendar.current.component(.day, from: date)
            dateLabels.append(DateUtil.displayDateFormatter().string(from: date))
            let key = DateUtil.displayDateFormatter().string(from: date)
            let countAInDay = data[key]?.filter({ $0.type == "a" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            let countBInDay = data[key]?.filter({ $0.type == "b" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            let countCInDay = data[key]?.filter({ $0.type == "c" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            
            let yval1 = BarChartDataEntry(x: Double(i), y: Double(countAInDay))
            yVals1.append(yval1)
            let yval2 = BarChartDataEntry(x: Double(i), y: Double(countBInDay))
            yVals2.append(yval2)
            let yval3 = BarChartDataEntry(x: Double(i), y: Double(countCInDay))
            yVals3.append(yval3)
            i += 1
        }
        (chartView.xAxis.valueFormatter as! DateValueFormatter).labels = dateLabels //asign lables for x axis
        
        //create data set for each type of sensor
        let set1 = BarChartDataSet(values: yVals1, label: "A")
        set1.setColor(UIColor.yellow)
        
        let set2 = BarChartDataSet(values: yVals2, label: "B")
        set2.setColor(UIColor.green)
        
        let set3 = BarChartDataSet(values: yVals3, label: "C")
        set3.setColor(UIColor(color: Colors.colorLightBlue))
        
        let data = BarChartData(dataSets: [set1, set2, set3])
        data.setValueFont(UIFont.robotoLight(size: 7))
        data.setValueTextColor(UIColor(color: Colors.colorWhite, alpha: 50))
        data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = mapSettings.barWidth
        //data.groupBars(fromX: today.timeIntervalSince1970, groupSpace: groupSpace, barSpace: barSpace)
        data.groupBars(fromX: 0, groupSpace: mapSettings.groupSpace, barSpace: mapSettings.barSpace)
        
//        // restrict the x-axis range
        chartView.xAxis.axisMinimum = 0//today.timeIntervalSince1970
//        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum = Double(numberOfDays+1)//next7Days.timeIntervalSince1970
        
        chartView.data = data // add data to chart
        
        if numberOfDays > 12 {
            //Custome
            chartView.xAxis.centerAxisLabelsEnabled = false
        }
        else {
            chartView.xAxis.centerAxisLabelsEnabled = true
            chartView.xAxis.setLabelCount(numberOfDays+1, force: false) //add x axis label to chart
        }
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0) //start animation to showing the data
    }
    
    /// filling data to chart - for quick filtered chart type
    ///
    /// - Parameters:
    ///   - data: data that want to show on chart
    ///   - startDay: start day in the chart
    ///   - endDay: end day in the chart
    func setDataCount(data: [String: [Sensor]], count: Int) {
        let startValue = 0
        let endValue = count
        
        var yVals1 = [BarChartDataEntry]()
        var yVals2 = [BarChartDataEntry]()
        var yVals3 = [BarChartDataEntry]()
        var i = 0
        for each in 1...(count+1) {
            let countAInEach = data[String(each)]?.filter({ $0.type == "a" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            let countBInEach = data[String(each)]?.filter({ $0.type == "b" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            let countCInEach = data[String(each)]?.filter({ $0.type == "c" }).reduce(0, { (result, sensor) -> Int in
                result + (sensor.value ?? 0)
            }) ?? 0
            
            let yval1 = BarChartDataEntry(x: Double(i), y: Double(countAInEach))
            yVals1.append(yval1)
            let yval2 = BarChartDataEntry(x: Double(i), y: Double(countBInEach))
            yVals2.append(yval2)
            let yval3 = BarChartDataEntry(x: Double(i), y: Double(countCInEach))
            yVals3.append(yval3)
            i += 1
        }
        
        let set1 = BarChartDataSet(values: yVals1, label: "A")
        set1.setColor(UIColor.yellow)
        
        let set2 = BarChartDataSet(values: yVals2, label: "B")
        set2.setColor(UIColor.green)
        
        let set3 = BarChartDataSet(values: yVals3, label: "C")
        set3.setColor(UIColor(color: Colors.colorLightBlue))
        
        let data = BarChartData(dataSets: [set1, set2, set3])
        data.setValueFont(UIFont.robotoLight(size: 7))
        data.setValueTextColor(UIColor(color: Colors.colorWhite, alpha: 50))
        data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = mapSettings.barWidth
        
        // restrict the x-axis range
        chartView.xAxis.axisMinimum = Double(startValue)
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum =  Double(endValue)//Double(startValue) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
        
        data.groupBars(fromX: Double(startValue), groupSpace: mapSettings.groupSpace, barSpace: mapSettings.barSpace)
        
        chartView.data = data
        chartView.xAxis.setLabelCount(count + 1, force: false)
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    //quick filter action
    @IBAction func changeChartType(_ sender: UISegmentedControl) {
        var chartFormater: IAxisValueFormatter?
        var count = 1
        var title = "Hôm nay"
        var startDate = Date().startOfDay
        var endDate = Date().endOfDay
        let selectedType = ChartType(rawValue: sender.selectedSegmentIndex)!
        selectedChartType = selectedType
        switch selectedType {
        case .day:
            chartFormater = DateValueFormatter()
            count = 1
            title = "Hôm nay"
            xLabels = ["Hôm nay"]
            startDate = Date().startOfDay
            endDate = Date().endOfDay
            break
        case .week:
            chartFormater = WeekAxisValueFormatter()
            count = 7
            xLabels = (chartFormater as! WeekAxisValueFormatter).daysInWeek
            title = "Tuần này"
            startDate = Date().startOfWeek()?.startOfDay ?? Date()
            endDate = Date().endOfWeek()?.endOfDay ?? Date()
            break
        case .month:
            chartFormater = DateValueFormatter()
            title = "Tháng này"
            startDate = Date().startOfMonth().startOfDay
            endDate = Date().endOfMonth().endOfDay
            break
        case .year:
            chartFormater = YearAxisValueFormatter()
            count = 12
            title = "Năm này"
            startDate = Date().startOfYear().startOfDay
            endDate = Date().endOfYear().endOfDay
            break
        case .custom:
            chartFormater = DateValueFormatter()
        }
        filterDateButton.setTitle(title, for: .normal)
        chartView.xAxis.valueFormatter = chartFormater
        if chartFormater is DateValueFormatter {
            self.getData(fromService: DataService(), fromDate: startDate, toDate: endDate, completion: { [weak self] (data) in
                //group data by day
                if let data = data, let dataDict = self?.groupData(by: .day, data: data) {
                    self?.setDayDataCount(data: dataDict, startDay: startDate, endDay: endDate)
                }
            })
        }
        else {
            self.getData(fromService: DataService(), fromDate: startDate, toDate: endDate, completion: { [weak self] (data) in
                if let data = data, let dataDict = self?.groupData(by: selectedType, data: data) {
                    self?.setDataCount(data: dataDict, count: count)
                }
            })
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
        //query data
        getData(fromService: DataService(), fromDate: fromDate, toDate: toDate) { [weak self] (data) in
            //prepare chart UI
            self?.filteredDates = [fromDate, toDate]
            self?.selectedChartType = .custom
            self?.filterDateButton.setTitle("từ \(fromDate.toString(dateStyle: .short, timeStyle: .none)) đến \(toDate.toString(dateStyle: .short, timeStyle: .none))", for: .normal)
            self?.chartView.xAxis.valueFormatter = DateValueFormatter()
            //group data by day
            if let data = data, let dataDict = self?.groupData(by: .day, data: data) {
                self?.setDayDataCount(data: dataDict, startDay: fromDate, endDay: toDate)
            }
        }
    }
    
    /// group data by selected filter type
    ///
    /// - Parameters:
    ///   - type: type to group data (day, weekday, month)
    ///   - data: upgrouped data
    /// - Returns: grouped data
    private func groupData(by type: ChartType, data: [Sensor]) -> [String: [Sensor]] {
        var dataDict = [String: [Sensor]]()
        for item in data {
            if let timeStamp = item.timeStamp {
                let date = Date(timeIntervalSince1970: Double(timeStamp))
                var key = ""
                switch type {
                    case .day:
                        //let day = Calendar.current.component(.day, from: date)
                        //key = String(day)
                        key = DateUtil.displayDateFormatter().string(from: date)
                    break
                    case .year:
                        let month = Calendar.current.component(.month, from: date)
                        key = String(month)
                    break
                    case .week:
                        if let startDayInWeek = date.startOfWeek()?.startOfDay, let daysInWeek = Calendar.current.dateComponents([.day], from: startDayInWeek, to: date).day {
                            key = String(daysInWeek + 1)
                        }
                    break
                    default:
                    break
                }
                if var arrayData = dataDict[String(key)] {
                    arrayData.append(item)
                    dataDict[String(key)] = arrayData
                }
                else {
                    dataDict[String(key)] = [item]
                }
            }
        }
        return dataDict
    }
    
    @IBAction func touchRefreshBtn(_ sender: Any) {
        self.changeChartType(segmentQuickFilter)
    }
    
    
    @IBAction func backToPreviousViewController(segue:UIStoryboardSegue) { }
    
    //query data with dates
    private func getData(fromService service: DataService, fromDate: Date, toDate: Date, completion: @escaping (_ data: [Sensor]?)->Void) {
        let loadingHud = MBProgressHUD.showAdded(to: self.view, animated: false)
        print("get date from:\(fromDate) to: \(toDate)")
        service.get(startDate: fromDate, endDate: toDate) { [weak self] result in
            loadingHud.hide(animated: false)
            switch result {
            case .Success(let data):
                completion(data)
                break
            case .Failure(let error):
                if self?.isFirstTime ?? true {
                    self?.isFirstTime = false
                    return
                }
                completion(nil)
                if let error = error as? APIError {
                    if error == APIError.noConnected {
                        self?.showSimpleAlert(title: "Lỗi", message: "Không có kết nối!")
                        return
                    }
                }
                self?.showSimpleAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: ChartViewDelegate {
    
}

