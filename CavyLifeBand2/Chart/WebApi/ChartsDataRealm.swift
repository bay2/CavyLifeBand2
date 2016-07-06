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

/// 长时间没有数据，12 = 2小时， 12 * 10分钟
let noSleepTime = 12


// MARK: Step
class ChartStepDataRealm: Object {
    
    dynamic var userId             = ""
    dynamic var time: NSDate       = NSDate()
    dynamic var step               = 0
    dynamic var kilometer: CGFloat = 0
    dynamic var syncState          = ChartBandDataSyncState.UnSync.rawValue
    
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
    dynamic var syncState    = ChartBandDataSyncState.UnSync.rawValue
    
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, time: NSDate, tilts: Int) {
        
        self.init()
        
        self.userId = userId
        self.time   = time
        self.tilts  = tilts
        
    }
    
    
}

enum ChartBandDataSyncState: Int {
    case Synced = 0
    case UnSync = 1
}

// MARK: 计步睡眠数据库操作协议

protocol ChartsRealmProtocol: ChartStepRealmProtocol, SleepWebRealmOperate {


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
    func querySleepInfoDay(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double)
    func removeSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    
}

// MARK: Other Extension
extension ChartsRealmProtocol {
    
    func queryAllStepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartStepDataRealm)> {

        return realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'").sorted("time", ascending: true)

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
     是否需要请求数据
     
     - returns: true 需要请求 false 不需要更新
     */
    func isNeedUpdateStepData() -> Bool {
        
        let list = realm.objects(ChartStepDataRealm)
        
        if list.count == 0 {
            return true
        }
        
        let personalList = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
        
        if personalList.count == 0 {
            return true
        }
        
        let totalMinutes = (NSDate().gregorian.beginningOfDay.date - personalList.last!.time).totalMinutes
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
        
        //处理当天数据
       let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
//        Log.info("dataInfo======\(dataInfo.last)==========")
        switch timeBucket {
            
        case .Day:
            return returnHourChartsArray(dataInfo, stepData: serverData)
            
        case .Week, .Month:
            return returnDayChartsArray(beginTime, endTime: endTime, dataInfo: dataInfo, stepData: serverData)
            
        }
        
    }
    
    /**
     按小时分组 一天24小时
     */
    func returnHourChartsArray(dataInfo: Results<(ChartStepDataRealm)> ,stepData: StepChartsData) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        // 初始化0~23 24 小时
        for i in 0...23 {
            
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        
        for data in dataInfo {
            
            let index = data.time.gregorian.components.hour
            
            stepChartsData.totalStep += data.step
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.finishTime += 10
            stepChartsData.datas[index].step += data.step
            
        }
        
        
        stepChartsData.totalStep += stepData.totalStep
        stepChartsData.totalKilometer += stepData.totalKilometer
        stepChartsData.finishTime += stepData.finishTime
        
        for indext in  0..<stepChartsData.datas.count {
         
            stepChartsData.datas[indext].step += stepData.datas[indext].step
            
        }
        
        
        
        
        
        return stepChartsData
        
    }
    
    /**
     按天分组 一周七天 一个月30天
     */    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(ChartStepDataRealm)>, stepData: StepChartsData) -> StepChartsData {
        
        var stepChartsData = StepChartsData(datas: [], totalStep: 0, totalKilometer: 0, finishTime: 0, averageStep: 0)
        
        let maxNum = (endTime - beginTime).totalDays + 1
        
        for i in 1...maxNum {
            stepChartsData.datas.append(PerStepChartsData(time: "\(i)", step: 0))
        }
        
        for data in dataInfo {
            
            let index = (data.time - beginTime).components.day
            
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.totalStep += data.step
            stepChartsData.finishTime += 10
            stepChartsData.datas[index].step += data.step
            
        }
        
        
        stepChartsData.totalStep += stepData.totalStep
        stepChartsData.totalKilometer += stepData.totalKilometer
        stepChartsData.finishTime += stepData.finishTime
        
        for indext in  0..<stepChartsData.datas.count {
            
            stepChartsData.datas[indext].step += stepData.datas[indext].step
            
        }
        
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

// MARK: Sleep Extension
extension ChartsRealmProtocol {
    
    /**
     是否需要请求数据 
     
     - returns: true 需要请求 false 不需要请求
     */
    func isNeedUpdateSleepData() -> Bool {
        
        let list = realm.objects(ChartSleepDataRealm)
        if list.count == 0 {
            return true
        }
        
        let personalList = realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'")
        if personalList.count == 0 {
            return true
        }
        
        let totalMinutes = (NSDate() - personalList.last!.time).totalMinutes
        Log.info(totalMinutes)
        
        if totalMinutes > 10 {
            return true
        }
        
        return false
        
    }
    
    /**
     查询所有睡眠数据
     
     - author: sim cai
     - date: 2016-06-01
     
     - parameter userId: 用户id
     
     - returns:
     */
    func queryAllSleepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartSleepDataRealm)> {
        return realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'").sorted("time", ascending: true)
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
            
            Log.error("Add sleep charts info error [\(chartsInfo)]")
            return false
            
        }
        
        Log.info("Add Sleep charts info success")
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
     */
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData] {
        
        var sleepDatas: [PerSleepChartsData] = []
        
        var index = 0
        
        sleepDatas = querySleepInfoDays(beginTime, endTime: endTime).map {
            let newDate = (beginTime.gregorian + index.day).date
            index += 1
            return PerSleepChartsData(time: newDate, deepSleep: Int($0.1), lightSleep: Int($0.2))
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
    private func validSleep(beginTime: NSDate, endTime: NSDate) -> Int {
        
        var minustsCount   = 0
        var longSleepCount = 0 // 长时间睡眠计数
        var testCount = 0
        
        Log.info("validSleep Begin")
        
        let sleepDatas = transformSleepData(beginTime, endTime: endTime)
        let stepDatas = transformStepData(beginTime, endTime: endTime)
        
        if stepDatas.isEmpty || sleepDatas.isEmpty {
            return 0
        }
        
        for timeIndex in 0..<sleepDatas.count {
            
            // 前后计算范围
            let range = 2
            
            // 如果timeIndex为前range个数组，则开始所以从0开始
            let beginIndex = timeIndex <= range ? 0 : timeIndex - range
            
            // 如果timeIndex为最后两个元素，则以最末尾作为结束
            let endIndex   = timeIndex > sleepDatas.count - (range + 1) ? sleepDatas.count - 1 : timeIndex + range
            
            var tiltsTotal = sleepDatas[beginIndex...endIndex].reduce(0, combine: +)
            
            // 条件1：之前20分钟tilt数量+当前20分钟tilt +之后20分钟tilt数量<40
            if tiltsTotal >= 40 {
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
            
            //            Log.info("\(timeIndex)----\((beginTime.gregorian + (timeIndex * 10).minute).date.toString(format: "MM-dd HH:mm"))----\(stepDatas[timeIndex])----\(sleepDatas[timeIndex])")
            
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
    private func sumDeepSleep(beginTime: NSDate, endTime: NSDate) -> Int {
        
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
    
    /**
     将数据库中的睡眠数据转成10分钟存储的数组
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: 成功: 返回10分钟为一个单位的数据; 指定时间有没有效数据,返回空数组
     */
    private func transformSleepData(beginTime: NSDate, endTime: NSDate) -> [Int] {
        
        let realmSleepData = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        if realmSleepData.isEmpty {
            return []
        }
        
        let dataSize = ((endTime - beginTime).totalMinutes) / 10 + 1
        
        var reslutArray = Array<Int>(count: dataSize, repeatedValue: 0)
        
        for data in realmSleepData {
            
            let index = (data.time - beginTime).totalMinutes / 10
            reslutArray[index] = data.tilts
        }
        
        return reslutArray
        
    }
    
    /**
     将数据库中的计步数据转成10分钟存储的数组
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter beginTime: 开始时间
     - parameter endTime:   结束时间
     
     - returns: 成功: 返回10分钟为一个单位的数据; 指定时间有没有效数据,返回空数组
     */
    private func transformStepData(beginTime: NSDate, endTime: NSDate) -> [Int] {
        
        let realmStepData = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
        if realmStepData.count == 0 {
            return []
        }
        
        let dataSize = ((endTime - beginTime).totalMinutes) / 10  + 1
        
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
    private func querySleepInfo(beginTime: NSDate, endTime: NSDate) -> (Double, Double, Double) {
        
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
        let newEndTime = endTime
        
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
//    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)] {
//        
//        var reslutData: [(Double, Double, Double)] = []
//        
//        let dayTotal = (endTime - beginTime).totalDays
//        
//        Log.info("querySleepInfoDays Begin \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
//        
//        for i in 0...dayTotal {
//            
//            // 从前天的晚上6点开始算起
//            let newBeginTime = ((beginTime.gregorian + i.day).beginningOfDay - 6.hour).date
//            let newEndTime = (newBeginTime.gregorian + 24.day).date
//            
//            reslutData.append(querySleepInfo(newBeginTime, endTime: newEndTime))
//            
//        }
//        
//        Log.info("querySleepInfoDays end \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
//        
//        return reslutData
//        
//    }
    
    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)] {
        
        var reslutData: [(Double, Double, Double)] = []
        
        let dayTotal = (endTime - beginTime).totalDays
        
        /// 取出数据库中这段时间里的数据
        let sleepWebRealms = querySleepWebRealm(startDate: beginTime, endDate: endTime)
        
        var realmIndex = 0
        
        Log.info("querySleepInfoDays Begin \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
        
        /// 数据库中没有数据
        if sleepWebRealms?.count == 0 {
            
            for _ in 0...dayTotal {
                
                reslutData.append((0.0, 0.0, 0.0))
                
            }
        
        } else {
        
            /// 转化数据库中的数据，并做断档数据补0
            for i in 0...dayTotal {
                
                if realmIndex < sleepWebRealms?.count {
                    
                    if ((beginTime.gregorian + i.day).beginningOfDay.date - sleepWebRealms![realmIndex].date).totalDays == 0 {
                    
                        reslutData.append(sleepWebRealms![realmIndex].transformToTuple())
                        
                        realmIndex += 1
                        
                    } else {
                        reslutData.append((0.0, 0.0, 0.0))
                    }
                    
                } else {
                
                    reslutData.append((0.0, 0.0, 0.0))
                    
                }
                
            }
            
            Log.info("querySleepInfoDays end \(beginTime.toString(format: "yyyy-MM-dd")) - \(endTime.toString(format: "yyyy-MM-dd")))")
        
        }
        
        let nowDate = NSDate()
        
        // 当天数据的特殊处理
        if (nowDate - beginTime).totalDays >= 0 && (nowDate - endTime).totalDays <= 0 {
            // 有网直接返回
            guard NetworkReachabilityManager(host: "www.baidu.com")?.isReachable == false else {
                return reslutData
            }
            
            // 没网显示手环数据库的数据
            
            // 从前天的晚上6点开始算起
            let newBeginTime = (nowDate.gregorian.beginningOfDay - 6.hour).date
            let newEndTime = (newBeginTime.gregorian + 1.day).date
            
            reslutData[(nowDate - beginTime).totalDays] = querySleepInfo(newBeginTime, endTime: newEndTime)
            
            return reslutData
            
        } else {
            return reslutData
        }
        
    }
    
    /**
     删除某条睡眠数据
     
     - parameter chartsInfo: 要删除的睡眠数据
     
     - returns: 是否成功
     */
    func removeSleepData(chartsInfo: ChartSleepDataRealm) -> Bool {
        
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
     获取需要上报的数据
     
     - returns: ([NSDictionary], NSDate, NSDate) 上报数据 ，起始时间，结束时间
     */
    func queryUploadBandData() -> ([NSDictionary], NSDate, NSDate) {
        
        let realmSleepData = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND syncState == %d", ChartBandDataSyncState.UnSync.rawValue).sorted("time", ascending: true)
        
        let realmStepData = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND syncState == %d", ChartBandDataSyncState.UnSync.rawValue).sorted("time", ascending: true)
        
        if realmSleepData.isEmpty {
            return ([], NSDate(), NSDate())
        }
        
        let startTime = realmSleepData[0].time.gregorian.beginningOfDay.date
        
        let format = NSDateFormatter()
        
        format.dateFormat = "yyyy-MM-dd"
        
        var reslutArray: [NSDictionary] = []
        
        
        for i in 0..<realmSleepData.count {
            
            let tilt = realmSleepData[i].tilts
            let step = realmStepData[i].step
            var dateStr: String = format.stringFromDate(realmStepData[i].time)
            
            let totalMinutes = (realmStepData[i].time - startTime).totalMinutes / 10
            
            let time: Int = (totalMinutes % 144) == 0 ? 144 : (totalMinutes % 144)
            
            if time == 144 {
               dateStr = format.stringFromDate((realmStepData[i].time.gregorian - 1.day).date)
            }
            
            let dataStruct = [ NetRequsetKey.Date.rawValue: dateStr,
                               NetRequsetKey.Time.rawValue: time,
                               NetRequsetKey.Tilts.rawValue: tilt,
                               NetRequsetKey.Steps.rawValue: step]
            
            reslutArray.append(dataStruct)
            
            Log.info("index\(i) ---- 分钟数\(time) ---- 日期\(dateStr) ---- 原日期\(realmStepData[i].time)")
        
        }
        
        return (reslutArray, realmStepData[0].time, realmStepData.last!.time)

    }
    
    /**
     将手环数据库的数据置为已同步状态
     
     - parameter startDate: 开始时间
     - parameter endDate:   结束时间
     */
    func setChartBandDataSynced(startDate: NSDate, endDate: NSDate) {
        setSleepChartBandDataSynced(startDate, endDate: endDate)
        setStepChartBandDataSynced(startDate, endDate: endDate)
    }
    
    /**
     将手环睡眠数据库的数据置为已同步状态
     
     - parameter startDate: 开始时间
     - parameter endDate:   结束时间
     */
    func setSleepChartBandDataSynced(startDate: NSDate, endDate: NSDate) {
        
        let realmSleepData = realm.objects(ChartSleepDataRealm).filter("userId == '\(userId)' AND time >= %@ AND time <= %@", startDate, endDate)
        
        guard realmSleepData.count > 0 else {
            Log.info("\(#function) 该记录不存在")
            return
        }
        
        self.realm.beginWrite()
        
        
        realmSleepData.forEach { (data) in
            data.syncState = ChartBandDataSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
        }
        
    }
    
    /**
     将手环计步数据库的数据置为已同步状态
     
     - parameter startDate: 开始时间
     - parameter endDate:   结束时间
     */
    func setStepChartBandDataSynced(startDate: NSDate, endDate: NSDate) {
        let realmStepData = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND time >= %@ AND time <= %@", startDate, endDate)
        
        guard realmStepData.count > 0 else {
            Log.info("\(#function) 该记录不存在")
            return
        }
        
        self.realm.beginWrite()
        
        
        realmStepData.forEach { (data) in
            data.syncState = ChartBandDataSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
        }

    }

}






