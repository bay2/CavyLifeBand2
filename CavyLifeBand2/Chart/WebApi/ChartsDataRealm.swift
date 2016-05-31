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


// MARK: Step
class ChartStepDataRealm: Object {
    
    dynamic var userId             = ""
    dynamic var time: NSDate       = NSDate()
    dynamic var step               = 0
    dynamic var kilometer: CGFloat = 0
    
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, time: NSDate, step: Int) {
        
        self.init()
        
        self.userId    = userId
        self.time      = time
        self.step      = step
        self.kilometer = CGFloat(self.step) * 0.0006// 相当于一部等于0.6米 公里数 = 步数 * 0.6 / 1000
    }
    

}

// MARK: Sleep
class ChartSleepDataRealm: Object {
    
    dynamic var userId       = ""
    dynamic var time: NSDate = NSDate()
    dynamic var tilts        = 0
    
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, time: NSDate, tilts: Int) {
        
        self.init()
        
        self.userId = userId
        self.time   = time
        self.tilts  = tilts
        
    }
    
    
}

// MARK: 计步睡眠数据库操作协议
protocol ChartsRealmProtocol {
    
    var realm: Realm { get }
    var userId: String { get }

    // MARK: Other
    func queryTimeBucketFromFirstDay() -> [String]?
   
    // MARK: 计步
    func isExistStepChartsData() -> Bool
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData
    func queryAllStepInfo(userId: String) -> Results<(ChartStepDataRealm)>
    
    // MARK: 睡眠
    func isExistSleepChartsData() -> Bool
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]
    
}

// MARK: Other Extension
extension ChartsRealmProtocol {
    
    func queryAllStepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartStepDataRealm)> {
        return realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
    }


    // 返回 第一天开始的时间段
    func queryTimeBucketFromFirstDay() -> [String]? {
        
        let userId = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId

        let realmList = queryAllStepInfo(userId)

        if realmList.count == 0 || realmList.first?.time == nil {
            
            return [NSDate().toString(format: "yyy.M.d")]
        }

        let firstDate = realmList.first!.time
        
        return firstDate.untilTodayArrayWithFormatter("yyy.M.d")
                
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
        
        Log.info("Add charts info success")
        
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
     */
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData {
        
        let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        switch timeBucket {
            
        case .Day:
            return returnHourChartsArray(dataInfo)
            
        case .Week, .Month:
            return returnDayChartsArray(beginTime, endTime: endTime, dataInfo: dataInfo)
            
        }
     
    }
    
    /**
     按小时分组 一天24小时
     */
    func returnHourChartsArray(dataInfo: Results<(ChartStepDataRealm)>) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0)
        
        // 初始化0~23 24 小时
        for i in 0...23 {
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", kilometer: 0))
        }
        
        
        for data in dataInfo {
            
            let index = data.time.gregorian.components.hour
            
            stepChartsData.totalStep += data.step
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.finishTime += 10
            stepChartsData.datas[index].kilometer += data.kilometer
            
        }
        
        return stepChartsData
        
    }
    
    /**
     按天分组 一周七天 一个月30天
     */
    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(ChartStepDataRealm)>) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0)
        
        let maxNum = (endTime - beginTime).totalDays
        
        for i in 1...maxNum {
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", kilometer: 0))
        }
        
        for data in dataInfo {
            
            let index = (data.time - beginTime).components.day
            
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.totalStep += data.step
            stepChartsData.finishTime += 10
            stepChartsData.datas[index].kilometer += data.kilometer
            
            
        }
        
        return stepChartsData
        
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
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData] {
        
        let dataInfo = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)

        let sleepDatas = dataInfo.map { chartSleepDataRealm -> PerSleepChartsData in
            
            return PerSleepChartsData(time: chartSleepDataRealm.time.toString(format: "d"), tilts: chartSleepDataRealm.tilts, totalTime: 0)
        }
        
        return sleepDatas
        
    }
    
}




