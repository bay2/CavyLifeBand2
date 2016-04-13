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


struct SettingSwitchPhoneCellViewModel: SettingSwitchCellViewModelPresentable {
    
    var title: String { return L10n.SettingReminderPhoneCallTitle.string }
    
    var description: String {
        
        Log.warning("多少秒提醒还没做")
        
        return L10n.SettingReminderPhoneCallDescription.string
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
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(realmSetting.settingType) { (model: SettingRealmModel) -> SettingRealmModel in
            model.isOpenSetting = sender.on
            return model
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.ReminderPhoneSwitchChange.rawValue, object: nil, userInfo: ["index" : realmSetting.settingInfo])
        
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
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(realmSetting.settingType) { (model: SettingRealmModel) -> SettingRealmModel in
            model.isOpenSetting = sender.on
            return model
        }
        
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
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(realmSetting.settingType) { (model: SettingRealmModel) -> SettingRealmModel in
            model.isOpenSetting = sender.on
            return model
        }
        
    }
    
}
