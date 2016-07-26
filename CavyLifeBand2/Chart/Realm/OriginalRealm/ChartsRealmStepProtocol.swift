//
//  ChartsRealmStepProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import Alamofire
import Realm

// MARK: Step Extension
extension ChartsRealmProtocol {
    
    /**
     添加计步数据
     - parameter chartsInfo: 用户的计步信息
     - returns: 成功：true 失败： false
     */
    func addWebStepRealm(chartsInfo: ChartStepDataRealm) -> Bool {
        
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
        let  serverData =  queryWebStepRealm(beginTime, endTime: endTime, timeBucket: timeBucket)
        
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
     
     */
    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(ChartStepDataRealm)>?, stepData: StepChartsData?) -> StepChartsData {
        
        
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
