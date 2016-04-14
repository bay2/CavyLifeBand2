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
    
    dynamic var alarmDay = 0
    dynamic var alarmTime = "8:30"
    dynamic var isOpenAwake = true
    dynamic var isOpen = true
    dynamic var userId = ""
    
    var owners: [AlarmRealmListModel] {
        
        return linkingObjects(AlarmRealmListModel.self, forProperty: "alarmRealmList")
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
    
    func updateAlarmRealmList(alarmListModel: AlarmRealmListModel) -> Bool
    
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
    
//    func addAlarmRealm(alarm: AlarmRealmModel) -> Bool {
//        
//        let alarmList
//        
//        a.settingRealmList.appendContentsOf([phoneSetting, messageSetting, reconnectSetting])
//    }
    
    func updateAlarmRealmList(alarmListModel: AlarmRealmListModel) -> Bool {

        do {
            
            try realm.write {
//                let oldList = queryAlarmList()
//                realm.delete(oldList.alarmRealmList)
                realm.add(alarmListModel, update: true)
                
            }
            
        } catch let error {
            Log.error("update alarm list error \(error)")
            return false
        }
        
        return true
    }
    
    func deleteAlarm(alarmModel: AlarmRealmModel) -> Bool {
        
        guard let alarmList = realm.objects(AlarmRealmListModel).filter("userId = '\(userId)'").first else {
            return false
        }
        
        guard let alarm = alarmList.alarmRealmList.filter("userId = '\(userId)' && alarmDay = '\(alarmModel.alarmDay)' && alarmTime == '\(alarmModel.alarmTime)'").first else {
            return false
        }
        
        self.realm.beginWrite()
        
        self.realm.delete(alarm)
        
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

protocol AlarmRealmOperateDelegate {
    
    var realm: Realm { get }
    
//    func queryAlarm(userId: String) -> AlarmRealmModel?
//    func addAlarm(alarmModel: AlarmRealmModel) -> Bool
//    func updateAlarm(alarmModel: AlarmRealmModel) -> Bool
//    func isAlarmExist(userId: String) -> Bool
//    func deleteAlarm(userId: String) -> Bool
}


