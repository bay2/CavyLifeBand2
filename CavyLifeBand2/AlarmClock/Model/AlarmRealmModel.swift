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
    dynamic var alarmTime = "08:30"
    dynamic var isOpenAwake = true
    dynamic var isOpen = true
    dynamic var userId = ""
    
    var owners: [AlarmRealmListModel] {
        
        return linkingObjects(AlarmRealmListModel.self, forProperty: "alarmRealmList")
    }
    
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
        
        for j in 0..<arr.count {
            
            let day: String = numberFormatter.stringFromNumber(NSNumber.init(integer: arr[j]))!
            
            if j == 0 {
                daysStr += day
            } else {
                daysStr += ",\(day)"
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
        
        let oldAlarm = alarmList.alarmRealmList.filter("userId = '\(userId)' && alarmDay = \(alarm.alarmDay) && alarmTime = '\(alarm.alarmTime)'").first
        
        if oldAlarm == nil {
            
            self.realm.beginWrite()
            alarmList.alarmRealmList.insert(alarm, atIndex: 0)
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
            
        } else {
            if oldAlarm?.isOpenAwake == alarm.isOpenAwake && oldAlarm?.isOpen == alarm.isOpen {
                return true
            } else {
                self.realm.beginWrite()
                oldAlarm?.isOpenAwake = alarm.isOpenAwake
                oldAlarm?.isOpen = alarm.isOpen
                
                do {
                    try self.realm.commitWrite()
                } catch let error {
                    Log.error("\(#function) error = \(error)")
                    return false
                }
            }
            
        }
        
        return true
    }
    
    func updateAlarmRealm(newAlarm: AlarmRealmModel, oldAlarm: AlarmRealmModel) -> Bool {

        self.realm.beginWrite()
        
        oldAlarm.alarmDay = newAlarm.alarmDay
        oldAlarm.alarmTime = newAlarm.alarmTime
        oldAlarm.isOpenAwake = newAlarm.isOpenAwake
        
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


