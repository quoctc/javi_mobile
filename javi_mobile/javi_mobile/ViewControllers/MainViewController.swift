//
//  MainViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 3/9/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import Charts

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}

class MainViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var chartView: BarChartView!
    var options: [Option]!
    var shouldHideData: Bool = false
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialChart() {
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled =  false
        
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        //chart colors
        chartView.backgroundColor = UIColor.black
        chartView.legend.textColor = UIColor(color: Colors.colorWhite, alpha: 50)
        chartView.gridBackgroundColor = UIColor(color: Colors.colorWhite, alpha: 50)
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.font = UIFont.robotoLight(size: 8) ?? .systemFont(ofSize: 8, weight: .light)
        l.yOffset = 10
        l.xOffset = 10
        l.yEntrySpace = 0
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont.robotoLight(size: 10) ?? .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = IntAxisValueFormatter()
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
        
        self.updateChartData()
    }
    
    func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(Int(6), range: UInt32(100))
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let groupSpace = 0.08
        let barSpace = 0.03
        let barWidth = 0.2
        // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
        
        let randomMultiplier = range * 100
        let groupCount = count + 1
        let startValue = 1
        let endValue = startValue + groupCount
        
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
        chartView.xAxis.axisMaximum = Double(startValue) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
        
        data.groupBars(fromX: Double(startValue), groupSpace: groupSpace, barSpace: barSpace)
        
        chartView.data = data
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
