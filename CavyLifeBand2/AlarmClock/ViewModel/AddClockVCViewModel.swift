//
//  AddClockVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

struct AddClockVCViewModel {
    var userId: String {
        
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        
    }
    
    var alarmModel: AlarmRealmModel
    
    var alarmDayDic: [Int: Bool]?
    
    lazy var dateFormmater: NSDateFormatter = {
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    init(alarmModel: AlarmRealmModel) {
                
        self.alarmModel = alarmModel
        
        self.alarmModel.userId = userId
        
        self.alarmDayDic = alarmDayToAlarmDayDic(alarmModel.alarmDay)
        
    }
    
    mutating func changeAlarmDay(alarmDay: Int, selected: Bool) -> Void {
        
        alarmDayDic![alarmDay] = selected
        alarmDayDicToAlarmDay(alarmDayDic!)
        
    }
    
    mutating func stringToDate(str: String) -> NSDate {
        return dateFormmater.dateFromString(str)!
    }
    
    mutating func dateToString(date: NSDate) -> String {
        return dateFormmater.stringFromDate(date)
    }
    
    mutating func getAlarmTimeDate() -> NSDate {
        return stringToDate(alarmModel.alarmTime)
    }
    
    mutating func setAlarmTimeStr(date: NSDate) -> Void {
        alarmModel.alarmTime = dateToString(date)
    }
    
    
    func alarmDayDicToAlarmDay(dic: [Int: Bool]) -> Void {
        var sum = 0
        
        for (key, value) in dic {
            if value == true {
                sum += 1<<key
            }
        }
        
        alarmModel.alarmDay = sum
        Log.info("\(sum)")
    }
    
    /**
     将数据库中的代表闹钟重复天数的十进制数字转成字典格式
     
     - parameter alarmDay: 十进制数字
     
     - returns: 字典
     */
    func alarmDayToAlarmDayDic(alarmDay: Int) -> [Int: Bool] {
        
        //十进制数字转成二进制字符串
        let binarySum = String(alarmDay, radix: 2)
        
        let count = binarySum.characters.count
        
        var dic = [Int: Bool]()
        
        for i in 0..<count {
            
            let m = alarmDay & (1<<i)
            
            let n: Int = m>>i
            if n == 1 {
                dic[i] = true
            } else {
                dic[i] = false
            }
            
        }
        
        for j in 0...6 {
            if dic[j] == nil {
                dic[j] = false
            }
        }
        
        return dic
    }
    
    
    
    
}