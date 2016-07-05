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
    func syncDataFormBand(autoUpdate: Bool = true) {
        
        // 目前手环只支持两天，默认从昨天开始同步
        var syncDate = (NSDate().gregorian - 1.day).beginningOfDay.date
        
        // 如果数据库有数据，就从最后一天数据开始同步
        if let lastData = queryAllStepInfo().last {
            
            syncDate = lastData.time
            
            // 转换当前所在时区的时间   间隔10分钟 同步一次
            
            if autoUpdate == true {  //自动刷新 进入调用
                
                guard (NSDate().gregorian.beginningOfDay.date - syncDate).totalMinutes >= 10  else {
                    
                    // 发送通知让主页停止同步数据下拉消失
                    NSNotificationCenter.defaultCenter().postNotificationName(RefreshStatus.StopRefresh.rawValue, object: nil)
                    
                    return
                }
            }
            
        }
        
        
        LifeBandSyncData.shareInterface.syncDataFormBand(syncDate) {
            
            $0.success { titlsAndSteps in
                
                
                let steps = titlsAndSteps.map { return ($0.date, $0.steps) }
                let sleeps = titlsAndSteps.map { return ($0.date, $0.tilts) }
                
                self.saveTiltsToRealm(sleeps)
                
                self.saveStepsToRealm(steps)
                
                let uploadData = self.queryUploadBandData()
                
                guard uploadData.0.count > 0 else {
                    return
                }
                
                UploadBandData.shareApi.uploadBandData(uploadData.0) { [unowned self] data in
                    self.setChartBandDataSynced(uploadData.1, endDate: uploadData.2)
                }
                
//                // 上报睡眠信息
//                StepSleepReportedData.shareApi.sleepReportedDataToWebServer(sleeps).responseJSON {
//                    $0.result.success { value in
//                        self.saveTiltsToRealm(sleeps)
//                        }
//                        .failure { error in
//                            self.saveTiltsToRealm(sleeps)
//                    }
//                }
//                
//                // 上报计步信息
//                StepSleepReportedData.shareApi.stepsReportedDataToWebServer(steps).responseJSON {
//                    
//                    $0.result.success{ value in
//                        
//                        // 保存数据到数据库中
//                        // TODO: 这里需要设置同步标识
//                        self.saveStepsToRealm(steps)
//                        
//                        }
//                        .failure { error in
//                            self.saveStepsToRealm(steps)
//                    }
//                }
                
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
        
        for i in 0 ..< steps.count {
            
            if i == 0 && self.queryAllStepInfo(userId).count > 0 {
                
                let lastRealmTime = self.queryAllStepInfo(userId).last?.time
                
                if steps[0].0.compare(lastRealmTime!) == .OrderedSame {
                    
                    removeStepData(self.queryAllStepInfo(userId).last!)
                    
                }
                
            }
            
//            if steps[i].1 == 0 {
//                continue
//            }
            
            self.addStepData(ChartStepDataRealm(time: steps[i].0, step: steps[i].1))
            
        }
        
    }
    
    /**
     保存睡眠翻身次数到数据库
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter sleeps:
     */
    func saveTiltsToRealm(sleeps: [(NSDate, Int)]) {
        
        
        for i in 0 ..< sleeps.count {

            if i == 0 {
                
                
                let lastRealmTime = self.queryAllSleepInfo(userId).last?.time
                
                // 数据库无数据 直接添加
                if lastRealmTime != nil && sleeps[0].0.compare(lastRealmTime!) == .OrderedSame {
                    
                    // 比对最后一条数据的时间
                    
                    removeSleepData(self.queryAllSleepInfo(userId).last!)
                    
                }
                
            }
            
//            if sleeps[i].1 == 0 {
//                continue
//            }
            
            self.addSleepData(ChartSleepDataRealm(time: sleeps[i].0, tilts: sleeps[i].1))
            
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