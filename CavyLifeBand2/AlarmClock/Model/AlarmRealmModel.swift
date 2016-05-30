//
//  AlarmRealmModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class AlarmRealmModel: Object {
    
    dynamic var alarmDay: Int = 0
    dynamic var alarmTime = "08:00"
    dynamic var isOpen = true
    dynamic var userId = ""
    
    let owners = LinkingObjects(fromType: AlarmRealmListModel.self, property: "alarmRealmList")
    
    func alarmDayToString() -> String {
        
        //十进制数字转成二进制字符串
        let binarySum = String(alarmDay, radix: 2)
        
        let count = binarySum.characters.count
        
        var arr = [Int]()
        
        for i in 0..<count {
            
            let m = alarmDay & (1<<i)
            
            let n: Int = m>>i
            if n == 1 {
                arr.append(i+1)
            }
            
        }
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .SpellOutStyle
        
        var daysStr = ""
        
        if arr.count == 0 { //不设置周期，则显示“提醒一次”
            
            daysStr = L10n.AlarmClockNoCircleInfo.string
            
        } else if arr.count == 7 { //周期选了7天，则显示“每天”
            
            daysStr = L10n.AlarmClockCircleEverydayInfo.string
            
        } else if arr.elementsEqual([6, 7]) { //周期选了周六周日，则显示“双休日”
            
            daysStr = L10n.AlarmClockCircleWeekendInfo.string
            
        } else if arr.elementsEqual([1, 2, 3, 4, 5]) { //周期选了周一至周五，则显示“工作日”
            
            daysStr = L10n.AlarmClockCircleWeekdayInfo.string
            
        } else {
            
            for j in 0..<arr.count {
                
                var day: String = numberFormatter.stringFromNumber(NSNumber.init(integer: arr[j]))!
                
                if arr[j] == 7 {
                    day = "日"
                }
                
                if j == 0 {
                    daysStr += day
                } else {
                    daysStr += ",\(day)"
                }
            }
            
        }
        
        
        
        return daysStr
    }
    
}

class AlarmRealmListModel: Object {
    
    dynamic var userId = ""
    
    var alarmRealmList = List<AlarmRealmModel>()
    
    override class func primaryKey() -> String? {
        return "userId"
    }
    
    
}

protocol AlarmRealmListOperateDelegate {
    
    var realm: Realm { get }
    
    var userId: String { get }
    
    func queryAlarmList() -> AlarmRealmListModel
    
}

extension AlarmRealmListOperateDelegate {
    
    func queryAlarmList() -> AlarmRealmListModel {
        guard isExistAlarmList() else {
            return initAlarmList()!
        }
        
        let alarmlist = realm.objects(AlarmRealmListModel).filter("userId = '\(userId)'")
        
        return alarmlist.first!
    }
    
    func isExistAlarmList() -> Bool {
        let alarmlist = realm.objects(AlarmRealmListModel).filter("userId = '\(userId)'")
        
        if alarmlist.count <= 0 {
            return false
        }
        
        return true
    }
    
    
    func addAlarmRealm(alarm: AlarmRealmModel, alarmList: AlarmRealmListModel) -> Bool {
        
        //在数据库找相同时间相同周期的闹钟
        let oldAlarmList = alarmList.alarmRealmList.filter("userId = '\(userId)' && alarmDay = \(alarm.alarmDay) && alarmTime = '\(alarm.alarmTime)'")
        
        if oldAlarmList.count == 0 {
            //没有相同周期相同时间的闹钟，新加一个
            
            self.realm.beginWrite()
            alarmList.alarmRealmList.insert(alarm, atIndex: 0)
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
        } else {
            
            // 开关一样，直接不用添加
            for i in 0..<oldAlarmList.count {
                if oldAlarmList[i].isOpen == alarm.isOpen {
                    return true
                }
            }
            
            // 唤醒一样但开关不一样，直接改外部开关
            for j in 0..<oldAlarmList.count {
                if oldAlarmList[j].isOpen != alarm.isOpen {
                    self.realm.beginWrite()
                    oldAlarmList[j].isOpen = alarm.isOpen
                    
                    do {
                        try self.realm.commitWrite()
                    } catch let error {
                        Log.error("\(#function) error = \(error)")
                        return false
                    }
                    
                    return true
                }
            }
            
            self.realm.beginWrite()
            alarmList.alarmRealmList.insert(alarm, atIndex: 0)
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
            
            return true
            
        }

        return true
    }
    
    func updateAlarmRealm(newAlarm: AlarmRealmModel, oldAlarm: AlarmRealmModel) -> Bool {

        self.realm.beginWrite()
        
        oldAlarm.alarmDay = newAlarm.alarmDay
        oldAlarm.alarmTime = newAlarm.alarmTime
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func changeAlarmRealmOpenStatus(alarm: AlarmRealmModel) -> Bool {
        self.realm.beginWrite()

        alarm.isOpen = !alarm.isOpen
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func deleteAlarmRealm(index: Int, alarmList: AlarmRealmListModel) -> Bool {
        
        self.realm.beginWrite()
        
        alarmList.alarmRealmList.removeAtIndex(index)
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    func initAlarmList() -> AlarmRealmListModel? {
        
        let alarmList = AlarmRealmListModel()
        
        alarmList.userId = userId
        
        let alarm = AlarmRealmModel()
        
        alarm.userId = userId
        
        alarm.isOpen = false
        
        //周一到周五
        alarm.alarmDay = 31
                
        alarmList.alarmRealmList.append(alarm)
        
        if addAlarmList(alarmList) {
            return alarmList
        }
        
        return nil
        
    }
    
    func addAlarmList(alarmList: AlarmRealmListModel) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(alarmList, update: false)
            }
            
        } catch {
            
            Log.error("Add alarmList error [\(alarmList)]")
            return false
            
        }
        
        Log.info("Add alarmList success")
        return true
    }
    


}


