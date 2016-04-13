//
//  SettingRealmModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class SettingRealmModel: Object {
    dynamic var settingType = "" // 1来电提醒 2短信提醒 3断线重连
    dynamic var isOpenSetting = true
    dynamic var settingInfo = ""
    
    override class func primaryKey() -> String? {
        return "settingType"
    }
    
    var owners: [SettingRealmListModel] {
        
        return linkingObjects(SettingRealmListModel.self, forProperty: "settingRealmList")
    }
    
}

class SettingRealmListModel: Object {
    dynamic var userId = ""
    var settingRealmList = List<SettingRealmModel>()
    
    override class func primaryKey() -> String? {
        return "userId"
    }
    
}

protocol SettingRealmListOperateDelegate {
    
    var realm: Realm { get }
    
    var userId: String { get }
    
    func querySettingList() -> SettingRealmListModel?
    func updateSettingList(settingListModel: SettingRealmListModel) -> Bool

}


protocol SettingRealmOperateDelegate {
    
    var realm: Realm { get }
    
    func querySetting(settingType: String) -> SettingRealmModel?
    func addSetting(settingModel: SettingRealmModel) -> Bool
    func updateSetting(settingType: String, updateCall: ((SettingRealmModel) -> SettingRealmModel)) -> Bool
    func isSettingExist(settingType: String) -> Bool
    
}

extension SettingRealmListOperateDelegate {

    func querySettingList() -> SettingRealmListModel? {
        
        guard isExistSettingList() else {
            
            return initSettingList()
            
        }
        
        let settingList = realm.objects(SettingRealmListModel).filter("userId = '\(userId)'")
        
        return settingList.first
    }
    
    func updateSettingList(settingListModel: SettingRealmListModel) -> Bool{
        do {
            
            try realm.write {
                realm.add(settingListModel, update: true)
            }
            
        } catch {
            
            Log.error("Add setting error [\(settingListModel)]")
            return false
            
        }
        
        Log.info("Add setting success")
        return true
    }
    
    func isExistSettingList() -> Bool {
    
        let list = realm.objects(SettingRealmListModel).filter("userId = '\(userId)'")
        
        if list.count <= 0 {
            return false
        }
        
        return true
        
    }
    
    func initSettingList() -> SettingRealmListModel? {
        
        let settingList = SettingRealmListModel()
        
        settingList.userId = userId
        
        let phoneSetting = initSettingModel(L10n.SettingReminderPhoneType.string)
        
        let messageSetting = initSettingModel(L10n.SettingReminderMessageType.string)
        
        let reconnectSetting = initSettingModel(L10n.SettingReminderReconnectType.string)
        
        settingList.settingRealmList.appendContentsOf([phoneSetting, messageSetting, reconnectSetting])
        
        if addSettingList(settingList) {
            return settingList
        }
        
        return nil
        
    }
    
    func initSettingModel(settingType: String) -> SettingRealmModel {
        
        let settingModel = SettingRealmModel()
        
        settingModel.isOpenSetting = true
        
        settingModel.settingType = settingType
        
        if settingType == L10n.SettingReminderPhoneType.string { //来电提醒
            
            settingModel.settingInfo = ""
            
        }
        
        return settingModel
    }
    
    func addSettingList(settingListModel: SettingRealmListModel) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(settingListModel, update: false)
            }
            
        } catch {
            
            Log.error("Add setting error [\(settingListModel)]")
            return false
            
        }
        
        Log.info("Add setting success")
        return true
        
    }

}


extension SettingRealmOperateDelegate {
    
    /**
     查询设置
     
     - parameter settingType: 设置的种类
     
     - returns: 设置model
     */
    func querySetting(settingType: String) -> SettingRealmModel? {
        
        let settingModels = realm.objects(SettingRealmModel).filter("settingType == '\(settingType)'")
        
        if 0 == settingModels.count {
            //数据库没有相关设置，就设添加一个默认设置
            let settingModel = initModel(settingType)
            
            if addSetting(settingModel) {
                return settingModel
            } else {
                return nil
            }
        }
        
        return settingModels[0]
    
    }
    
    /**
     添加设置
     
     - parameter setting: 设置model
     
     - returns: 添加是否成功
     */
    func addSetting(settingModel: SettingRealmModel) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(settingModel, update: false)
            }
            
        } catch {
            
            Log.error("Add setting error [\(settingModel)]")
            return false
            
        }
        
        Log.info("Add setting success")
        return true

    }
    
    /**
     更新设置
     
     - parameter settingType: 设置的主键索引
     - parameter updateCall:  更新回调
     
     - returns: 是否更新成功
     */
    func updateSetting(settingType: String, updateCall: ((SettingRealmModel) -> SettingRealmModel)) -> Bool {
        guard var settingModel = querySetting(settingType) else {
            Log.error("setting not exist [\(settingType)]")
            return false
        }
        
        do {
            
            realm .beginWrite()
            
            settingModel = updateCall(settingModel)
            
            realm.add(settingModel, update: true)
            
            try realm.commitWrite()
            
        } catch {
            
            Log.error("Update setting error [\(settingType)]")
            return false
            
        }
        
        Log.info("Update setting success [\(settingType)]")
        return true
    }
    
    /**
     设置是否存在
     
     - parameter settingType: 设置的主键索引
     
     - returns: 是否存在
     */
    func isSettingExist(settingType: String) -> Bool {
        
        if let _ = querySetting(settingType) {
            return true
        }
        
        return false
    }
    
    func initModel(settingType: String) -> SettingRealmModel {
        let settingModel = SettingRealmModel()
        
        settingModel.isOpenSetting = true
        
        settingModel.settingType = settingType
        
        if settingType == L10n.SettingReminderPhoneType.string { //来电提醒
            
            settingModel.settingInfo = ""
            
        }
        
        return settingModel
    }
    
}
