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
        
        guard let settingModel = realmSetting else {
            return true
        }
        
        return settingModel.isOpenSetting
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .RedDescription
    }
    
    var realm: Realm
    
    var settingType: String {
        return L10n.SettingReminderPhoneType.string
    }
    
    var realmSetting: SettingRealmModel? {
        return querySetting(settingType)
    }
    
    
    init(realm: Realm) {
        
        self.realm = realm
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(settingType) { (model: SettingRealmModel) -> SettingRealmModel in
            model.isOpenSetting = sender.on
            return model
        }
        
    }
    
}

struct SettingSwitchMessageCellViewModel: SettingSwitchCellViewModelPresentable {
    
    var title: String { return L10n.SettingReminderMessageTitle.string }
    
    var description: String {
        
        return L10n.SettingReminderMessageDescription.string
        
    }
    
    var isOpen: Bool {
        
        guard let settingModel = realmSetting else {
            return true
        }
        
        return settingModel.isOpenSetting
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .GrayDescription
    }
    
    var realm: Realm
    
    var settingType: String {
        return L10n.SettingReminderMessageType.string
    }
    
    var realmSetting: SettingRealmModel? {
        return querySetting(settingType)
    }
    
    
    init(realm: Realm) {
        
        self.realm = realm
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(settingType) { (model: SettingRealmModel) -> SettingRealmModel in
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
        
        guard let settingModel = realmSetting else {
            return true
        }
        
        return settingModel.isOpenSetting
    }
    
    var cellStyle: CavyLifeBand2SwitchStyle {
        return .NoneDescription
    }
    
    var realm: Realm
    
    var settingType: String {
        return L10n.SettingReminderMessageType.string
    }
    
    var realmSetting: SettingRealmModel? {
        return querySetting(settingType)
    }
    
    
    init(realm: Realm) {
        
        self.realm = realm
        
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateSetting(settingType) { (model: SettingRealmModel) -> SettingRealmModel in
            model.isOpenSetting = sender.on
            return model
        }
        
    }
    
}
