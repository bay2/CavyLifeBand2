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

let noSleepTime = 12


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
    func queryAllSleepInfo(userId: String) -> Results<(ChartSleepDataRealm)>
//    func querySleepInfo(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double)
    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)]
    func querySleepInfoDay(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double)
    
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
     */    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(ChartStepDataRealm)>) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0)
        
        let maxNum = (endTime - beginTime).totalDays + 1
        
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
     查询所有睡眠数据
     
     - author: sim cai
     - date: 2016-06-01
     
     - parameter userId: 用户id
     
     - returns:
     */
    func queryAllSleepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartSleepDataRealm)> {
        return realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'")
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
    
    /**
     查询有效睡眠信息
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter sleepInfo: 睡眠信息
     
     - returns: 睡眠时长 10分钟为单位， 1 = 10 分钟
     */
    func validSleep(beginTime: NSDate, endTime: NSDate) -> Int {
        
        var minustsCount   = 0
        var longSleepCount = 0 // 长时间睡眠计数
        var testCount = 0
        
        Log.info("validSleep Begin")
        
        let sleepDatas = transformSleepData(beginTime, endTime: endTime)
        let stepDatas = transformStepData(beginTime, endTime: endTime)
        
        if stepDatas.isEmpty && stepDatas.isEmpty {
            return 0
        }
        
        for timeIndex in 0..<sleepDatas.count {
            
            let beginIndex = timeIndex == 0 ? 0 : timeIndex - 1
            let endIndex   = timeIndex == sleepDatas.endIndex - 1 ? timeIndex : timeIndex + 1
            
            var tiltsTotal = sleepDatas[beginIndex...endIndex].reduce(0, combine: +)
            
            // 条件1：之前10分钟tilt数量+当前10分钟tilt +之后10分钟tilt数量<30
            if tiltsTotal >= 30 {
                longSleepCount = 0
                continue
            }
            
            tiltsTotal = sleepDatas[timeIndex]
            
            // 条件2：当前10分钟tilt<15
            if tiltsTotal >= 15 {
                longSleepCount = 0
                continue
            }
            
            // 条件3：当前10分钟step<30
            let stepTotal = stepDatas[timeIndex]
            if stepTotal >= 30 {
                longSleepCount = 0
                continue
            }
            
            // 退出无睡眠状态,减掉无效计数
            if stepTotal != 0 || tiltsTotal != 0 {
                
                if longSleepCount >= noSleepTime {
                    minustsCount -= longSleepCount
                }
                
                longSleepCount = 0
            }

            minustsCount += 1
            testCount += 1
            
            // 无数据计数
            if stepTotal == 0 && tiltsTotal == 0 {
                longSleepCount += 1
            }
            
            
        }
        
        if longSleepCount >= noSleepTime {
            minustsCount -= longSleepCount
        }
        
        Log.info("validSleep end")
        
        Log.info("validSleep testCount = \(testCount)")
        
        return minustsCount
    }
    
    /**
     统计深度睡眠数据
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: 深度睡眠值  10分钟为单位， 1 = 10 分钟
     */
    func sumDeepSleep(beginTime: NSDate, endTime: NSDate) -> Int {
        
        var minustsCount   = 0
        var longSleepCount = 0 // 长时间睡眠计数
        
        Log.info("sumDeepSleep Begin")
        
        let sleepDatas = transformSleepData(beginTime, endTime: endTime)
        let stepDatas = transformStepData(beginTime, endTime: endTime)
        
        if stepDatas.isEmpty && stepDatas.isEmpty {
            return 0
        }
        
        for timeIndex in 0..<sleepDatas.count {
            
            if sleepDatas[timeIndex] != 0 || stepDatas[timeIndex] != 0 {
                
                // 退出无睡眠状态,减掉无效计数
                if longSleepCount >= noSleepTime {
                    minustsCount -= longSleepCount
                }
                
                longSleepCount = 0
                continue
            }
            
            minustsCount += 1
            longSleepCount += 1
            
            
        }
        
        if longSleepCount >= noSleepTime {
            minustsCount -= longSleepCount
        }
        
        Log.info("sumDeepSleep end")
        
        return minustsCount
        
    }
    
    func transformSleepData(beginTime: NSDate, endTime: NSDate) -> [Int] {
        
        let realmSleepData = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        if realmSleepData.isEmpty {
            return []
        }
        
        let dataSize = ((endTime - beginTime).totalMinutes + 1) / 10
        
        var reslutArray = Array<Int>(count: dataSize, repeatedValue: 0)
        
        for data in realmSleepData {
            
            let index = (data.time - beginTime).totalMinutes / 10
            reslutArray[index] = data.tilts
        }
        
        return reslutArray
        
    }
    
    func transformStepData(beginTime: NSDate, endTime: NSDate) -> [Int] {
        
        let realmStepData = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        if realmStepData.count == 0 {
            return []
        }
        
        let dataSize = ((endTime - beginTime).totalMinutes + 1) / 10
        
        var reslutArray = Array<Int>(count: dataSize, repeatedValue: 0)
        
        for data in realmStepData {
            
            let index = (data.time - beginTime).totalMinutes / 10
            reslutArray[index] = data.step
        }
        
        return reslutArray
        
    }
    

    
    /**
     查询睡眠信息
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: (总的睡眠时间, 深睡, 浅睡)
     */
    func querySleepInfo(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double) {
        
        let sleepTime = validSleep(beginTime, endTime: endTime)
        
        let deepSleep = sumDeepSleep(beginTime, endTime: endTime)
        
        let lightSleep = Double(sleepTime) - Double(deepSleep) * 0.9
        
        Log.info("sleepTime =\(sleepTime), deepSleep = \(deepSleep), lightSleep = \(lightSleep)")
        
        return (Double(sleepTime), Double(deepSleep), lightSleep)
    }
    
    /**
     查询一天的睡眠信息
     
     - author: sim cai
     - date: 2016-06-01
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: (总的睡眠时间, 深睡, 浅睡)
     */
    func querySleepInfoDay(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double) {
        
        let newBeginTime = (beginTime.gregorian.beginningOfDay - 6.hour).date
        let newEndTime = (newBeginTime.gregorian + 24.day).date
        
        return querySleepInfo(newBeginTime, endTime: newEndTime)
    }
    
    /**
     查询一段时间段的睡眠信息
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: [(总的睡眠时间, 深睡, 浅睡)] 数据按每天返回
     */
    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)] {
        
        var reslutData: [(Double, Double, Double)] = []
        
        let dayTotal = (endTime - beginTime).totalDays
        
        Log.info("querySleepInfoDays Begin \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
        
        for i in 0...dayTotal {
            
            // 从前天的晚上6点开始算起
            let newBeginTime = ((beginTime.gregorian + i.day).beginningOfDay - 6.hour).date
            let newEndTime = (newBeginTime.gregorian + 24.day).date
            
            reslutData.append(querySleepInfo(newBeginTime, endTime: newEndTime))
            
        }
        
        Log.info("querySleepInfoDays end \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
        
        return reslutData
        
    }
    
}




