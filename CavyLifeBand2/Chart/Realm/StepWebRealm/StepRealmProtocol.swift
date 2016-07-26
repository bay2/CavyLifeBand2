//
//  StepRealmProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import JSONJoy

// MARK: 服务器计步数据库操作协议
protocol ChartStepRealmProtocol {
    
    var realm: Realm { get }
    var userId: String { get }
    
    func addWebStepRealm(chartStepInfo: StepWebRealm) -> Bool
    func delWebStepRealm(chartStepInfo: StepWebRealm) -> Bool
    func delWebStepRealm(beginTime: NSDate, endTime: NSDate) -> Bool
    
    func queryAllWebStepRealm(userId: String) -> Results<(StepWebRealm)>?
    func queryWebStepRealm(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData?
    
}


extension ChartStepRealmProtocol {
    
    /**
     返回从服务器存储拉取的所有单条数据
     */
    func queryAllWebStepRealm(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(StepWebRealm)>? {
        
        return realm.objects(StepWebRealm).filter("userId = '\(userId)'")
        
    }
    
    
    /**
     查询 日周月下 某一时段的 数据信息
     */
    func queryWebStepRealm(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData? {
        
        let today = endTime.gregorian.isToday
        // 判断是否是当然 如果是当天 则查询日期往前推一天
        var scanTime: NSDate
        
        if today {
            
            scanTime = NSDate(timeInterval: -24 * 60 * 60, sinceDate: endTime)
            
        } else {
            
            scanTime = endTime
        }
        
        //转换时间格式
        let dataInfo = realm.objects(StepWebRealm).filter("userId == '\(userId)' AND date => %@ AND date <= %@", beginTime.gregorian.beginningOfDay.date, scanTime.gregorian.beginningOfDay.date)
        
        Log.info("\(dataInfo.count)")
        print("=============\(dataInfo.count)==============")
        
        switch timeBucket {
            
        case .Day:
            
            if today {
                return returnHourChartsArray(nil)
            }else{
                return returnHourChartsArray(dataInfo)
            }
            
            
        case .Week, .Month:
            
            return returnDayChartsArray(beginTime, endTime: endTime, dataInfo: dataInfo)
            
        }
        
    }
    
    
    /**
     添加计步数据
     - parameter chartsInfo: 用户的计步信息
     - returns: 成功：true 失败： false
     */
    func addWebStepRealm(chartsInfo: StepWebRealm) -> Bool {
        
        do {
            
            try realm.write {
                
                realm.add(chartsInfo, update: false)
            }
            
        } catch {
            
            Log.error("Add charts info error [\(chartsInfo)]")
            return false
            
        }
        
        Log.info("Add charts info success")
        
        return true
        
    }
    

 
    /**
     删除某一条数据
     */
    func delWebStepRealm(chartStepInfo: StepWebRealm) -> Bool {
        
        self.realm.beginWrite()
        
        self.realm.delete(chartStepInfo)
        
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
     */
    func delWebStepRealm(beginTime: NSDate, endTime: NSDate) -> Bool {
        
        
        let dataInfo = realm.objects(StepWebRealm).filter("userId == '\(userId)' AND date > %@ AND date < %@", beginTime, endTime)
        
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
    

 
    
    /**
     按小时分组 一天24小时
     */
    private func returnHourChartsArray(dataInfo: Results<(StepWebRealm)>?) -> StepChartsData? {
        
        
        guard let newData = dataInfo else {
            
            return nil
        }
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        // 初始化0~23 24 小时
        for i in 0...23 {
            
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        for data in newData {
            
            stepChartsData.totalStep = data.totalStep
            stepChartsData.totalKilometer = data.kilometer
            stepChartsData.finishTime = data.totalTime
            stepChartsData.averageStep = data.totalStep
            
            var index: Int = 0
            for step in data.stepList {
                
                index += 1
                stepChartsData.datas[index - 1].step = step.step
                
            }
            
            
        }
        
        return stepChartsData
        
    }
    
    
    
    /**
     按天分组 一周七天 一个月30天
     */
    private func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(StepWebRealm)>) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        
        let maxNum = (endTime - beginTime).totalDays + 1
        
        for i in 1...maxNum {
            
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        var averageStepCount = 0
        
        var indext = 0
        
        let dataInfoArr = completeStepData(beginTime, endTime: endTime, dataInfo: dataInfo)
        
        for data in dataInfoArr {
            
            indext += 1
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.totalStep += data.totalStep
            stepChartsData.finishTime += data.totalTime
            
            
            // 取平局数时候去除0步的情况
            
            if data.totalStep != 0 {
                
                averageStepCount += 1
            }
            
            
            if indext - 1 < maxNum   {
                
                stepChartsData.datas[indext - 1].step = data.totalStep
            }
            
            
        }
        
        if averageStepCount == 0 {
            
            stepChartsData.averageStep = 0
            
        }else {
            
            stepChartsData.averageStep = Int(stepChartsData.finishTime / averageStepCount)
        }
        
        
        return stepChartsData
        
    }
    
    
    /**
     数据补齐操作
     
     - parameter beginTime: <#beginTime description#>
     - parameter endTime:   <#endTime description#>
     
     - returns: <#return value description#>
     */
    
    private func completeStepData(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(StepWebRealm)>) -> [StepWebRealm]{
        
        let maxNum = (NSDate().gregorian.date - beginTime).totalDays + 1
        let infoCount = dataInfo.count
        var resultDataArr: [StepWebRealm] = []
        
        if infoCount < maxNum {
            
            for _ in 0..<(maxNum - infoCount) {
                
                resultDataArr.append(StepWebRealm())
            }
            
        }
        
        for data in dataInfo {
            
            resultDataArr.append(data)
        }
        
        
        return resultDataArr
    }
    
    
    //
    //    /**
    //     是否需要从服务器拉取计步数据
    //
    //     - returns: <#return value description#>
    //     */
    //
    //    func isNeedUpdateNStepData() -> Bool {
    //
    //        let list = realm.objects(StepWebRealm)
    //
    //        if list.count == 0 {
    //            return true
    //        }
    //
    //        let personalList = realm.objects(StepWebRealm).filter("userId = '\(userId)'")
    //
    //        if personalList.count == 0 {
    //            return true
    //        }
    //
    //        let totalMinutes = (NSDate().gregorian.beginningOfDay.date - personalList.last!.date).totalMinutes
    //        Log.info(totalMinutes)
    //
    //        if totalMinutes > 10 {
    //            return true
    //        }
    //        
    //        return false
    //        
    //    }
    
    

}




