//
//  StepsDataReaml.swift
//  CavyLifeBand2
//
//  Created by Hanks on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import JSONJoy


class NChartStepDataRealm: Object {
    
    dynamic var userId             = ""
    dynamic var date: NSDate       = NSDate()
    dynamic var totalTime: Int     = 0
    dynamic var totalStep: Int     = 0
    dynamic var kilometer: CGFloat = 0
    
    var stepList = List<StepListItem>()
    
   
    
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, date: NSDate, totalTime: Int, totalStep: Int, stepList: List<StepListItem>) {
        
        self.init()
        self.userId    = userId
        self.date      = date
        self.totalStep = totalStep
        self.kilometer = CGFloat(self.totalStep) * 0.0006
        self.totalTime = totalTime
        self.stepList  = stepList
    }
    
}

class StepListItem: Object {
    
    dynamic var step = 0
    
    convenience required init(step: Int) {
        
        self.init()
        self.step = step
    }
    
}



// MARK: 服务器计步数据库操作协议
protocol ChartStepRealmProtocol: ChartsRealmProtocol {
    
    
    func isNeedUpdateNStepData() -> Bool
    func queryAllStepInfo(userId: String) -> Results<(NChartStepDataRealm)>
    func delectStepData(chartStepInfo: NChartStepDataRealm) -> Bool
    func addStepData(chartStepInfo: NChartStepDataRealm) -> Bool
    func queryNStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepShowItem
    
}




extension ChartStepRealmProtocol {
 
    /**
     
     删除一条计步数据
     
     - parameter chartStepInfo: <#chartStepInfo description#>
     
     - returns: <#return value description#>
     */
    
    
    func delectStepData(chartStepInfo: NChartStepDataRealm) -> Bool {
        
        self.realm.beginWrite()
        
        self.realm.delete(chartStepInfo)
        
        do {
            
            try self.realm.commitWrite()
            
        } catch let error {
            
            Log.error("\(#function) error = \(error)")
            
            return false
        }
        Log.info("delete chartStep info success")
        
        return true

    }
    
    
    
    /**
     是否需要从服务器拉取计步数据
     
     - returns: <#return value description#>
     */
    
    func isNeedUpdateNStepData() -> Bool {
        
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
     返回从服务器存储拉取的所有单条数据
     */
    func queryAllStepInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(NChartStepDataRealm)> {

        return realm.objects(NChartStepDataRealm).filter("userId = '\(userId)'")
        
    }
    

    
    /**
     添加计步数据
     - parameter chartsInfo: 用户的计步信息
     - returns: 成功：true 失败： false
     */
    func addStepData(chartsInfo: NChartStepDataRealm) -> Bool {
        
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
    func queryNStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepShowItem {
        
        let dataInfo = realm.objects(NChartStepDataRealm).filter("userId == '\(userId)' AND time > %@ AND time < %@", beginTime, endTime)
        
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
    func returnHourChartsArray(dataInfo: Results<(NChartStepDataRealm)>) -> StepShowItem {
        
        var stepChartsData = StepShowItem(totalStep: 0, totalKilometer: 0, spendTime: 0, averageStep: 0, datas:[])
        
        for data in dataInfo {
            
            stepChartsData.totalStep = data.totalStep
            stepChartsData.totalKilometer = data.kilometer
            stepChartsData.spendTime = data.totalTime
            stepChartsData.averageStep = data.totalStep
            
            for step in data.stepList {
                
                stepChartsData.datas.append(step.step)
            }
            
        
        }
        
        return stepChartsData
        
    }
    
    
    
    /**
     按天分组 一周七天 一个月30天
     */    func returnDayChartsArray(beginTime: NSDate, endTime: NSDate, dataInfo: Results<(NChartStepDataRealm)>) -> StepShowItem {
        
        var stepChartsData = StepShowItem(totalStep: 0, totalKilometer: 0, spendTime: 0, averageStep: 0, datas: [])
     
        var i = 0
        var allTotalStep = 0
        
        for data in dataInfo {
            
            stepChartsData.totalKilometer += data.kilometer
            stepChartsData.totalStep += data.totalStep
            allTotalStep += data.totalTime
            
            // 取平局数时候去除0步的情况
            
            if data.totalStep != 0 {
        
                i += 1
            }
            
            var totalDay = 0
            
            
            for step in data.stepList {
              
                totalDay += step.step;
                
            }
            
              stepChartsData.datas.append(totalDay)
           
        }
        
        stepChartsData.averageStep = Int(allTotalStep/i)
    
        return stepChartsData
        
    }
    
}








/**
 *  Step 整个数据 包括总步数 总公里数 花费时长 平均时长
 */

struct StepShowItem {
    
    var totalStep: Int          = 0
    var totalKilometer: CGFloat = 0.0
    var spendTime: Int
    var averageStep: Int        = 0
    var datas: [Int]
  
}





