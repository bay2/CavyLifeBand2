//
//  ShowChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

let leftMaxValue = 10
let leftLabelCCount = leftMaxValue / 2
let legendLable = "Step"
let legendColors = [UIColor(named: .ChartStepPillarColor)]
let leftUnit = " k"
let spaceBetweenLabel = 1
let dataCount = 7

class ShowChartsView: BarChartView, ChartViewDelegate {
    
    var chartsData: [PerStepChartData] = []
    
    var showValue: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: .ChartViewBackground)
        
        setupBarLineChartView()
        
        addxAxis()
        addLeftAxis()
        addLegend()

        setData(dataCount)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     总设置
     */
    func setupBarLineChartView() {
        
        self.descriptionText = ""
        self.noDataTextDescription = "You need to provide data for the chart."
        self.dragEnabled = false
        self.setScaleEnabled(false)
        self.drawValueAboveBarEnabled = true
        self.rightAxis.enabled = false
        self.delegate = self
        self.maxVisibleValueCount = leftMaxValue
        
    }

    /**
     添加网格
     */
    func addxAxis(){
        
        let xAxis = self.xAxis
        
        xAxis.labelPosition = .Bottom
        xAxis.labelFont = UIFont.systemFontOfSize(10)
        xAxis.gridColor = UIColor(named: .ChartGirdColor)
        xAxis.labelTextColor =  UIColor(named: .ChartGirdColor)
        xAxis.drawGridLinesEnabled = false
        xAxis.spaceBetweenLabels = spaceBetweenLabel

    }
    
    /**
     添加左边刻度
     */
    func addLeftAxis() {
        
        // 左边刻度
        let leftAxis = self.leftAxis
        leftAxis.labelFont = UIFont.systemFontOfSize(12)
        leftAxis.labelCount = leftLabelCCount
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter!.maximumFractionDigits = 1
        leftAxis.valueFormatter!.positiveSuffix = leftUnit
        leftAxis.labelPosition = .OutsideChart
        leftAxis.labelTextColor = UIColor(named: .ChartGirdColor)
        leftAxis.spaceTop = 0.15
        leftAxis.spaceBottom = 0.15
        leftAxis.axisMinValue = 0
    }
    
    /**
     添加右上角标志
     */
    func addLegend() {
        
        self.legend.position = .AboveChartRight
        self.legend.form = .Circle
        self.legend.formSize = 5
        self.legend.textColor = UIColor(named: .ChartViewTextColor)
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        self.legend.xEntrySpace = 10
        
    }
    
    /**
     添加数据
     
     - parameter count: 条纹个数
     */
    func setData(count: Int) {
        
        var xVals: [String] = []
        var yVals: [BarChartDataEntry] = []
        for i in 0 ..< count {
            xVals.append(weeks[i])
        }
        for i in 0 ..< count {
            
            let val = dayData[i]
            let dataEntry = BarChartDataEntry(value: val, xIndex: i)
            yVals.append(dataEntry)
        }
        
        
        var dataSet = BarChartDataSet()
        if self.data?.dataSetCount > 0 {
            
            dataSet =  self.data?.dataSets[0] as! BarChartDataSet
            self.notifyDataSetChanged()
    
        } else {
            
            dataSet = BarChartDataSet(yVals: yVals, label: legendLable)
            dataSet.barSpace = 0.80
            dataSet.setColors(legendColors, alpha: 0.9)
            var dataSets: [BarChartDataSet] = []
            dataSets.append(dataSet)
            let data = BarChartData(xVals: xVals, dataSets: dataSets)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
            // 默认不显示数值
            data.setValueTextColor(UIColor.clearColor())
            self.data = data
            
            // 动画
            self.animate(yAxisDuration: 2)
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
