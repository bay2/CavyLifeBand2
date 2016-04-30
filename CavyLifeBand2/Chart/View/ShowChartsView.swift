//
//  ShowChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

class ShowChartsView: BarChartView, ChartViewDelegate {
    
    let shouldHideData: Bool = true
    let mounths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let weeks = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"]
    let day = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        setupBarLineChartView(self)
        
        self.delegate = self
        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = true
        self.maxVisibleValueCount = 60
        
        let xAxis = self.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.labelFont = UIFont.systemFontOfSize(10)
        xAxis.drawGridLinesEnabled = false
        xAxis.spaceBetweenLabels = 2
        
        let leftAxis = self.leftAxis
        leftAxis.labelFont = UIFont.systemFontOfSize(10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter!.maximumFractionDigits = 1
        leftAxis.valueFormatter!.negativeSuffix = " $"
        leftAxis.valueFormatter!.positiveSuffix = " $"
        leftAxis.labelPosition = .OutsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinValue = 0
        
        self.legend.position = .BelowChartLeft
        self.legend.form = .Circle
        self.legend.formSize = 9.0
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        self.legend.xEntrySpace = 4.0
        
        updateChartData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     设置线
     */
    func setupBarLineChartView(chartView: BarLineChartViewBase) {
        
        chartView.descriptionText = ""
        chartView.noDataTextDescription = "You need to provide data for the chart."
        
        chartView.drawGridBackgroundEnabled = false
        
        chartView.dragEnabled = true
        //        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis
        
        xAxis.labelPosition = .Bottom
        chartView.rightAxis.enabled = false
        
    }
    
    /**
     更新数据
     */
    func updateChartData() {
        
        
//        if self.shouldHideData {
//            self.data = nil
//            return
//            
//        }
        
        setDataCount(7, range: 7)
        
    }
    
    func setDataCount(count: Int, range: Double) {
        
        var xVals: [String] = []
        for i in 0 ..< count {
            xVals.append(weeks[i])
        }
        
        var yVals: [BarChartDataEntry] = []
        
        for i in 1 ..< count {
            
            let mult = range + 1
            let val = Double(arc4random_uniform(UInt32(mult) + 1))
            let dataEntry = BarChartDataEntry(value: val, xIndex: i)
            yVals.append(dataEntry)
        }
        
        var set1 = BarChartDataSet()
        if self.data?.dataSetCount > 0 {
            
            set1 =  self.data?.dataSets[0] as! BarChartDataSet
//            set1.yVals = yVals
//            self.data!.xValsObjc = xVals
            self.notifyDataSetChanged()
    
        } else {
            
            set1 = BarChartDataSet(yVals: yVals, label: "DataSet")
            
            set1.barSpace = 0.5
            set1.setColors([UIColor.yellowColor()], alpha: 0.9)
            var dataSets: [BarChartDataSet] = []
            dataSets.append(set1)
            let data = BarChartData(xVals: xVals, dataSets: dataSets)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
            self.data = data
        }
        
    }
    
    
    
// MARK: -- ChartViewDelegate
    
    
    
    
    /*
     
    optional func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    
    // Called when nothing has been selected or an "un-select" has been made.
    optional func chartValueNothingSelected(chartView: ChartViewBase)
    
    // Callbacks when the chart is scaled / zoomed via pinch zoom gesture.
    optional func chartScaled(chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat)
    
    // Callbacks when the chart is moved / translated via drag gesture.
    optional func chartTranslated(chartView: ChartViewBase, dX: CGFloat, dY: CGFloat)
    
    */
    
    

}
