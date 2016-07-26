
//
//  ChartsRealmSleepProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import Alamofire
import Realm

// MARK: Sleep Extension
extension ChartsRealmProtocol {

    
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
     添加睡眠数据
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
            
            // 新接口 直接存的分钟
            return PerSleepChartsData(time: newDate, deepSleep: Int($0.1), lightSleep: Int($0.2))
            
        }
        
        return sleepDatas
        
    }
    
    /**
     查询有效睡眠信息
     
     睡眠状态的判定
     条件1：之前20分钟tilt总量+当前10分钟tilt总量 +之后20分钟tilt总量<40
     条件2：当前10分钟tilt<15
     条件3：当前10分钟step<30
     条件4：昨天18：00点到今天18：00
     满足 条件1 and 条件2 and 条件3 and 条件4，则当前10分钟为睡眠状态
     总睡眠时长计为S
     
     深睡与浅睡状态的判定
     在S中，tilt and step=0的总时长计为d
     d*0.9=深睡时长
     S-d*0.9=浅睡时长
     
     无睡眠状态的判定
     条件：tilt and step=0的时间连续大于2小时，则将连续的tilt and step=0的时间判定为无睡眠状态
     
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter sleepInfo: 睡眠信息
     
     - returns: 睡眠时长 10分钟为单位， 1 = 10 分钟
     （$0  睡眠时长     $1 深睡时长）
     */
    private func validSleep(beginTime: NSDate, endTime: NSDate) -> (Int, Int) {
        
        var minustsCount   = 0 // 睡眠计数
        var longSleepCount = 0 // 深睡时长
        var continuousZeroCoun = 0 // 记录连续的0
        //        var zeroCoun = 0   // 0 的个数
        
        let sleepDatas = transformSleepData(beginTime, endTime: endTime)
        let stepDatas = transformStepData(beginTime, endTime: endTime)
        
        
        if stepDatas.isEmpty || sleepDatas.isEmpty {
            return (0, 0)
        }
        
        for timeIndex in 0..<sleepDatas.count {
            
            
            // 前后计算范围
            let range = 2
            
            // 如果timeIndex为前range个数组，则开始所以从0开始
            let beginIndex = timeIndex <= range ? 0 : timeIndex - range
            
            // 如果timeIndex为最后两个元素，则以最末尾作为结束
            let endIndex   = timeIndex > sleepDatas.count - (range + 1) ? sleepDatas.count - 1 : timeIndex + range
            
            let tiltsTotal = sleepDatas[beginIndex...endIndex].reduce(0, combine: +)
            
            let stepItem = stepDatas[timeIndex]
            let tiltsItem = sleepDatas[timeIndex]
            
            //1. 记录伪睡眠数据
            
            // 条件1.1：之前20分钟tilt数量+当前10分钟tilt +之后20分钟tilt数量<40
            // 条件1.2：当前10分钟tilt<15
            // 条件1.3：当前10分钟step<30
            
            if tiltsTotal < 40 &&  tiltsItem < 15 && stepItem < 30 {
                
                minustsCount += 1
                
                // 1.4. 记录当中的0
                
                if stepItem == 0 && tiltsItem == 0 {
                    
                    longSleepCount += 1
                    continuousZeroCoun += 1
                    
                    
                }else
                {
                    // 2.
                    // 如果longSleepCount 大于 noSleepTime  往后能找到非0 值 这可以去掉该部分无效数据
                    // 如果 在 往后找不到非0 的数值 这判断这个循环结束的时候 有多少0
                    
                    // 4.无效睡眠状态 去掉超过连续的>=12 的0
                    if continuousZeroCoun >= noSleepTime
                        
                    {
                        
                        minustsCount -= continuousZeroCoun
                        longSleepCount -= continuousZeroCoun
                        continuousZeroCoun = 0
                        
                    }
                }
                
            }
            
        }
        
        //3 遍历结束之后判断同时为0 的个数 如果大于 noSleepTime 则全部截去
        
        if continuousZeroCoun >= noSleepTime
            
        {
            
            minustsCount -= continuousZeroCoun
            longSleepCount -= continuousZeroCoun
            continuousZeroCoun = 0
            
        }
        
        
        guard  minustsCount >= 0 else {
            
            return  (0, 0)
        }
        
        
        Log.info("总共睡眠\(minustsCount)=====深睡个数\(longSleepCount)")
        
        return (minustsCount, longSleepCount)
    }
    
    
    /**
     将数据库中的睡眠数据转成10分钟存储的数组  计算时间是数据库中的有效数据 不去补0
     
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
        
        
        
        //        let dataSize = ((endTime - beginTime).totalMinutes) / 10
        
        var reslutArray = Array<Int>(count: realmSleepData.count, repeatedValue: 0)
        
        var indext = 0
        for data in realmSleepData {
            
            indext += 1
            
            //            let index = (data.time - beginTime).totalMinutes / 10 - 1  // 防止数组越界
            reslutArray[indext - 1] = data.tilts
        }
        
        return reslutArray
        
    }
    
    /**
     将数据库中的计步数据转成10分钟存储的数组   计算时间是数据库中的有效数据 不去补0
     
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
        
        //        let dataSize = ((endTime - beginTime).totalMinutes) / 10
        
        var indext = 0
        var reslutArray = Array<Int>(count: realmStepData.count, repeatedValue: 0)
        
        for data in realmStepData {
            indext += 1
            //            let index = (data.time - beginTime).totalMinutes / 10 - 1
            reslutArray[indext - 1] = data.step
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
        
        let sleepInfo = validSleep(beginTime, endTime: endTime)
        
        let deepSleep = Double(sleepInfo.1) * 0.9
        
        let lightSleep = Double(sleepInfo.0) - deepSleep
        
        Log.info("sleepTime =\(sleepInfo.0), deepSleep = \(deepSleep), lightSleep = \(lightSleep)")
        
        return (Double(sleepInfo.0) * 10, Double(deepSleep) * 10, Double(lightSleep) * 10)
    }
    
    /**
     查询今天的睡眠数据
     
     - returns: (总的睡眠时间, 深睡, 浅睡)
     */
    func queryTodaySleepInfo() -> (Double, Double, Double) {
        
        
        let nowTime = NSDate().gregorian.date
        let newBeginTime = (NSDate().gregorian.beginningOfDay - 6.hour).date
        var  endDate = (newBeginTime.gregorian + 1.day).date
        
        //当前的时间
        if nowTime.compare(endDate) == .OrderedAscending {
            
            endDate = nowTime
            
        }
        
        return querySleepInfo(newBeginTime, endTime: endDate)
        
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
        if (nowDate - beginTime).totalMinutes >= 0 && (nowDate - endTime).totalMinutes <= 0 {
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
            
            let dataStruct = [ NetRequestKey.Date.rawValue: dateStr,
                               NetRequestKey.Time.rawValue: time,
                               NetRequestKey.Tilts.rawValue: tilt,
                               NetRequestKey.Steps.rawValue: step]
            
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
        NSNotificationCenter.defaultCenter().postNotificationName(RefreshStyle.StopRefresh.rawValue, object: nil)
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

