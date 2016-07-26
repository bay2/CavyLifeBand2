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
    var attrsArray: [NSAttributedString] = []
    
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
            
            let stepRealms = queryStepNumber(time.beginTime, endTime: time.endTime, timeBucket: timeBucketStyle)
            
            attrsArray = infoViewStepListAttributeArray(stepRealms)
            
            listView?.reloadData()
            chartView.chartsData = stepRealms.datas
            
            chartViewLayout(chartView)
            chartView.configAllView()
            
        }
        
        if viewStyle == .SleepChart && timeBucketStyle == .Day {
            
            let sleepInfo = querySleepNumber(time.beginTime, endTime: time.endTime)
            
            attrsArray = infoViewSleepListAttrributeArray(sleepInfo)
            
            let peiChartView = ShowPieChartsView(frame: CGRectMake(0, 0, 0, 0), deepSleep: Int(sleepInfo.first?.deepSleep ?? 0), lightSleep: sleepInfo.first?.lightSleep ?? 0)
            
            chartViewLayout(peiChartView)
            
        }
        
        if viewStyle == .SleepChart && (timeBucketStyle == .Week || timeBucketStyle == .Month) {
            
            let stackChart = ShowStackedChartsView()
            
            let sleepInfo = querySleepNumber(time.beginTime, endTime: time.endTime)
            
            attrsArray = infoViewSleepListAttrributeArray(sleepInfo)
            
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
            make.edges.equalTo(UIEdgeInsets(top: chartTopHeigh / 2 - 5, left: insetSpace / 2, bottom: -(chartBottomHeigh / 2 - 5), right: -insetSpace / 2))
        }
        
        // 添加计步 右上角的legend
        if viewStyle == .StepChart {
            
            let label = UILabel()
            chartsView.addSubview(label)
            label.snp_makeConstraints { make in
                make.top.equalTo(0).offset(chartTopHeigh / 2)
                make.right.equalTo(0).offset(-insetSpace)
            }
            label.text = L10n.ChartStepTodayStep.string
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = UIColor.whiteColor()
            
        }
        
        // 添加睡眠 右上角的legend
        if viewStyle == .SleepChart {
            
            let sleepLegend = NSBundle.mainBundle().loadNibNamed("ChartsSleepLegendView", owner: nil, options: nil).first as? ChartsSleepLegendView
            chartsView.addSubview(sleepLegend!)
            sleepLegend!.snp_makeConstraints { make in
                make.top.equalTo(0).offset(chartTopHeigh / 2 - 5)
                make.right.equalTo(0).offset(-insetSpace)
            }
            
        }
        
    }
    
    /**
     返回富文本Array
     */
    private func infoViewStepListAttributeArray(stepRealm: StepChartsData) -> [NSAttributedString]{
        
        var resultArray: [NSAttributedString] = []
        var percent = 0
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            
            var attrs: [NSAttributedString] = []
            
            attrs.append(String(0).detailAttributeString(L10n.GuideStep.string))
            
            attrs.append(String(0).detailAttributeString("km"))
            if timeBucketStyle == .Day {
                attrs.append(String(0).detailAttributeString("%"))
            } else {
                attrs.append(String(0).detailAttributeString(L10n.GuideStep.string))
            }
            attrs.append(0.detailTimeAttributeString())
            
            return attrs
        }
        
        var stepTargetNumber = userInfo.stepGoal
        
        if stepTargetNumber == 0 {
            stepTargetNumber = 8000
        }
        
        percent = stepRealm.totalStep * 100 / stepTargetNumber
        
        if percent > 100 {
            percent = 100
        }
        
        let kilometer = String(format: "%.1f", stepRealm.totalKilometer)
        resultArray.append(String(stepRealm.totalStep).detailAttributeString(L10n.GuideStep.string))
        resultArray.append(String(kilometer).detailAttributeString("km"))
        
        
        // 日:完成度 周&月:日均步数
        switch timeBucketStyle {
        case .Day:
            
            resultArray.append(String(percent).detailAttributeString("%"))
            
        case .Week, .Month:
            
            resultArray.append(String(stepRealm.averageStep).detailAttributeString(L10n.GuideStep.string))
        }
        
        resultArray.append(stepRealm.finishTime.detailTimeAttributeString())
        
        return resultArray
    }
    
    
    /**
     睡眠富文本数组
     */
    private func infoViewSleepListAttrributeArray(sleepInfo: [PerSleepChartsData]) -> [NSAttributedString] {
        
        var resultArray: [NSAttributedString] = []
        
        // 有数据的天数
        var avgIndex = 0
        var percent = 0
        
        var deepSleep: Int  = 0
        var lightSleep: Int = 0
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            
            var attrs: [NSAttributedString] = []
            
            attrs.append(0.detailTimeAttributeString())
            attrs.append(0.detailTimeAttributeString())
            attrs.append(0.detailTimeAttributeString())
            
            return attrs
        }
        
        var sleepTarge = userInfo.sleepGoal
        
        if sleepTarge == 0 {
            
            sleepTarge = 500
            
        }
        
        for perData in sleepInfo {
            
            deepSleep += perData.deepSleep
            lightSleep += perData.lightSleep
            if (perData.deepSleep + perData.lightSleep) != 0 {
                avgIndex += 1
            }
            
        }
        if avgIndex == 0 { avgIndex = 1 }
        
        let sleepCur = deepSleep + lightSleep
        
        // 60% 格式 所以 * 100
        if sleepTarge != 0 && timeBucketStyle == .Day {
            
            percent = sleepCur * 100 / sleepTarge
            
        }
        
        if percent > 100 {
            percent = 100
        }
        
        resultArray.append(lightSleep.detailTimeAttributeString())
        resultArray.append(deepSleep.detailTimeAttributeString())
        
        // 日:完成度 周&月:日均步数
        switch timeBucketStyle {
            
        case .Day:
            
            resultArray.append(String(percent).detailAttributeString("%"))
            
        case .Week, .Month:
            
            let avgSleepTime = sleepCur / avgIndex
            
            resultArray.append(avgSleepTime.detailTimeAttributeString())
            
        }
        
        return resultArray
    }
    
    
    /**
     - parameter sleepInfo: (总的睡眠时间,浅睡, 深睡)
     
     - returns: 当天的数据
////     */
    private func infoViewSleepListAttrributeArray(sleepInfo: (Double, Double, Double)) -> [NSAttributedString] {
        
        
        var resultArray: [NSAttributedString] = []
   
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            
            var attrs: [NSAttributedString] = []
            
            attrs.append(0.detailTimeAttributeString())
            attrs.append(0.detailTimeAttributeString())
            attrs.append(0.detailTimeAttributeString())
            
            return attrs
        }
        
        var sleepTarge = userInfo.sleepGoal
        
        if sleepTarge == 0 {
            
            sleepTarge = 500
            
        }
        
      
       var  percent = Int(sleepInfo.0  / Double(sleepTarge) * 100)
        
        if percent > 100 {
            percent = 100
        }
        
        resultArray.append(Int(sleepInfo.2).detailTimeAttributeString())
        resultArray.append(Int(sleepInfo.1).detailTimeAttributeString())
        resultArray.append(String(percent).detailAttributeString("%"))
            
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
                
                cell.rightLabel.attributedText = attrsArray[indexPath.row]
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            
            switch timeBucketStyle {
            case.Day:
                cell.leftLabel.text = L10n.ChartTargetPercent.string
            case .Week, .Month:
                cell.leftLabel.text = L10n.ChartSleepAverage.string
            }
            
            cell.rightLabel.attributedText = attrsArray[indexPath.row]
            
            return cell
            
        case .StepChart:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            cell.leftLabel.text = dataStepArray[indexPath.row]
            
            cell.rightLabel.attributedText = attrsArray[indexPath.row]
            
            return cell
            
        }
        
    }
    
}
