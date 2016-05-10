//
//  ShowPieChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

class ShowPieChartsView: PieChartView, ChartViewDelegate {
    
    var chartsData: [PerStepChartData] = []
    
    var showValue: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: .ChartViewBackground)

        setupPieChartView()
        
        addLegend()

        setPieChartsData()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPieChartView() {
        
        self.usePercentValuesEnabled = true
        self.drawSlicesUnderHoleEnabled = true
        self.holeRadiusPercent = 0.6
        self.transparentCircleRadiusPercent = 0
        self.descriptionText = ""
        self.noDataTextDescription = "You need to provide data for the chart."
        self.setExtraOffsets(left: 0, top: 5, right: 0, bottom: 5)
        self.drawCenterTextEnabled = false // 中间不显示字
        self.holeColor = UIColor(named: .ChartViewBackground)
        self.drawHoleEnabled = true   // 中间是空的
        self.rotationAngle = 0
        self.rotationEnabled = true
    
    }
    
    func addLegend() {

        self.legend.position = .AboveChartRight
        self.legend.form = .Circle
        self.legend.formSize = 7
        self.legend.textColor = UIColor(named: .ChartViewTextColor)
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        self.legend.xEntrySpace = 10
        
    }
    
    
    func setPieChartsData() {
        
        let dataCount = 2
        var xVals: [String] = []
        var yVals: [BarChartDataEntry] = []
        for i in 0 ..< dataCount {
            
            yVals.append(BarChartDataEntry(value: sleepDegree[i], xIndex: i))
            xVals.append(sleepName[i])
        }
        
        let dataSet: PieChartDataSet = PieChartDataSet(yVals: yVals, label: "")
        dataSet.sliceSpace = 0
        
        var colors: [NSUIColor] = []
        colors.append(UIColor(named: .ChartSleepDegreeDeep))
        colors.append(UIColor(named: .ChartSleepDegreeLight))
        dataSet.colors = colors
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        formatter.percentSymbol = " %"
        data.setValueFormatter(formatter)
        data.setValueFont(UIFont.systemFontOfSize(11))
        data.setValueTextColor(UIColor.blackColor())
        self.data = data
        self.highlightValues(nil)
        self.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    // MARK: -- ChartViewDelegate
    /**
     点击事件
     */
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        Log.info("\(chartView)  \(entry)   \(dataSetIndex)  \(highlight)")
        
    }
    
}
