//
//  LifeBandSyncData.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Datez
import EZSwiftExtensions

enum LifeBandSyncDataError: ErrorType {
    case PacketNoError
    case DataError
}

enum LifeBandSyncReslut<Value, Error: ErrorType>  {
    
    case Success(Value)
    case Failure(Error)
    
    func success(@noescape closure: Value -> Void) -> LifeBandSyncReslut {
        
        switch self {
        case .Success(let value):
            closure(value)
        default:
            break
        }
        
        return self
    }
    
    func failure(@noescape closure: Error -> Void) -> LifeBandSyncReslut {
        
        switch self {
        case .Failure(let error):
            closure(error)
        default:
            break
        }
        
        return self
    }
    
}

class LifeBandSyncData {
    
    static let shareInterface = LifeBandSyncData()
    
    typealias TitlsAndSteps = (date: NSDate, tilts: Int, steps: Int)
    
    var tiltsAndStepsInfo: [TitlsAndSteps] = []
    
    private var packetNo: UInt8 = 0
    private var syncRecNum      = 0
    private var syncState       = SyncStateType.NoSync
    
    enum SyncStateType {
        case NoSync      // 未同步
        case Sync        // 同步中
    }
    
    // 同步数据day定义
    enum SyncDateCtrl: Int, CustomStringConvertible {
        
        init(beginDate: NSDate) {
 
            let dayCount = NSDate().formartDate(NSDate()).daysInBetweenDate(NSDate().formartDate(beginDate)).toInt
            
            self = dayCount == 0 ? SyncDateCtrl.Today : SyncDateCtrl.Yesterday
            
        }

        init(dateCmd: UInt8) {
            
            switch dateCmd {
            case 2:
                self = .Today
            case 1:
                self = .Yesterday
            case 0:
                self = .BeforeYesterday
            default:
                self = .Today
            }
            
        }
        
        func toDate() -> NSDate {
            
            switch self {
            case .Today:
                return NSDate().gregorian.beginningOfDay.date
            case .Yesterday:
                return (NSDate().gregorian - 1.day).beginningOfDay.date
            case .BeforeYesterday:
                return (NSDate().gregorian - 2.day).beginningOfDay.date
            }
            
        }
        
        var description: String {
            
            switch self {
            case .Today:
                return "Today"
            case .Yesterday:
                return "Yesterday"
            case .BeforeYesterday:
                return "BeforeYesterday"
            }
            
        }
        
        case BeforeYesterday // 前天
        case Yesterday       // 昨天
        case Today           // 今天
    }
    
    
 
    
    
