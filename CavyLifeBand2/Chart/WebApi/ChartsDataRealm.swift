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


// MARK: Step
class ChartStepDataRealm: Object {
    
    dynamic var userId = ""
    dynamic var time: NSDate? = nil
    dynamic var step = 0
    dynamic var kilometer = 0

}

// MARK: Sleep
class ChartSleepDataRealm: Object {
    
    dynamic var userId = ""
    dynamic var time: NSDate? = nil
    dynamic var deepSleep = 0
    dynamic var lightSleep = 0
    
}

// MARK: 协议
protocol ChartsRealmProtocol {
    
    var realm: Realm { get }
    var userId: String { get }
    
    func isExistChartsData() -> Bool
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData?
    
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]?
    
    func queryTodayCurrentStepAndSleep() -> (Int, Int)?
}

// MARK: Step Extension
extension ChartsRealmProtocol {
    
    /**
     查询是否有数据
     */
    func isExistChartsData() -> Bool {
        
        
        let list = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
        
        if list.count <= 0 {
            return false
        }
        
        return true
        
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
            
            Log.error("Add charts info error [\(chartsInfo)]")
            return false
            
        }
        
        Log.info("Add charts info success")
        
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
     
     - parameter userId:     用户ID
     - parameter timeBucket: 日周月
     - parameter time:       时间
     */
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData? {
        
        if realm.objects(ChartStepDataRealm).count == 0 {
            return nil
        }
        
        let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > '\(beginTime)' AND time < '\(endTime)' ")
        
        if dataInfo.count == 0 {
            return nil
        }

        var stepDatas: [ChartStepDataRealm] = []
        
        for data in dataInfo {
            stepDatas.append(data)
        }
        
        switch timeBucket {
            
        case .Day:

            return returnHourChartsArray(stepDatas)
            
        case .Week:

            return returnDayChartsArray(stepDatas)
            
        case .Month:
            
            return returnDayChartsArray(stepDatas)
            
        }
     
    }
    
    /**
     按小时分组 一天24小时
     */
    func returnHourChartsArray(dataInfo: [ChartStepDataRealm]) -> StepChartsData {
        
        var stepChartsData: StepChartsData?
        
        var numTemp = 0
        
        for i in 0 ..< dataInfo.count {
            
            // 公里
            stepChartsData!.totalKilometer += dataInfo[i].kilometer
            // 步数
            stepChartsData!.totalStep += dataInfo[i].step
            
            // 花费时长
            if dataInfo[i].step != 0 {
                
                stepChartsData!.finishTime += 10
            }
            
            // 柱状图数据
            numTemp += dataInfo[i].step
            
            if (i + 1) / 6 == 0 {

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "HH"
                let hour = dateFormatter.stringFromDate(dataInfo[i - 1].time!)
                
                let per = PerStepChartsData(time: hour, kilometer: numTemp)
                
                stepChartsData!.datas.append(per)
                
                numTemp = 0
                
            }
            
        }
        
        return stepChartsData!
        
    }
    
    /**
     按天分组 一周七天 一个月30天
     */
    func returnDayChartsArray(dataInfo: [ChartStepDataRealm]) -> StepChartsData {
        
        var stepChartsData: StepChartsData?
        
        var numTemp = 0
        
        for i in 0 ..< dataInfo.count {
            
            // 公里
            stepChartsData!.totalKilometer += dataInfo[i].kilometer
            // 步数
            stepChartsData!.totalStep += dataInfo[i].step
            
            // 花费时长
            if dataInfo[i].step != 0 {
                
                stepChartsData!.finishTime += 10
            }
            
            // 柱状图数据
            numTemp += dataInfo[i].step
            
            if (i + 1) / 6 / 24 == 0 {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.stringFromDate(dataInfo[i - 1].time!)
                
                let per = PerStepChartsData(time: day, kilometer: numTemp)
                
                stepChartsData!.datas.append(per)
                
                numTemp = 0
                
            }
            
        }
        
        return stepChartsData!
        
    }

}

// MARK: Sleep Extension
extension ChartsRealmProtocol {

    /**
     添加计步数据
     - parameter chartsInfo: 用户的计步信息
     - returns: 成功：true 失败： false
     */
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool {
        
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
     查询 日周月下 某一时段的 数据信息
     
     - parameter userId:     用户ID
     - parameter timeBucket: 日周月
     - parameter time:       时间
     */
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]? {
        
        if realm.objects(ChartSleepDataRealm).count == 0 {
            return nil
        }
        
        let dataInfo = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time > '\(beginTime)' AND time < '\(endTime)' ")
        
        if dataInfo.count == 0 {
            return nil
        }
        
        var sleepDatas: [ChartSleepDataRealm] = []
        
        for data in dataInfo {
            sleepDatas.append(data)
        }
            
        return returnDayChartsArray(sleepDatas)
        
    }
    
    /**
     睡眠一天一存
     */
    func returnDayChartsArray(dataInfo: [ChartSleepDataRealm]) -> [PerSleepChartsData] {
        
        var sleepChartsDatas: [PerSleepChartsData]?
        
        var deepTemp = 0
        var lightTemp = 0
        
        for i in 0 ..< dataInfo.count {
            
            deepTemp += dataInfo[i].deepSleep
            lightTemp += dataInfo[i].lightSleep
            
            if (i + 1) / 6 / 24 == 0 {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd"
                let day = dateFormatter.stringFromDate(dataInfo[i - 1].time!)
                
                let per = PerSleepChartsData(time: day, deepSleep: deepTemp, lightSleep: lightTemp)
                sleepChartsDatas!.append(per)
                
                deepTemp = 0
                lightTemp = 0
            }
            
        }
        
        return sleepChartsDatas!
    }
    
    func queryTodayCurrentStepAndSleep() -> (Int, Int)? {
        
        var stepCount = 0
        var sleepTime = 0
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let beginString = dateFormatter.stringFromDate(NSDate())
        let beginTimeString = beginString + " 00:00:00"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let beginTime = dateFormatter.dateFromString(beginTimeString)
        let endTime = NSDate()
        
        let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > '\(beginTime)' AND time < '\(endTime)' ")
        
        for stepRealm in dataInfo {
            
            stepCount = stepCount + stepRealm.step
        }
        
        
        let dataInfo2 = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time > '\(beginTime)' AND time < '\(endTime)' ")
        
        for sleepRealm in dataInfo2 {
            
            sleepTime = sleepTime + sleepRealm.deepSleep + sleepRealm.lightSleep
        }
        

        
        
        return (3, 3)
    }
    
}