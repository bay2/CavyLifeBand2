//
//  SettingSwitchCellViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

typealias SettingSwitchCellViewModelPresentable = protocol<SettingCellDataSource, SettingRealmOperateDelegate>

struct PhoneReminderTimeModel {
    
    var timeArr = {
        return ["0",
                "5",
                "10",
                "15",
                "20"]
    }()
    
}

struct SettingSwitchPhoneCellViewModel: SettingSwitchCellViewModelPresentable {
    
    var title: String { return L10n.SettingReminderPhoneCallTitle.string }
    
    var description: String {
        
        return timeModel.timeArr[realmSetting.settingInfo] + L10n.SettingReminderPhoneCallDescription.string
    
    }
    
    var timeModel: PhoneReminderTimeModel {
        
        return PhoneReminderTimeModel()
    
    }
    
    var isOpen: Bool {
        
        return realmSetting.isOpenSetting
        
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .RedDescription
    }
    
    var realm: Realm
    
    var realmSetting: SettingRealmModel
    
    init(realm: Realm, realmSetting: SettingRealmModel) {
        
        self.realm = realm
        
        self.realmSetting = realmSetting
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(status: Bool) {
        updateSettingOpen(realmSetting.settingType, userId: realmSetting.userId, settingOpen: status)
    }
    
    
    //改变时间的选择
    func changeDescription(index: Int) -> Void {
        updateSettingInfo(realmSetting.settingType, userId: realmSetting.userId, settingInfo: index)
    }
    
}

struct SettingSwitchMessageCellViewModel: SettingSwitchCellViewModelPresentable {
    
    var title: String { return L10n.SettingReminderMessageTitle.string }
    
    var description: String {
        
        return L10n.SettingReminderMessageDescription.string
        
    }
    
    var isOpen: Bool {
        
        return realmSetting.isOpenSetting
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .GrayDescription
    }
    
    var realm: Realm
    
    var realmSetting: SettingRealmModel
    
    
    init(realm: Realm, realmSetting: SettingRealmModel) {
        
        self.realm = realm
        
        self.realmSetting = realmSetting
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(status: Bool) {
        
        updateSettingOpen(realmSetting.settingType, userId: realmSetting.userId, settingOpen: status)
        
    }
    
}

struct SettingSwitchReconnectCellViewModel: SettingSwitchCellViewModelPresentable {
    
    var title: String {
        return L10n.SettingReminderReconnectTitle.string
    }
    
    var description: String { return "" }
    
    var isOpen: Bool {

        return realmSetting.isOpenSetting
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .NoneDescription
    }
    
    var realm: Realm
    
    var realmSetting: SettingRealmModel
    
    init(realm: Realm, realmSetting: SettingRealmModel) {
        
        self.realm = realm
        
        self.realmSetting = realmSetting
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(status: Bool) {
        
        updateSettingOpen(realmSetting.settingType, userId: realmSetting.userId, settingOpen: status)
        
    }
    
}
