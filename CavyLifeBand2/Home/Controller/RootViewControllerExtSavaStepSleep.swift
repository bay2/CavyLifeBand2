//
//  RootViewControllerExtSavaStepSleep.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import CoreBluetooth
import Datez

extension RootViewController: ChartsRealmProtocol {
    
    /**
     同步手环计步睡眠信息
     
     - author: sim cai
     - date: 16-05-27 10:05:37
     */
    func syncDataFormBand() {
        
        // 目前手环只支持两天，默认从昨天开始同步
        var syncDate = (NSDate().gregorian - 1.day).beginningOfDay.date
        
        // 如果数据库有数据，就从最后一天数据开始同步
        if let lastData = queryAllStepInfo().last {
            syncDate = lastData.time
        }
        
        LifeBandSyncData.shareInterface.syncDataFormBand(syncDate) {
            
            $0.success { titlsAndSteps in
                
                let steps = titlsAndSteps.map { return ($0.date, $0.steps) }
                let sleeps = titlsAndSteps.map { return ($0.date, $0.tilts) }
                
                // 上报计步信息
                StepSleepReportedData.shareApi.stepsReportedDataToWebServer(steps).responseJSON {
                    
                    $0.result.success{ value in
                        
                        // 保存数据到数据库中
                        // TODO: 这里需要设置同步标识
                        self.saveStepsToRealm(steps)
                        
                    }
                    .failure { error in
                        self.saveStepsToRealm(steps)
                    }
                }
                
                // 上报睡眠信息
                StepSleepReportedData.shareApi.sleepReportedDataToWebServer(sleeps).responseJSON {
                    $0.result.success { value in
                        self.saveStepsToRealm(sleeps)
                    }
                    .failure { error in
                        self.saveStepsToRealm(sleeps)
                    }
                }
                
            }
            .failure { error in
                Log.error("\(error)")
            }
            
        }
        
    }
    
    /**
     保存计步数据到数据库
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter steps:
     */
    func saveStepsToRealm(steps: [(NSDate, Int)]) {
        
        _ = steps.map {(date: NSDate, steps: Int) -> (NSDate, Int)? in
            
            if steps == 0 {
                return nil
            }
            
            self.addStepData(ChartStepDataRealm(time: date, step: steps))
            return (date, steps)
        }
        
    }
    
    /**
     保存睡眠翻身次数到数据库
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter steps:
     */
    func saveTiltsToRealm(steps: [(date: NSDate, titls: Int)]) {
        
        _ = steps.map {(date: NSDate, tilts: Int) -> (NSDate, Int)? in
            
            if tilts == 0 {
                return nil
            }
            
            self.addSleepData(ChartSleepDataRealm(time: date, tilts: tilts))
            return (date, tilts)
        }
        
    }
    
    /**
     开始循环同步信息定时器
     
     - author: sim cai
     - date: 2016-05-31
     */
    func startSyncDataTime() {
        
        // 连接成功后会同步信息，所以这里在10分钟后再启动
        
        NSTimer.runThisAfterDelay(seconds: 60 * 10) {
            self.syncDataTime = NSTimer.runThisEvery(seconds: 60 * 10) { _ in
                self.syncDataFormBand()
            }
        }
        
    }
    
    /**
     蓝牙状态改变
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter bleState: 
     */
    func bleMangerState(bleState: CBCentralManagerState) {
        
        if bleState == .PoweredOn &&
            (LifeBandBle.shareInterface.getConnectState() == .Connected || LifeBandBle.shareInterface.getConnectState() == .Connecting) {
        }
        
    }
    
}