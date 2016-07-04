//
//  LifeBandCtrl.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

enum LifeBandModelType: Int {

    case Time  = 2
    case Alarm = 4
    case LLA   = 8
    case Tilt  = 16
    case Step  = 32
}

enum LifeBandCtrlNotificationName: String {
    case BandButtonEvenClick1
    case BandButtonEvenClick4
}

/**
 手环控制类 实现手环功能接口
 
 */
class LifeBandCtrl {
    
    struct LifeBandInfo {
        var fwVersion: Int
        var model: Int
        var hwVersion: Int
    }
    
    enum BandAlarmType {
        case Off        // 关闭
        case Immediate  // 响一次
        case Cycle      // 循环周期
    }
    
    static let shareInterface = LifeBandCtrl()
    
    var buttonCount = 0
    
    
    
    /**
     设置手环震动
     
     - parameter count:     震动次数
     - parameter intensity: 震动强调 （10~99）
     - parameter onPeriod:  每次震动持续时间 ms  (support value<999ms)
     - parameter offPeriod: 每次停止震动时间 ms  (support value<2000ms)
     
     - - -
     - note: 手环硬件接口文档
     
     command:
     %VIB= [count][,intensity][,onPeriod][,offPeriod]n
     count:
     counter number ( support value<99)
     
     intensity:
     0= off vibrator
     10~99 = on vibrator, power level = 10~99% 0f full power
     
     on_period:
     on_period (support value<999ms)
     
     off_period:
     off_period(support value<2000ms)
     
     ex:
     %VIB=10,99,200,1800\n
     (Vibrator震10下后停止，震200ms，停1800ms，強度100% of full power)
     
     %VIB=1,99,500\n // strong 99%, vibrate on 500ms, then off
     
     %VIB=2,50,200,300\n // strong 50%, vibrate on 200ms, off 300ms, on 
     
     200ms, then off
     - - -
     
     */
    func vibrate(count: Int, intensity: Int = 90, onPeriod: Int = 500, offPeriod: Int = 100) {
        
        LifeBandBle.shareInterface.sendMsgToBand("%VIB=\(count),\(intensity),\(onPeriod),\(offPeriod)")
        
    }
    
    /**
     获取手环电量
     
     - parameter relust: 电量返回回调
     
     - - -
     - note: 手环硬件接口文档
     
     command:
     ?BAT\n
     
     responsd: (17 bytes)
     $ 0xB1 [contain] [voltage msb] [voltage lsb] [status] B[6]~B[16]
     
     
     contain : battery life time
     voltage : 256*[voltage msb] + [voltage lsb]
     status : 3 = good (life time > 60%)
     
     2 = normal (life time between10%~60%)
     1 = low (life time <10%) )
     - - -
     
     */
    func getBandElectric(relust: (Float -> Void)) {
        
        LifeBandBle.shareInterface.installCmd(0xB1) { data in
            
            let dataArray = data.arrayOfBytes()
            relust(Float(dataArray[2]) * 0.01)
            
        }
        .sendMsgToBand("?BAT\n")
        
        return
    }
    
    /**
     向手环设置时间信息
     
     - parameter date: 日期/时间
     
     - - -
     - note: 手环硬件接口文档
     
     commnad:
     %DATE=yyyy,mm,dd\n
     
     ex:
     %DATE=2015,12,15\n
     
     - - -
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
     
     - - -
     - note: 手环硬件接口文档
     
     %ALARM1=Mode,Time,Days in week\n
     and
     %ALARM2=Mode,Time,Days in week\n
     
     Mode: 0=off
     1=one shot
     2=period
     
     Days in week format:
     
     b7   b6    b5  b4  b3  b2   b1   b0
     x     sun  sat  fri  thu wed tue mon
     
     ex 1: 星期 一到五，20::00 闹钟
     
     0001_1111 = 0x1F(31)
     %ALARM1=2,1320,31\n
     
     ex 2: 每天早上6:00鬧鈴
     
     0111_1111 = 0x7F(127)
     %ALARM1=2,360,127\n
     
     时间到手环会震动10下，或者按键取消！
     - - -
     
     */
    func setAlarmToBand(index: Int, time: NSDate, week: UInt8 = 0, model: BandAlarmType) -> Bool {
        
        guard let min = time.toString(format: "mm").toInt() else {
            return false
        }
        
        guard let hour = time.toString(format: "HH").toInt() else {
            return false
        }
        
        if model == .Immediate {
            
            // 由于不设置周，手环FW闹钟设置无效，手环FW不想修改此问题，APP规避
            LifeBandBle.shareInterface.sendMsgToBand("%ALARM\(index + 1)=\(model.hashValue),\(min + hour * 60),127\n")
            
        } else {
            LifeBandBle.shareInterface.sendMsgToBand("%ALARM\(index + 1)=\(model.hashValue),\(min + hour * 60),\(week)\n")
        }
        
        return true
        
    }
    
