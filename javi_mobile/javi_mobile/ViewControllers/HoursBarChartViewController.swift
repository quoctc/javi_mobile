//
//  HoursBarChartViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

class HoursBarChartViewController: UIViewController {
    
    @IBOutlet var chartView: BarChartView! //view to show chart data
    
    /// settings for chart
    struct mapSettings {
        static let groupSpace = 0.08
        static let barSpace = 0.03
        static let barWidth = 0.276 // (0.276 + 0.03) * 3 + 0.08 = 1.00 -> interval per "group"
    }
    
    /// types of chart (use for filter)
    ///
    /// - day
    /// - week
    /// - month
    /// - year
    /// - custom
    enum ChartType: Int {
        case hours = 0
        case custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialChart()
    }

    //Initial chart view at the firstime load
    private func initialChart() {
        
        //chartView.delegate = self
        chartView.chartDescription?.enabled =  false
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        
        chartView.maxVisibleCount = 50
        //chartView.delegate = self
        
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
        xAxis.valueFormatter = HoursValueFormatter()
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
    
    func reloadDataWith(date: Date, fromHours: Int, toHours: Int) {
        //filterDateButton.setTitle("Hôm nay", for: .normal)
        let calendar = Calendar.current
        var fromDateComponent = DateComponents()
        fromDateComponent.year = calendar.component(.year, from: date)
        fromDateComponent.month = calendar.component(.month, from: date)
        fromDateComponent.day = calendar.component(.day, from: date)
        fromDateComponent.hour = fromHours
        let fromDateT = calendar.date(from: fromDateComponent)
        
        var toDateComponent = DateComponents()
        toDateComponent.year = calendar.component(.year, from: date)
        toDateComponent.month = calendar.component(.month, from: date)
        toDateComponent.day = calendar.component(.day, from: date)
        toDateComponent.hour = toHours
        let toDateT = calendar.date(from: toDateComponent)
        
        guard let fromDate = fromDateT, let toDate = toDateT else { return }
        
        self.getData(fromService: DataService(), fromDate: fromDate, toDate: toDate) { [weak self] (data) in
            //group data by day
            if let data = data, let dataDict = self?.groupData(by: .hours, data: data) {
                self?.setHoursDataCount(data: dataDict, startDay: fromDate, endDay: toDate)
            }
        }
    }
    
    func setHoursDataCount(data: [String: [Sensor]], startDay: Date, endDay: Date?) {
        var numberOfHours = 0
        var dateRange: DateRange
        //calculate day range from start to end
        if let endDay = endDay {
            let component = Calendar.current.dateComponents([.hour], from: startDay, to: endDay)
            if let hours = component.hour {
                numberOfHours = hours
            }
            dateRange = Calendar.current.dateRange(startDate: startDay, endDate: endDay, component: .hour, step: 1)
        }
        else {
            dateRange = Calendar.current.dateRange(startDate: startDay, endDate: startDay, component: .hour, step: 1)
        }
        var yVals1 = [BarChartDataEntry]()
        var yVals2 = [BarChartDataEntry]()
        var yVals3 = [BarChartDataEntry]()
        var i = 0
        var dateLabels = [String]()
        for date in dateRange {
            //let day = Calendar.current.component(.day, from: date)
            dateLabels.append(DateUtil.displayHoursFormatter().string(from: date))
            let key = DateUtil.displayHoursFormatter().string(from: date)
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
        (chartView.xAxis.valueFormatter as! HoursValueFormatter).labels = dateLabels //asign lables for x axis
        
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
        chartView.xAxis.axisMaximum = Double(numberOfHours+1)//next7Days.timeIntervalSince1970
        
        chartView.data = data // add data to chart
        
        if numberOfHours > 6 {
            //Custome
            chartView.xAxis.centerAxisLabelsEnabled = false
        }
        else {
            chartView.xAxis.centerAxisLabelsEnabled = true
            chartView.xAxis.setLabelCount(numberOfHours+1, force: false) //add x axis label to chart
        }
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0) //start animation to showing the data
    }
    
    /// group data by selected filter type
    ///
    /// - Parameters:
    ///   - type: type to group data (hours)
    ///   - data: upgrouped data
    /// - Returns: grouped data
    private func groupData(by type: ChartType, data: [Sensor]) -> [String: [Sensor]] {
        var dataDict = [String: [Sensor]]()
        for item in data {
            if let timeStamp = item.timeStamp {
                let date = Date(timeIntervalSince1970: Double(timeStamp))
                var key = ""
                switch type {
                case .hours:
                    key = DateUtil.displayHoursFormatter().string(from: date)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
