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
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    var alarmListModel: AlarmRealmListModel {
        
        return queryAlarmList()
        
    }
    
    func deleteAlarm(index: Int) -> Bool {
        return deleteAlarmRealm(index, alarmList: alarmListModel)
    }
    
    func changeAlarmOpenStatus(index: Int) -> Bool {
                
        return changeAlarmRealmOpenStatus(alarmListModel.alarmRealmList[index])
        
    }
    
    func updateAlarm(newAlarm: AlarmRealmModel, index: Int) -> Bool {
        return updateAlarmRealm(newAlarm, oldAlarm: alarmListModel.alarmRealmList[index])
    }
    
    func getAlarmModelCopyByIndex(index: Int) -> AlarmRealmModel {
        let alarm = AlarmRealmModel()
        
        alarm.userId = alarmListModel.alarmRealmList[index].userId
        alarm.alarmDay = alarmListModel.alarmRealmList[index].alarmDay
        alarm.alarmTime = alarmListModel.alarmRealmList[index].alarmTime
        alarm.isOpen = alarmListModel.alarmRealmList[index].isOpen
        
        return alarm
    }
    
    func addAlarm(alarm: AlarmRealmModel) -> Bool {
        
        return addAlarmRealm(alarm, alarmList: alarmListModel)
        
    }

}
