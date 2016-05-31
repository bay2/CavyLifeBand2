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

class ChartInfoCollectionCell: UICollectionViewCell, ChartsRealmProtocol, UserInfoRealmOperateDelegate {

    var viewStyle: ChartViewStyle = .StepChart
    var timeBucketStyle: TimeBucketStyle = .Day
    let listCount = 4
    
    /// 时间标签的String
    var timeString: String = ""

    ///  列表展示信息
    var listView: UITableView?

    var listDataArray: [String] = ["","","",""]
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    /**
     配置
     */
    func configAllView() {
        
        self.backgroundColor = UIColor(named: .ChartBackground)
        
        addChartsView()
        
        addInfoTableView()
    }
    
    /**
     添加 chartsView
     */
    func addChartsView() {
        
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
            
            let sleepInfo = querySleepInfoDay(time.beginTime, endTime: time.endTime)
            listDataArray = infoViewSleepListArray([sleepInfo])
            
            let peiChartView = ShowPieChartsView(frame: CGRectMake(0, 0, 0, 0), deepSleep: sleepInfo.1, lightSleep: sleepInfo.2)
            
            chartViewLayout(peiChartView)
            
        }
        
        if viewStyle == .SleepChart && (timeBucketStyle == .Week || timeBucketStyle == .Month) {
            
            let sleepInfo = self.querySleepInfoDays(time.beginTime, endTime: time.endTime)
            let stackChart = ShowStackedChartsView()
            
            listDataArray = infoViewSleepListArray(sleepInfo)
            
            stackChart.timeBucketStyle = self.timeBucketStyle
            
            stackChart.chartsData = sleepInfo.map { ($0.1, $0.2) }
            
            stackChart.configAllView()
            chartViewLayout(stackChart)
            
        }
        
    }
    
    /**
     添加tableView
     */
    func addInfoTableView() {
        
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
    
    /**
     Charts计步详情页面 下面的TableView的cell上数值的 Array
     */
    func infoViewStepListArray(stepRealm: StepChartsData) -> [String]{
       
        var resultArray: [String] = []
        var percent = 0
        let minutes = stepRealm.finishTime

        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return ["0","0","0","0\(L10n.HomeSleepRingUnitMinute.string)"]
        }
        
        let stepTargetNumber = userInfo.stepNum
        if stepTargetNumber != 0 {
            percent = stepRealm.totalStep * 100 / stepTargetNumber
        }
        if percent > 100 {
            percent = 100
        }
        
        let hour = minutes / 60
        let min = minutes - hour * 60
        
        let kilometer = String(format: "%.1f", stepRealm.totalKilometer)
        resultArray.append("\(stepRealm.totalStep)\(L10n.GuideStep.string)")
        resultArray.append("\(kilometer)km")
        resultArray.append("\(percent)%")
        resultArray.append("\(hour)\(L10n.HomeSleepRingUnitHour.string)\(min)\(L10n.HomeSleepRingUnitMinute.string)")

        return resultArray
    }
    
    /**
     Charts睡眠详情页面 下面的TableView的cell上数值的 Array
     */
    func infoViewSleepListArray(sleepRealm: [(Double, Double, Double)]) -> [String] {
        
        var resultArray: [String] = []
        
        var percent = 0
        
        let newSleepData = sleepRealm.reduce((0, 0, 0)) { (count: (Double, Double, Double), sleepData: (Double, Double, Double)) -> (Double, Double, Double) in
            return (((count.0 + sleepData.0)), ((count.1 + sleepData.1)), ((count.2 + sleepData.2)))
        }
        
        let totalTime  = Int(newSleepData.0) * 10
        let deepSleep  = Int(newSleepData.1) * 10
        let lightSleep = Int(newSleepData.2) * 10
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return ["0\(L10n.HomeSleepRingUnitMinute.string)", "0\(L10n.HomeSleepRingUnitMinute.string)", "0%"]
        }
        
        let sleepTarge = userInfo.sleepTime
        let array = sleepTarge.componentsSeparatedByString(":")
        let targetMinutes = array[0].toInt()! * 60 + array[1].toInt()!
        
        if targetMinutes != 0 {
            percent = totalTime * 100 / targetMinutes
        }
        if percent > 100 {
            percent = 100
        }
        
        resultArray.append("\(deepSleep / 60)\(L10n.HomeSleepRingUnitHour.string)\(deepSleep % 60)\(L10n.HomeSleepRingUnitMinute.string)")
        resultArray.append("\(lightSleep / 60)\(L10n.HomeSleepRingUnitHour.string)\(lightSleep % 60)\(L10n.HomeSleepRingUnitMinute.string)")
        resultArray.append("\(percent)%")

        return resultArray
    }

}

// MARK: -- UITableViewDelegate
extension ChartInfoCollectionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewStyle {
            
        case .SleepChart:
            
            return listCount - 1
            
        case .StepChart:
            
            return listCount
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
                cell.rightLabel.text = listDataArray[indexPath.row]
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            cell.leftLabel.text = dataSleepArray[indexPath.row]
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
