//
//  ChartsInfoCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Realm
import RealmSwift

class ChartsInfoCollectionCell: UICollectionViewCell, ChartsRealmProtocol, UserInfoRealmOperateDelegate {

    var viewStyle: ChartViewStyle = .StepChart
    var timeBucketStyle: TimeBucketStyle = .Day
    
    var listCount = 4
    
    /// 时间标签的String
    var timeString: String = ""

    // 图标视图
    var chartsView = UIView()
    /// 列表展示信息
    var listView: UITableView?
    
    // 列表展示数据值
    var listDataArray: [String] = []
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    /**
     配置
     */
    func configAllView() {
        
        self.backgroundColor = UIColor.whiteColor()//(named: .ChartBackground)
        
        if viewStyle == .SleepChart {
            
            listCount = 3
            
        }
        
        addChartsView()
        
        addInfoTableView()
    }
    
    /**
     添加 chartsView
     */
    func addChartsView() {
        
        chartsView.backgroundColor = UIColor(named: .HomeViewMainColor)
        self.addSubview(chartsView)
        chartsView.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: ez.screenWidth, height: chartViewHight))
        }
        
        let date = NSDate(fromString: timeString, format: "yyyy.M.d")!
        
        let time: (beginTime: NSDate, endTime: NSDate) = date.timeStringChangeToNSDate(timeBucketStyle)
        
        if viewStyle == .StepChart {
            
            let chartView = ShowChartsView()
            chartView.timeBucketStyle = self.timeBucketStyle
            
            let stepRealms =  queryStepNumber(time.beginTime, endTime: time.endTime, timeBucket: timeBucketStyle)
            
            listDataArray = infoViewStepListArray(stepRealms)
            listView?.reloadData()
            chartView.chartsData = stepRealms.datas
            
            chartViewLayout(chartView)
            chartView.configAllView()
            
        }

        if viewStyle == .SleepChart && timeBucketStyle == .Day {
            
            
            let sleepInfo = querySleepNumber(time.beginTime, endTime: time.endTime)
            
            listDataArray = infoViewSleepListArray(sleepInfo)
            
            let peiChartView = ShowPieChartsView(frame: CGRectMake(0, 0, 0, 0), deepSleep: sleepInfo.first!.deepSleep, lightSleep: sleepInfo.first!.lightSleep)
            chartViewLayout(peiChartView)
            
        }
        
        if viewStyle == .SleepChart && (timeBucketStyle == .Week || timeBucketStyle == .Month) {
            
            let stackChart = ShowStackedChartsView()
            
            let sleepInfo = querySleepNumber(time.beginTime, endTime: time.endTime)
            
            listDataArray = infoViewSleepListArray(sleepInfo)
            
            stackChart.timeBucketStyle = self.timeBucketStyle
            
            stackChart.chartsData = sleepInfo.map{
                
                return PerSleepChartsData(time: $0.time, deepSleep: $0.deepSleep, lightSleep: $0.lightSleep)
            }
            
            stackChart.configAllView()
            chartViewLayout(stackChart)
            
        }
        
    }
    
    /**
     添加tableView
     */
    func addInfoTableView() {

        let listViewHeight = listcellHight * CGFloat(listCount)
        listView = UITableView()
        listView!.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        listView!.separatorStyle = .SingleLine
        listView!.separatorColor = UIColor(named: .LColor)
        listView!.backgroundColor = UIColor.whiteColor()

        self.addSubview(listView!)
        
        listView!.snp_makeConstraints { make in
            make.top.equalTo(self).offset(chartViewHight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: ez.screenWidth, height: listViewHeight))
        }
        
        listView!.delegate = self
        listView!.dataSource = self
        listView!.scrollEnabled = false
        
        listView!.registerNib(UINib(nibName: "ChartInfoListCell", bundle: nil), forCellReuseIdentifier: "ChartInfoListCell")
        listView!.registerNib(UINib(nibName: "ChartSleepInfoCell", bundle: nil), forCellReuseIdentifier: "ChartSleepInfoCell")

    }
    
    /**
     ChartsView Layout
     */
    func chartViewLayout(view: UIView) {
        
        chartsView.addSubview(view)
        
        view.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: chartTopHeigh / 2 - 5 , left: insetSpace, bottom: -(chartBottomHeigh / 2 - 5), right: -insetSpace))
        }
    }
    
    /**
     Charts计步详情页面 下面的TableView的cell上数值的 Array
     */
    private func infoViewStepListArray(stepRealm: StepChartsData) -> [String]{
       
        var resultArray: [String] = []
        var percent = 0
        let minutes = stepRealm.finishTime

        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return ["0", "0", "0", "0\(L10n.HomeSleepRingUnitMinute.string)"]
        }
        
        var stepTargetNumber = userInfo.stepGoal
        
        if stepTargetNumber == 0 {
            stepTargetNumber = 8000
        }
        
        percent = stepRealm.totalStep * 100 / stepTargetNumber
        if percent > 100 {
            percent = 100
        }
        
        let hour = minutes / 60
        let min = minutes - hour * 60
        
        let kilometer = String(format: "%.1f", stepRealm.totalKilometer)
        resultArray.append("\(stepRealm.totalStep)\(L10n.GuideStep.string)")
        resultArray.append("\(kilometer)km")
        // 日:完成度 周&月:日均步数 
        switch timeBucketStyle {
        case .Day:
            
            resultArray.append("\(percent)%")
            
        case .Week, .Month:
            
            resultArray.append("\(stepRealm.totalStep / 30)\(L10n.GuideStep.string)")

        }
        
        resultArray.append("\(hour)\(L10n.HomeSleepRingUnitHour.string)\(min)\(L10n.HomeSleepRingUnitMinute.string)")

        return resultArray
    }
    
    /**
     Charts睡眠详情页面 下面的TableView的cell上数值的 Array
     */
    private func infoViewSleepListArray(sleepInfo: [PerSleepChartsData]) -> [String] {
        
        var resultArray: [String] = []
        
        var percent = 0
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return ["0\(L10n.HomeSleepRingUnitMinute.string)", "0\(L10n.HomeSleepRingUnitMinute.string)", "0%"]
        }
        
        var sleepTarge = "\(userInfo.sleepGoal/60):\(userInfo.sleepGoal%60)"
        
        if sleepTarge == "0:0" {
            
            sleepTarge = "8:30"
            
        }
        
        let array = sleepTarge.componentsSeparatedByString(":")
        
        guard array.count == 2 else {
            
            return resultArray
        }
        
        let targetMinutes = array[0].toInt()! * 60 + array[1].toInt()!
        
        let  sleepNumber = 0
        
        // 60% 格式 所以 * 100
        if targetMinutes != 0 {
            
            switch timeBucketStyle {
                
            case .Day:
                percent = sleepNumber / targetMinutes * 100
                
            case .Week:
                
                percent = sleepNumber / targetMinutes * 7 * 100
                
            case .Month:
                
                let currentDay = timeString.componentsSeparatedByString(".")
                let days = NSDate().daysCount(currentDay[0].toInt()!, month: currentDay[1].toInt()!)
                percent = sleepNumber / targetMinutes * days * 100
                
            }
        }
        
        if percent > 100 {
            percent = 100
        }
        
        var deepSleep: Int  = 0
        var lightSleep: Int = 0

        for perData in sleepInfo {
            
            deepSleep += perData.deepSleep
            lightSleep += perData.lightSleep
            
        }
       
        resultArray.append("\(lightSleep / 6)\(L10n.HomeSleepRingUnitHour.string)\(lightSleep % 6)\(L10n.HomeSleepRingUnitMinute.string)")
        resultArray.append("\(deepSleep / 6)\(L10n.HomeSleepRingUnitHour.string)\(deepSleep % 6)\(L10n.HomeSleepRingUnitMinute.string)")
        
        // 日:完成度 周&月:日均步数
        switch timeBucketStyle {
        case .Day:
            
            resultArray.append("\(percent)%")
            
        case .Week, .Month:
            
            let avgSleepTime = deepSleep + lightSleep / 30

            resultArray.append("\(avgSleepTime / 6)\(L10n.HomeSleepRingUnitHour.string)\(avgSleepTime % 6)\(L10n.HomeSleepRingUnitMinute.string)")
            
        }


        return resultArray
    }

}

