//
//  HomeViewControllerExtensinPreser.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Log
import JSONJoy
import SnapKit
import EZSwiftExtensions
import RealmSwift
import MJRefresh

extension HomeViewController {
    
    
    // MARK: 解析数据 保存数据库
    
    /**
     解析 计步睡眠数据 并保存Realm
     */
    func parseChartListData() {
        
        var startDate = ""
        var endDate = ""
        
        if isNeedUpdateStepData() {
            
            let personalList = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
            
            if personalList.count != 0 {
                
                startDate = personalList.last!.time.toString(format: "yyyy-MM-dd HH:mm:ss")
                endDate = NSDate().toString(format: "yyyy-MM-dd HH:mm:ss")
                
            }
            
            parseStepDate(startDate, endDate: endDate)
            
        }
        
        
        if isNeedUpdateSleepData() {
            
            let personalList = realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'")
            
            if personalList.count != 0 {
                
                startDate = personalList.last!.time.toString(format: "yyyy-MM-dd HH:mm:ss")
                endDate = NSDate().toString(format: "yyyy-MM-dd HH:mm:ss")
                
            }
            
            parseSleepDate(startDate, endDate: endDate)
            
        }
        
        
    }
    
    /**
     解析计步数据
     时间格式： yyyy-MM-dd
     有时间：更新数据
     没有时间：解析全部数据
     */
    func parseStepDate(startDate: String, endDate: String) {
        
        ChartsWebApi.shareApi.parseStepChartsData(startDate, endDate: endDate) { result in
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                let netResult = try ChartStepMsg(JSONDecoder(result.value!))
                
                
                for list in netResult.stepList {
                    // 保存到数据库
                    self.addStepListRealm(list)
                }
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
            }
            
        }
        
    }
    
    /**
     解析睡眠数据
     时间格式： yyyy-MM-dd
     有时间：更新数据
     没有时间：解析全部数据
     */
    func parseSleepDate(startDate: String, endDate: String) {
        
        ChartsWebApi.shareApi.parseSleepChartsData(startDate, endDate: endDate) { result in
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            do {
                Log.info(result.value!)
                let netResult = try ChartSleepMsg(JSONDecoder(result.value!))
                for list in netResult.sleepList {
                    
                    Log.info(list)
                    // 保存到数据库
                    self.addSleepListRealm(list)
                }
                
            } catch let error {
                Log.error("\(#function) result error: \(error)")
            }
            
        }
        
    }
    
    /**
     添加计步信息
     
     - author: sim cai
     - date: 16-05-27 10:05:27
     
     
     - parameter list: 计步信息JSON
     */
    func addStepListRealm(list: StepMsg) {
        
        guard let date = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd HH:mm:ss") else {
            return
        }
        
        self.addStepData(ChartStepDataRealm(userId: self.userId, time: date, step: list.stepCount))
        
    }
    
    /**
     添加睡眠信息
     
     - author: sim cai
     - date: 16-05-27 10:05:27
     
     
     - parameter list: 计步信息JSON
     */
    func addSleepListRealm(list: SleepMsg) {
        
        guard let time = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd HH:mm:ss") else {
            Log.error("Time from erro [\(list.dateTime)]")
            return
        }
        
        self.addSleepData(ChartSleepDataRealm(userId: self.userId, time: time, tilts: list.rollCount))
        
    }
    

}