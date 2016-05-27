//
//  RootViewControllerExtSavaStepSleep.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
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
                
                // 保存数据到数据库中
                _ = titlsAndSteps.map {(date: NSDate, tilts: Int, steps: Int) -> (NSDate, Int, Int) in
                    self.addSleepData(ChartSleepDataRealm(time: date, tilts: tilts))
                    self.addStepData(ChartStepDataRealm(time: date, step: steps))
                    return (date, tilts, steps)
                }
                
            }
            .failure { error in
                Log.error("\(error)")
            }
            
        }
        
    }
    
}