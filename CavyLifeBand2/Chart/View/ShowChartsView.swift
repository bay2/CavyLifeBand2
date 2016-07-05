//
//  ShowChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

var spaceBetweenLabels = 0 // X轴 显示Label的个数

class ShowChartsView: BarChartView, ChartViewDelegate {

    var legendColors = [UIColor.whiteColor()]
    var legdendText = L10n.ChartStep.string
    var legendTextColor = UIColor.whiteColor()
    var leftUnit = " k"

    var timeBucketStyle: TimeBucketStyle = .Day
    
    // 计步柱状图
    var chartsData: [PerStepChartsData] = []
    
    // 左上角显示最大值
    var maxValue: Int = 3
    
    /**
     配置所有视图 主入口
     */
    func configAllView() {
        
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        setData(chartsData.count) // 设置数据
        
        setupBarLineChartView()
        
        addxAxis()
        
        addLegend()
        
        if UIDevice.isPhone5() {
            
            self.leftAxis.spaceBottom = 0
            self.leftAxis.spaceTop = 0
        }
        

    }
    
    /**
     总设置
     */
    func setupBarLineChartView() {
        
        noDataTextDescription = "You need to provide data for the chart." // 没有数据的时显示
        drawBordersEnabled = false //是否在折线图上添加边框
        drawGridBackgroundEnabled = false // 是否显示表格颜色
        drawBarShadowEnabled = false //柱状图没有数据的部分是否显示阴影效果
        doubleTapToZoomEnabled = false

        drawValueAboveBarEnabled = true
        
        rightAxis.enabled = false // Y轴方向左边 不放轴
        leftAxis.enabled = false // Y轴方向右边 不放轴
        
        delegate = self
        highlightPerTapEnabled = false // 点击时是否高亮
                if timeBucketStyle != .Month {
            
            dragEnabled = false // 是否可以拖拽
            setScaleEnabled(false)
            pinchZoomEnabled = false

        }
        
        descriptionText = "\(maxValue + 1)k"
        descriptionFont = UIFont.systemFontOfSize(12)
        descriptionTextPosition = CGPointMake(20, 0)
        descriptionTextColor = UIColor.whiteColor()
        
    }

    /**
     添加网格
     */
    func addxAxis(){
    
        let xAxis = self.xAxis
        xAxis.drawGridLinesEnabled = false // 是否显示尺线
        xAxis.drawAxisLineEnabled = false //是否显示X轴
        xAxis.drawLabelsEnabled = true  //是否显示X轴数值
        xAxis.labelPosition = .Bottom //设置X轴的位置 默认在上方
        xAxis.labelTextColor =  UIColor.whiteColor()
        
        switch timeBucketStyle {
        case .Day:
            
            spaceBetweenLabels = 5

        case .Week:

            spaceBetweenLabels = 0

        case .Month:

            spaceBetweenLabels = 3

        }
        
        xAxis.setLabelsToSkip(spaceBetweenLabels) //设置横坐标显示的间隔

    }

    /**
     添加右上角标志
     */
    func addLegend() {
        
        self.legend.horizontalAlignment = .Right
        self.legend.verticalAlignment = .Top
        self.legend.form = .Circle
        self.legend.formSize = 10
        self.legend.textColor = UIColor.whiteColor()
        self.legend.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        self.legend.xEntrySpace = 10
        
    }
    
    /**
     添加数据
     
     - parameter count: 条纹个数
     */
    func setData(count: Int) {
        
        maxValue = 0
        
        var xVals: [String] = []
        var yVals: [BarChartDataEntry] = []
        
        if chartsData.count == 0 {
            
            return
            
        }
        
        for i in 0 ..< chartsData.count {
            
            if timeBucketStyle == .Week {
                
                xVals.append(weekArray[i])

            } else {
                
                xVals.append(chartsData[i].time)
                
            }
            // 假数据
//            let dataEntry = BarChartDataEntry(value: Double(arc4random_uniform(30)+1)/10, xIndex: i)
        
            if maxValue < chartsData[i].step / 1000 {
                maxValue = chartsData[i].step / 1000
            }
            
            let dataEntry = BarChartDataEntry(value: Double(chartsData[i].step), xIndex: i)
            
            yVals.append(dataEntry)
        }
        
        descriptionText = "\(maxValue + 1)k"
        
        var dataSet = BarChartDataSet()
        if self.data?.dataSetCount > 0 {
            
            dataSet =  self.data?.dataSets[0] as! BarChartDataSet
            self.notifyDataSetChanged()
    
        } else {
            
            dataSet = BarChartDataSet(yVals: yVals, label: legdendText)
            dataSet.barSpace = 0.80
            dataSet.setColors(legendColors, alpha: 0.9)
            dataSet.valueTextColor = UIColor.whiteColor()
            dataSet.highlightAlpha = 0.2
            dataSet.barShadowColor = UIColor.clearColor()
            dataSet.drawValuesEnabled = false
            
            var dataSets: [BarChartDataSet] = []
            dataSets.append(dataSet)
            
            let data = BarChartData(xVals: xVals, dataSets: dataSets)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 12))

            self.data = data
            // 动画
            self.animate(yAxisDuration: 0)
            }

    }
    
    // MARK: -- ChartViewDelegate
    /**
     点击事件
     */
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
//        Log.info("\n\(chartView)\n\(entry)\n\(dataSetIndex)\n\(highlight)")
        
        var totalStep = 0
        
        for data in chartsData {
            totalStep += data.step
        }
        
//        if totalStep != 0 {
//            chartView.data?.setDrawValues(true)
            
//            chartView.setNeedsDisplay()
//        }
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        
//        chartView.data?.setDrawValues(false)
        
//        chartView.setNeedsDisplay()

    }
    
   
    
}
