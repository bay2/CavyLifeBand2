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
    dynamic var time: NSDate = NSDate()
    dynamic var step = 0
    dynamic var kilometer: CGFloat = 0

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

    func queryHomeTimeBucket() -> [String]?
    
    func isExistStepChartsData() -> Bool
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData?
    
    func isExistSleepChartsData() -> Bool
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]?
    
}

// MARK: Other Extension
extension ChartsRealmProtocol {

    // 返回主页的时间段
    func queryHomeTimeBucket() -> [String]? {
        let userId = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId

        var resultArray: [String] = []
        
        let today = NSDate().toString(format: "yyyy.M.dd")
        
        let realmList = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")

        if realmList.count == 0 || realmList.first?.time == nil {
            
            return [today]
        }

        for perList in realmList {

            let timeString = perList.time.toString(format: "yyyy.M.dd")

            if resultArray.contains(timeString) == false {
                
                resultArray.append(timeString)
            }
            
        }
        // 如果没有今天的 就添加今天
        if resultArray.contains("\(today)") == false {
            resultArray.append(today)
        }
        return resultArray
    }
   
    
    
}

// MARK: Step Extension
extension ChartsRealmProtocol {
    
    /**
     查询是否有计步数据
     */
    func isExistStepChartsData() -> Bool {
        
        let lists = realm.objects(ChartStepDataRealm)
        
        if lists.count == 0 {
            
            return false
            
        }
        
        let personalList = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
        
        if personalList.count == 0 {
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
        
//        Log.info("Add charts info success")
        
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
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
                let hour = dateFormatter.stringFromDate(dataInfo[i - 1].time)
                
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
                let day = dateFormatter.stringFromDate(dataInfo[i - 1].time)
                
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
     查询是否有睡眠数据
     */
    func isExistSleepChartsData() -> Bool {
        
        
        let list = realm.objects(ChartSleepDataRealm)
        
        if list.count == 0 {
            return false
        }
        
        let personalList = realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'")
        
        if personalList.count == 0 {
            return false
        }
        
        return true
        
    }
    
    /**
     添加计步数据
     - parameter chartsInfo: 用户的睡眠信息
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

    
}




