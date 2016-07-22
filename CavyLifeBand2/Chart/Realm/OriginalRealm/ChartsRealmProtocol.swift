//
//  ChartsDataRealm.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import Alamofire
import Realm

// MARK: 计步睡眠数据库操作协议

protocol ChartsRealmProtocol: ChartStepRealmProtocol, SleepWebRealmOperate, UserInfoRealmOperateDelegate {
    
    
    var realm: Realm { get }
    var userId: String { get }
    
    // MARK: Other
    func queryAllStepInfo(userId: String) -> Results<(ChartStepDataRealm)>
    func queryAllSleepInfo(userId: String) -> Results<(ChartSleepDataRealm)>
    func queryTimeBucketFromFirstDay() -> [String]?
    
    // MARK: 计步
    func isNeedUpdateStepData() -> Bool
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool
    // MARK: 修改
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData
    func removeStepData(chartsInfo: ChartStepDataRealm) -> Bool
    func delecSteptDate(beginTime: NSDate, endTime: NSDate) -> Bool
    
    // MARK: 睡眠
    func isNeedUpdateSleepData() -> Bool
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]
    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)]
    func queryTodaySleepInfo() -> (Double, Double, Double)
    func removeSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    
}

// MARK: Other Extension
extension ChartsRealmProtocol {
    
    func queryAllStepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartStepDataRealm)> {
        
        return realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'").sorted("time", ascending: true)
        
    }
    
    // 返回 第一天开始的时间段
    func queryTimeBucketFromFirstDay() -> [String]? {
        
        guard let realmUserInfo: UserInfoModel = queryUserInfo(userId) else {
            return [NSDate().toString(format: "yyyy.M.d")]
        }
        
        let signDate = realmUserInfo.signUpDate ?? NSDate()
        
        return signDate.untilTodayArrayWithFormatter("yyyy.M.d")
    }
    
}

// MARK: Step Extension
extension ChartsRealmProtocol {
    
    /**
     是否需要请求数据
     
     - returns: true 需要请求 false 不需要更新
     */
    func isNeedUpdateStepData() -> Bool {
        
        let list = realm.objects(StepWebRealm)
        
        if list.count == 0 {
            return true
        }
        
        let personalList = realm.objects(StepWebRealm).filter("userId = '\(userId)'")
        
        if personalList.count == 0 {
            return true
        }
        
        let totalMinutes = (NSDate().gregorian.beginningOfDay.date - personalList.last!.date).totalMinutes
        Log.info(totalMinutes)
        
        if totalMinutes > 10 {
            return true
        }
        
        return false
        
    }
    
    /**
     添加计步数据
     - parameter chartsInfo: 用户的计步信息
     - returns: 成功：true 失败： false
     */
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool {
        
        do {
            
            try realm.write {
                
                realm.add(chartsInfo, update: false)
            }
            
        } catch {
            
            Log.error("Add step charts info error [\(chartsInfo)]")
            return false
            
        }
        
        Log.info("Add step charts info success")
        
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
     */
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData {
        
        // 取出服务区查询所得数据
        let  serverData =  queryNStepNumber(beginTime, endTime: endTime, timeBucket: timeBucket)
        
        switch timeBucket {
            
        case .Day:
            
            if endTime.gregorian.isToday {
                
                let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime.timeStringChangeToNSDate(.Day).0, endTime.timeStringChangeToNSDate(.Day).1)
                
                return returnHourChartsArray(dataInfo, stepData: nil)
                
            }else
                
            {
                
                return returnHourChartsArray(nil, stepData: serverData)
            }
            
            
            
        case .Week, .Month:
            
            
            if endTime.gregorian.isToday {
                
                let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime.timeStringChangeToNSDate(.Day).0, endTime.timeStringChangeToNSDate(.Day).1)
                
                return returnDayChartsArray(beginTime, endTime: endTime, dataInfo: dataInfo, stepData: serverData)
                
            }else{
                
                return returnDayChartsArray(beginTime, endTime: endTime, dataInfo: nil, stepData: serverData)
            }
            
        }
    }
    
    /**
     按小时分组 一天24小时
     */
    func returnHourChartsArray(dataInfo: Results<(ChartStepDataRealm)>?, stepData: StepChartsData?) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        // 初始化0~23 24 小时
        for i in 0...23 {
            
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        if dataInfo != nil {
            
            for data in dataInfo! {
                
                let index = data.time.gregorian.components.hour
                stepChartsData.totalStep += data.step
                stepChartsData.totalKilometer += data.kilometer
                
                if data.step != 0 {
                    stepChartsData.finishTime += 10
                }
                
                stepChartsData.datas[index].step += data.step
                
            }
        }
        
        if stepData != nil {
            
            stepChartsData.totalStep += stepData!.totalStep
            stepChartsData.totalKilometer += stepData!.totalKilometer
            stepChartsData.finishTime += stepData!.finishTime
            
            for indext in  0..<stepChartsData.datas.count {
                
                stepChartsData.datas[indext].step += stepData!.datas[indext].step
                
            }
        }
        
        
        return stepChartsData
        
    }
    
    /**
     按天分组 一周七天 一个月30天
     
     */    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(ChartStepDataRealm)>?, stepData: StepChartsData?) -> StepChartsData {
        
        
        // 有数据的天数
        var spendDay: Int = 0
        
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        let maxNum = (endTime - beginTime).totalDays + 1
        
        for i in 1...maxNum {
            
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        if dataInfo != nil {
            
            for data in dataInfo! {
                
                let index = (data.time - beginTime).components.day
                
                stepChartsData.totalKilometer += data.kilometer
                stepChartsData.totalStep += data.step
                
                if data.step != 0 {
                    stepChartsData.finishTime += 10
                }
                
                stepChartsData.datas[index].step += data.step
                
            }
        }
        
        if stepData != nil {
            
            stepChartsData.totalStep += stepData!.totalStep
            stepChartsData.totalKilometer += stepData!.totalKilometer
            stepChartsData.finishTime += stepData!.finishTime
            
            
            for indext in  0..<stepChartsData.datas.count {
                
                
                stepChartsData.datas[indext].step += stepData!.datas[indext].step
                if stepChartsData.datas[indext].step != 0 { spendDay += 1 }
            }
            
        }
        
        // 被除数不可以为 0 
        if spendDay == 0 { spendDay = 1 }
        
        stepChartsData.averageStep = stepChartsData.totalStep / spendDay
        
        return stepChartsData
        
    }
    
    /**
     删除某条计步数据
     
     - parameter chartsInfo: 计步
     
     - returns: 是否成功
     */
    func removeStepData(chartsInfo: ChartStepDataRealm) -> Bool {
        
        self.realm.beginWrite()
        
        self.realm.delete(chartsInfo)
        
        do {
            
            try self.realm.commitWrite()
            
        } catch let error {
            
            Log.error("\(#function) error = \(error)")
            
            return false
        }
        Log.info("delete charts info success")
        
        return true
        
        
    }
    
    /**
     删除某一段时间的数据
     
     - parameter beginTime: <#beginTime description#>
     - parameter endTime:   <#endTime description#>
     
     - returns: <#return value description#>
     */
    
    func delecSteptDate(beginTime: NSDate, endTime: NSDate) -> Bool {
        
        
        let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        self.realm.beginWrite()
        
        for data in dataInfo {
            
            self.realm.delete(data)
        }
        
        do {
            
            try self.realm.commitWrite()
            
        } catch let error {
            
            Log.error("\(#function) error = \(error)")
            
            return false
        }
        Log.info("delete charts info success")
        
        return true
        
    }
    
}