    /**
     从手环同步计步睡眠时间
     
     - - -
     - note: 手环硬件接口文档
     
     command: \
     %SYNC=Day(0~2),time(0~143)\n \
     在生活手环模式下，下%SYNC=Day,time, 會開始回傳從前天(Day=0) or 昨天(Day=1)或今天(Day=2)，何時開始到現在的計步和睡眠基礎數據紀錄, time 是以10min為一單位!
     
     ex: \
     請求昨天10:01開始到現在的数据，應為 \
     %SYNC＝1,60\n
     
     
     responsd format: (20 bytes)
     
     
     B[0]         B[1]         B[2]          B[3] \
     $            0xDA         date(0~2)     packet no(1~72) \
     B[4]         B[5]         B[6]          B[7] \
     No           Tilts        (Steps>>8)    Steps \
     B[8]         B[9]         B[10]         B[11] \
     No           Tilts        (Steps>>8)    Steps \
     B[12]        B[13]        B[14]         B[15] \
     No           Tilts        (Steps>>8)    Steps \
     B[16]        B[17]        B[18]         B[19] \
     No           Tilts        (Steps>>8)    Steps
     
     
     ex:  App will get notify event after %SYNC\n
     
     $      0xDA      0    1 \
     1      0         10   0 \
     2      0         10   0 \
     3      0         10   0 \
     4      0         10   0
     
     最後多加一結束packet提示APP，sync 結束 \
     $ 0xDA 0xFF 0xFF
     
     
     可組成如下數據(示意)
     
     - - -
     
     */
    func syncDataFormBand(beginDate: NSDate, reslut: LifeBandSyncReslut<[TitlsAndSteps], LifeBandSyncDataError> -> Void) {
        
        let dayCmd   = SyncDateCtrl(beginDate: beginDate)
        
        let newBeginDate = transformNewDate(beginDate)
        
        let hour     = newBeginDate.toString(format: "HH").toInt() ?? 0
        let min      = newBeginDate.toString(format: "mm").toInt() ?? 0
        let timeCmd  = (hour * 60 + min) / 10
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
            
            // 等待同步完成，再继续同步
            while self.syncState == .Sync {
                NSThread.sleepForTimeInterval(1)
            }
            
            var i: Int = 0
            LifeBandBle.shareInterface.installCmd(0xDA) { [unowned self] data in
                
                Log.info("同步\(i += 1)")
                
                Log.info("syncDataFormBand ---- \(data)")
                
                self.saveTiltsAndStepsData(newBeginDate, data: data, reslut: reslut)
                
                }
                .sendMsgToBand("%SYNC=\(dayCmd.rawValue),\(timeCmd)\n")
            
            Log.info("Band sync begin ----  \(newBeginDate.toString(format: "yyyy-MM-dd HH:mm:ss"))")
            
        }
        
    }
    
    /**
     转换新的时间
     
     - parameter beginDate: 开始时间
     
     - returns: 返回新的时间
     */
    func transformNewDate(beginDate: NSDate) -> NSDate {
        
        let dayCount = (NSDate() - beginDate).totalDays
        
        let yesterday = (NSDate().gregorian - 1.day).beginningOfDay.date
        
        switch dayCount {
        case 0, 1:
            return beginDate
        default:
            return yesterday
        }
        
    }
    
    
    /**
     保存同步数据
     
     - parameter dayCount: 同步日期数
     - parameter data:     数据
     
     - returns: 数据是否同步完成 完成: true, 未完成: false
     */
    private func saveTiltsAndStepsData(beginDate: NSDate, data: NSData, reslut: LifeBandSyncReslut<[TitlsAndSteps], LifeBandSyncDataError> -> Void) -> Bool {
        
        if data[2...3]?.uint16 == 0xFFFF {
            
            /**
             因为手环返回的包数据大小为固定的20bytes
             所以最后一个包会出现以下数据 <24da0201 40140009 00000000 00000000 00000000>
             00000000 00000000 00000000其实是无效数据
             所以拿完整个数据后，要在最后四个数据判断无效数据
             即把最后一个数据和前面的三个数据比较，记录重复值，最后做删除
             */
            
            /*-------判断无效数据------*/
            
            var repeatCount = 0
            
            for i in tiltsAndStepsInfo.count-4...tiltsAndStepsInfo.count-2 {
                if tiltsAndStepsInfo.last?.date == tiltsAndStepsInfo[i].date {
                    repeatCount += 1
                }
            }
            
            if repeatCount != 0 {
                
                for _ in 0...repeatCount {
                    
                    tiltsAndStepsInfo.removeLast()
                    
                }
                
            } else {
                
                let last = tiltsAndStepsInfo.last
                let lastSecond = tiltsAndStepsInfo[tiltsAndStepsInfo.count - 2]
                
                let diffMinutes = (last!.date - lastSecond.date).totalMinutes
                
                if diffMinutes != 10 {
                    tiltsAndStepsInfo.removeLast()
                }
                
            }
            
            /*-------判断无效数据------*/
            
            reslut(.Success(tiltsAndStepsInfo))
            packetNo = 0
            tiltsAndStepsInfo.removeAll()
            
            // app校验到数据有问题，手环还是会不断的发送数据，所以只要搜到0xFFFF才认为同步完成。
            // 如果同步失败并且在1分钟内没有收到0xFFFF，会重新设置为没有同步状态，用户可以继续同步。
            syncState = .NoSync
            
            Log.info("Band sync end")
            
            return true
            
        }
        
        if data.length <= 4 {
            reslut(.Failure(.DataError))
            return false
        }
        
        //TODO: 等FW解决包序号问题，再把这里放开
        //        guard (packetNo + 1) == data[3] else {
        //            reslut(.Failure(.PacketNoError))
        //            return false
        //        }
        
        syncState = .Sync
        
        Log.info("\(SyncDateCtrl(dateCmd: data[2])) - Packet No \(data[3])")
        
        for i in 4..<data.length where i % 4 == 0  {
            
            guard let dataTiltsAndStep = dataTransformTitlsAndSteps(SyncDateCtrl(dateCmd: data[2]), data: data[i...i+3] ?? NSData(bytes: [0, 0])) else {
                continue
            }
            
            // 0数据也保存
//            if dataTiltsAndStep.steps == 0 && dataTiltsAndStep.tilts == 0 {
//                continue
//            }
            
            tiltsAndStepsInfo.append(dataTiltsAndStep)
            
        }
    
        packetNo = (packetNo == 72 ? 1 : packetNo + 1)
        
        return false
        
    }
    
    /**
     将NSdata 转为 TitlsAndSteps
     
     - parameter dateCmd: 日期命令标识
     - parameter data:    数据
     
     - returns: 时间，睡眠信息，步数
     */
    private func dataTransformTitlsAndSteps(dateCmd: SyncDateCtrl, data: NSData) -> TitlsAndSteps? {
        
        let no    = Int(data[0])
        let tilts = Int(data[1])
        let step  = Int((data[2...3] ?? NSData(bytes: [0, 0])).uint16.bigEndian) // 这里需要做大小端转换
        
        let newDate = (dateCmd.toDate().gregorian + (no * 10).minute).date
        
        Log.info("\(dateCmd) - \(no) - \(data) - \(newDate.toString(format: "yyyy-MM-dd HH:mm:ss"), tilts, step)")
        
        return (newDate, tilts, step)
        
    }
    
}