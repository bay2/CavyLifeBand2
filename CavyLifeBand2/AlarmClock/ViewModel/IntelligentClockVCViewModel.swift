//
//  IntelligentClockVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

struct IntelligentClockVCViewModel: AlarmRealmListOperateDelegate {
    
    var realm: Realm
    
    var userId: String {
        return "12"
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    var alarmListModel: AlarmRealmListModel {
        
        return queryAlarmList()
        
    }
    
    func deleteAlarm(alarmModel: AlarmRealmModel) -> Bool {
        return deleteAlarm(alarmModel)
    }
    
    func changeAlarmOpenStatus(index: Int, status: Bool) -> Bool {
        
        alarmListModel.alarmRealmList[index].isOpen = status
        
        return updateAlarmRealmList(alarmListModel)
        
    }
    
    
    
    func getAlarmModelCopyByIndex(index: Int) -> AlarmRealmModel {
        let alarm = AlarmRealmModel()
        
        alarm.userId = alarmListModel.alarmRealmList[index].userId
        alarm.alarmDay = alarmListModel.alarmRealmList[index].alarmDay
        alarm.alarmTime = alarmListModel.alarmRealmList[index].alarmTime
        alarm.isOpenAwake = alarmListModel.alarmRealmList[index].isOpenAwake
        alarm.isOpen = alarmListModel.alarmRealmList[index].isOpen
        
        return alarm
    }
    
    func addAlarm(alarm: AlarmRealmModel) -> Bool {
        let oldAlarm = alarmListModel.alarmRealmList.filter("userId = '\(userId)' && alarmDay = '\(alarm.alarmDay)' && alarmTime = '\(alarm.alarmTime)'").first
        
        if oldAlarm == nil {
            alarmListModel.alarmRealmList.append(alarm)
        } else {
            if oldAlarm?.isOpenAwake == alarm.isOpenAwake && oldAlarm?.isOpen == alarm.isOpen {
                return true
            } else {
                oldAlarm?.isOpenAwake = alarm.isOpenAwake
                oldAlarm?.isOpen = alarm.isOpen
            }
            
        }
        
        return updateAlarmRealmList(alarmListModel)
        
    }

}
