//
//  ChartInfoCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Realm
import RealmSwift

class ChartInfoCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, ChartsRealmProtocol{

    var viewStyle: ChartViewStyle = .StepChart
    var timeBucketStyle: TimeBucketStyle = .Day
    
    /// 时间标签的String
    var timeData: String = ""

    ///  列表展示信息
    var listView: UITableView?
    
    let dataCount = 4
    
    var realm: Realm = try! Realm()
    var userId: String = ""
    
    /**
     配置
     */
    func configAllView() {
        
        self.backgroundColor = UIColor(named: .ChartBackground)
        
        addChartsViewLayout()
        
        addInfoTableViewLayout()
    }
    
    /**
     添加 chartsView
     */
    func addChartsViewLayout() {
        
        
//        let time: (beginTime: NSDate, endTime: NSDate) = NSDate().timeStringChangeToNSDate(timeData, timeBucket: timeBucketStyle)
        
        if viewStyle == .SleepChart && timeBucketStyle == .Day {
            
            let peiChartView = ShowPieChartsView()
            
//            peiChartView.chartsData = querySleepNumber(time.beginTime, endTime: time.endTime)!.first

            chartViewLayout(peiChartView)
            
        }
        if viewStyle == .SleepChart && timeBucketStyle == .Week || timeBucketStyle == .Month {
            
            let stackChart = ShowStackedChartsView()
            stackChart.timeBucketStyle = self.timeBucketStyle
//            stackChart.chartsData = querySleepNumber(time.beginTime, endTime: time.endTime)!
            stackChart.configAllView()
            chartViewLayout(stackChart)
            
        }
        
        if viewStyle == .StepChart {
            
            let chartView = ShowChartsView()
            chartView.timeBucketStyle = self.timeBucketStyle
            chartView.configAllView()
//            chartView.chartsData = queryStepNumber(time.beginTime, endTime: time.endTime, timeBucket: timeBucketStyle)!.datas
            chartViewLayout(chartView)
            
        }

    }
    
    /**
     添加tableView
     */
    func addInfoTableViewLayout() {
        
        var listViewHeight: CGFloat = 0
        
        switch viewStyle {
            
        case .SleepChart:
           listViewHeight  = listcellHight * 3 + 20
            
        case .StepChart:
            
            listViewHeight = listcellHight * 4 + 20
        }
        
        let listBottomView = UIView()
        self.addSubview(listBottomView)
        listBottomView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(chartViewHight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHeight))
        }
        listBottomView.backgroundColor = UIColor.whiteColor()
        
        listView = UITableView()
        listBottomView.addSubview(listView!)
        listView!.backgroundColor = UIColor.whiteColor()
        

        listView!.snp_makeConstraints { make in
            make.top.equalTo(listBottomView).offset(10)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHeight - 20))
        }
        listView!.delegate = self
        listView!.dataSource = self
        listView!.separatorStyle = .None
        listView!.scrollEnabled = false
        
        listView!.registerNib(UINib(nibName: "ChartInfoListCell", bundle: nil), forCellReuseIdentifier: "ChartInfoListCell")
        listView!.registerNib(UINib(nibName: "ChartSleepInfoCell", bundle: nil), forCellReuseIdentifier: "ChartSleepInfoCell")

    }
    
    /**
     ChartsView Layout
     */
    func chartViewLayout(view: UIView) {
        self.addSubview(view)
        
        view.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: chartViewHight))
        }
    }
    
       
    // MARK: -- UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewStyle {
            
        case .SleepChart:
            
            return dataCount - 1
            
        case .StepChart:
            
            return dataCount
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return listcellHight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dataStepArray: [String] = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]
        let dataSleepArray: [String] = [L10n.ChartSleepDegreeDeep.string + L10n.ChartSleep.string, L10n.ChartSleepDegreeLight.string + L10n.ChartSleep.string, L10n.ChartTargetPercent.string]
        
        let sleepDegree: [UIColor] = [UIColor(named: .ChartSleepDegreeLight), UIColor(named: .ChartSleepDegreeDeep)]
        
        switch viewStyle {
            
        case .SleepChart:
            
            if indexPath.row == 0 || indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("ChartSleepInfoCell", forIndexPath: indexPath) as! ChartSleepInfoCell
                
                cell.roundSleepView.backgroundColor = sleepDegree[indexPath.row]
                cell.sleepDegree.text  = dataSleepArray[indexPath.row]
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            cell.leftLabel.text = dataSleepArray[indexPath.row]
            
            return cell
            
        case .StepChart:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            cell.leftLabel.text = dataStepArray[indexPath.row]
            
            return cell

        }
        
    }
    
}
