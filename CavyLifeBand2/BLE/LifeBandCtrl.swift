//
//  LifeBandCtrl.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

class LifeBandCtrl {
    
    enum BandAlarmType {
        case Off        // 关闭
        case Immediate  // 响一次
        case Cycle      // 循环周期
    }
    
   static let shareInterface = LifeBandCtrl()
    
    /**
     设置手环震动
     
     - parameter count:     震动次数
     - parameter intensity: 震动强调 （10~99）
     - parameter onPeriod:  每次震动持续时间 ms  (support value<999ms)
     - parameter offPeriod: 每次停止震动时间 ms  (support value<2000ms)
     */
    func vibrate(count: Int, intensity: Int = 90, onPeriod: Int = 500, offPeriod: Int = 100) {
        
        LifeBandBle.shareInterface.sendMsgToBand("%VIB=\(count),\(intensity),\(onPeriod),\(offPeriod)")
        
    }
    
    /**
     获取手环电量
     
     - parameter relust: 电量返回回调
     */
    func getBandElectric(relust: (Float -> Void)) {
        
        LifeBandBle.shareInterface.sendMsgToBand("?BAT\n", cmd: 0xB1) { data in
            
            let dataArray = data.arrayOfBytes()
            
            relust(Float(dataArray[2]) * 0.01)
            
        }
        
        return
    }
    
    /**
     向手环设置时间信息
     
     - parameter date: 日期/时间
     */
    func setDateToBand(date: NSDate) {
        
        let dateString = date.toString(format: "yyyy,MM,dd")
        LifeBandBle.shareInterface.sendMsgToBand("%DATE=\(dateString)\n")
        
        guard let min = date.toString(format: "mm").toInt() else {
            return
        }
        
        guard let hour = date.toString(format: "HH").toInt() else {
            return
        }
        
        let sumMin = min + hour * 60
        
        let week = date.indexInArray()
        
        LifeBandBle.shareInterface.sendMsgToBand("%TIME=\(sumMin),\(week)\n")
        
    }
    

    /**
     向设置闹钟信息
     
     - parameter index: 闹钟索引 0~1
     - parameter time:  时间
     - parameter week:  星期日 至 星期一   01111111
     - parameter model: 模式 BandAlarmType
     
     - returns: 成功: true, 失败: false
     */
    func setAlarmToBand(index: Int, time: NSDate, week: UInt8 = 0, model: BandAlarmType) -> Bool {
        
        guard let min = time.toString(format: "mm").toInt() else {
            return false
        }
        
        guard let hour = time.toString(format: "HH").toInt() else {
            return false
        }
        
        LifeBandBle.shareInterface.sendMsgToBand("%ALARM\(index + 1)=\(model.hashValue),\(min + hour * 60),\(week)\n")
        
        return true
        
    }
    
}