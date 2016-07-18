//
//  ShowStackedChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts
import EZSwiftExtensions

class ShowStackedChartsView: BarChartView, ChartViewDelegate {
    
    var leftMaxValue = 1
    var leftLabelCCount = 1
    var legendLable = L10n.ChartSleep.string
    var legendColors: [UIColor] = [UIColor.whiteColor(), UIColor(named: .ChartSubTimeBucketViewBg)]
    
    var leftUnit = " h"
    var timeBucketStyle: TimeBucketStyle = .Day
    var spaceBetweenLabel = 0
    
    // 深睡浅睡柱状图
    var chartsData: [PerSleepChartsData] = []
    
    // 最大值 显示在左上角
    var maxValue: Int = 0

    /**
     配置所有视图 主入口
     */
    func configAllView() {
        
        Log.info(chartsData)
        
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        setData(chartsData.count)
        
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
        
        descriptionText = "\(maxValue  / 60 + 1)h"
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
        
        var xVals: [String] = []
        var yVals: [BarChartDataEntry] = []
        

        for i in 0 ..< count {
            
            // xVals
            if timeBucketStyle == .Week {
                
                xVals.append(weekArray[i])
                
            } else {
                
                let timeString = chartsData[i].time.toString(format: "d")
                xVals.append(timeString)
                
            }

            // yVals
            // 随机产生数据
//            let val1 = Double(arc4random_uniform(200) + 1)// 浅睡
//            let val2 = Double(arc4random_uniform(200) + 1)// 深睡
            
            // 数据库取出的
            let val1 = Double(chartsData[i].deepSleep)
            let val2 = Double(chartsData[i].lightSleep)
            
            if maxValue < chartsData[i].deepSleep + chartsData[i].lightSleep {
                maxValue = chartsData[i].deepSleep + chartsData[i].lightSleep
            }
            let dataEntrys = BarChartDataEntry(values: [val1, val2], xIndex: i)
        
            yVals.append(dataEntrys)
        }
        
        // 更新左边显示的最大值
        descriptionText = "\(maxValue / 60 + 1)h"

        var dataSet = BarChartDataSet()
        if self.data?.dataSetCount > 0 {
            
            dataSet =  self.data?.dataSets[0] as! BarChartDataSet
            self.notifyDataSetChanged()
            
        } else {
            
            dataSet = BarChartDataSet(yVals: yVals, label: "")// legendLable)
            dataSet.barSpace = 0.75
            dataSet.setColors(legendColors, alpha: 1)
            dataSet.highlightAlpha = 0.2
            dataSet.barShadowColor = UIColor.clearColor()
            dataSet.stackLabels = ["\(L10n.ChartSleepLight.string)", "\(L10n.ChartSleepDeep.string)" ]
            
            
            var dataSets: [BarChartDataSet] = []
            dataSets.append(dataSet)
            let data = BarChartData(xVals: xVals, dataSets: dataSets)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
            // 默认不显示数值
            data.setValueTextColor(UIColor.clearColor())
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
        
        Log.info("\n\(chartView)\n\(entry)\n\(dataSetIndex)\n\(highlight)")
        
        chartView.data?.setDrawValues(true)
        
        chartView.setNeedsDisplay()
        
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        
        chartView.data?.setDrawValues(false)
        
        chartView.setNeedsDisplay()
        
    }
    
    
}