// MARK: -- UITableViewDelegate
extension ChartsInfoCollectionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return listCount
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return listcellHight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        var dataStepArray: [String] = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]

        switch timeBucketStyle {
            
        case .Week:
            dataStepArray = [L10n.ChartStepWeekStep.string, L10n.ChartStepKilometer.string, L10n.ChartStepAverageStep.string, L10n.ChartStepTimeUsed.string]
        case .Month:
            
            dataStepArray = [L10n.ChartStepMonthStep.string, L10n.ChartStepKilometer.string, L10n.ChartStepAverageStep.string, L10n.ChartStepTimeUsed.string]

        default:
            dataStepArray = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]

            
        }
        
        let sleepStatusArray: [SleepStatus] = [.LightSleep, .DeepSleep]
        
        switch viewStyle {
            
        case .SleepChart:
            
            if indexPath.row == 0 || indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("ChartSleepInfoCell", forIndexPath: indexPath) as! ChartSleepInfoCell
                
                cell.configSleepCell(sleepStatusArray[indexPath.row], text: "8")
                cell.rightLabel.text = listDataArray[indexPath.row]
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            
            switch timeBucketStyle {
            case.Day:
                cell.leftLabel.text = L10n.ChartTargetPercent.string
            case .Week, .Month:
                cell.leftLabel.text = L10n.ChartSleepAverage.string
            }
            
            cell.rightLabel.text = listDataArray[indexPath.row]
           
            return cell
            
        case .StepChart:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            cell.leftLabel.text = dataStepArray[indexPath.row]
            
            cell.rightLabel.text = listDataArray[indexPath.row]
            
            return cell

        }
        
    }
    
}