    /**
     设置生活手环模式
     
     - - -
     - note: 手环硬件接口文档
     
     command:
     %CFG=func(1~9), enable(0~1)\n
     
     ex:
     
     %CFG=3,1\n //生活手环模式下，斷線後震動提示
     %CFG=4,1\n //Tilt function on
     %CFG=5,1\n //計步 function on
     - - -
     
     */
    func seLifeBandModel() {
        
        LifeBandBle.shareInterface.sendMsgToBand("%CFG=3,1")
        LifeBandBle.shareInterface.sendMsgToBand("%CFG=4,1")
        LifeBandBle.shareInterface.sendMsgToBand("%CFG=5,1")
        
    }
    
    /**
     获取手环信息
     
     - author: sim cai
     - date: 2016-05-30
     
     - parameter closure: 回调
     
     - - -
     - note: 手环硬件接口文档
     
     command:
     ?SYSTEM\n
     
     responsd(17 bytes): \
     $ 0xC1 B[2] B[3] B[4] B[5] ~ B[16]  \
      \
     B[2]: device state \
     B[3]: func enable status \
     bit 0         1          2         3         4        5         6         7 \
     X         time    alarm   lla       tilt      step    X        X \
     B[4]: hw version = 23 \
     B[5]: fw version = 	15 \
     B[6]: current magnetometer calibrated status, \
     if value = 3, mean calibrate OK, value = 0, not OK
     
     B[8~9]: factory mag_off_x value ( mag_off_x = (int)(B[8]<<8 | B[9]) ) \
     B[10~11]: factory mag_off_y value ( mag_off_y = (int)(B[10]<<8 | B[11]) ) \
     B[12~13]: factory mag_off_z value ( mag_off_z = (int)(B[12]<<8 | B[13]) ) \
     B[14~15]: factory mag_radius value ( radius = (uint)(B[14]<<8 | B[15]) ) \
     B[16]: checksum
     
     - - -
     */
    func getLifeBandInfo(closure: (LifeBandInfo -> Void)) {
        
        LifeBandBle.shareInterface.installCmd(0xc1) { data in
            
            let fwVersion = Int(data[5] ?? 0)
            let model = Int(data[3] ?? 0)
            let hwVersion = Int(data[4] ?? 0)
            
            let lifeBandInfo = LifeBandInfo(fwVersion: fwVersion, model: model, hwVersion: hwVersion)
            
            closure(lifeBandInfo)
            
        }
        .sendMsgToBand("?SYSTEM\n")
        
    }
    
    /**
     安装按钮事件
     
     - author: sim cai
     - date: 2016-05-30
     */
    func installButtonEven() {
        
        LifeBandBle.shareInterface.installCmd(0xD1) { data in
            
            if self.buttonCount == 0 {
                
                NSTimer.runThisAfterDelay(seconds: 4, after: {
                    
                    if self.buttonCount >= 4 {
                        LifeBandCtrl.shareInterface.vibrate(1)
                        NSNotificationCenter.defaultCenter().postNotificationName(LifeBandCtrlNotificationName.BandButtonEvenClick4.rawValue, object: nil)
                    }
                    
                    self.buttonCount = 0
                    
                })
                
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(LifeBandCtrlNotificationName.BandButtonEvenClick1.rawValue, object: nil)
            
            /**
             *  0,  button released
             1,  button pressed
             3,  long pressed
             */
            if data[2] == 1 {
                self.buttonCount += 1
                
                Log.info("Button count \(self.buttonCount)")
                
            } else if  data[2] == 3 {
                
                
                LifeBandBle.shareInterface.sendMsgToBand("%OPR=1,1\n command")
              
                Log.info("Buttion Long press")
                
            }
            
           
        }
        
    }
    
    

}