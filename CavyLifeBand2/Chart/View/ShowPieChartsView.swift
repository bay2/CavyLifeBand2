//
//  ShowPieChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

class ShowPieChartsView: PieChartView, ChartViewDelegate  {
    
    // 饼状图
    var showValue: Bool = false
    
    var deepSleep: Int  = 0
    var lightSleep: Int = 0
    
    // 左上角显示最大值
    var maxValue: Int = 0
    
    convenience init(frame: CGRect, deepSleep: Int, lightSleep: Int) {
       
        self.init(frame: frame)
        
        self.deepSleep  = deepSleep
        self.lightSleep = lightSleep
        
        maxValue = deepSleep + lightSleep
        
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        setupPieChartView()
        
        addLegend()
        
        setPieChartsData()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPieChartView() {

        self.usePercentValuesEnabled = true
        self.drawSlicesUnderHoleEnabled = true
        self.holeRadiusPercent = 0.6
        self.transparentCircleRadiusPercent = 0
        self.noDataTextDescription = "You need to provide data for the chart."
        // 不允许点击放大
        self.highlightPerTapEnabled = false
        self.setExtraOffsets(left: 0, top: 1, right: 0, bottom: 1)
        self.drawCenterTextEnabled = false // 中间不显示字
        self.holeColor = UIColor(named: .HomeViewMainColor)
        self.drawHoleEnabled = true   // 中间是空的
        self.rotationAngle = 0
        self.rotationEnabled = true
        
        descriptionText = "\(maxValue  / 60 + 1)h"
        descriptionFont = UIFont.systemFontOfSize(12)
        descriptionTextAlign = .Left
        descriptionTextPosition = CGPointMake(10, 1)
        descriptionTextColor = UIColor.whiteColor()
        
    }
    
    func addLegend() {

        self.legend.horizontalAlignment = .Right
        self.legend.verticalAlignment = .Top
        self.legend.form = .Circle
        self.legend.formSize = 0
        self.legend.textColor = UIColor.clearColor()//(named: .ChartViewTextColor)
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        self.legend.xEntrySpace = 0
        
    }
    
    func setPieChartsData() {

        let dataCount = 2
        var xVals: [String] = []
        var yVals: [BarChartDataEntry] = []
        let colors: [NSUIColor] = [UIColor.whiteColor(), UIColor(named: .ChartSubTimeBucketViewBg)]
        var lineAndTextColor = UIColor.whiteColor()
        let sleepDegreeArray = [Double(self.lightSleep), Double(self.deepSleep)]
        
        if deepSleep == 0 && lightSleep == 0 {

            lineAndTextColor = UIColor.clearColor()

        }
    
        for i in 0 ..< dataCount {
            
            let sleepName = ["", ""]//["\(L10n.ChartSleepLight.string)", "\(L10n.ChartSleepDeep.string)"]
            xVals.append(sleepName[i])
            
            yVals.append(BarChartDataEntry(value: sleepDegreeArray[i], xIndex: i))
            
        }
        
        let dataSet: PieChartDataSet = PieChartDataSet(yVals: yVals, label: "")
        dataSet.sliceSpace = 0
        dataSet.colors = colors
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        formatter.percentSymbol = " %"
        
        // 如果深睡浅睡都为0 指出来的线不知道起点在哪 error
        if deepSleep != 0 || lightSleep != 0 {
            
//            dataSet.valueLinePart1OffsetPercentage = 0.5
            dataSet.valueLinePart1Length = 0.4
            dataSet.valueLinePart2Length = 0.4
            dataSet.yValuePosition = .OutsideSlice
            dataSet.valueLineColor = lineAndTextColor
        }
        
        data.setValueFormatter(formatter)
        data.setValueFont(UIFont.systemFontOfSize(11))
        data.setValueTextColor(lineAndTextColor)

        self.data = data
        self.highlightValues(nil)
        
        // 如果深睡浅睡都为0 动效也不知道从哪开始 会有error
        if deepSleep != 0 && lightSleep != 0 {
            
            self.animate(xAxisDuration: 1, yAxisDuration: 1)
        }
        
    }
    
    // MARK: -- ChartViewDelegate
    /**
     点击事件
     */
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        Log.info("\(chartView)  \(entry)   \(dataSetIndex)  \(highlight)")
        
    }
    
}
