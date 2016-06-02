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
    dynamic var userId = ""
    dynamic var isOpenSetting = true
    dynamic var settingInfo = 0
    
    let owners = LinkingObjects(fromType: SettingRealmListModel.self, property: "settingRealmList")
    
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
    func queryAllSettingList() -> Results<(SettingRealmListModel)> 
    func updateSettingList(settingListModel: SettingRealmListModel) -> Bool

}


protocol SettingRealmOperateDelegate {
    
    var realm: Realm { get }
    
    func querySetting(settingType: String, userId: String) -> SettingRealmModel?
    func addSetting(settingModel: SettingRealmModel) -> Bool
    func updateSettingOpen(settingType: String, userId: String, settingOpen: Bool) -> Bool
    func updateSettingInfo(settingType: String, userId: String, settingInfo: Int) -> Bool
    func isSettingExist(settingType: String, userId: String) -> Bool
    
}

extension SettingRealmListOperateDelegate {

    func querySettingList() -> SettingRealmListModel? {
        
        guard isExistSettingList() else {
            
            return initSettingList()
            
        }
        
        let settingList = realm.objects(SettingRealmListModel).filter("userId = '\(userId)'")
        
        return settingList.first
    }
    
    func queryAllSettingList() -> Results<(SettingRealmListModel)> {
        return realm.objects(SettingRealmListModel).filter("userId = '\(userId)'")
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
        
        let phoneSetting = initSettingModel(L10n.SettingReminderPhoneType.string, userId: userId)
        
//        let messageSetting = initSettingModel(L10n.SettingReminderMessageType.string, userId: userId)
        
//        let reconnectSetting = initSettingModel(L10n.SettingReminderReconnectType.string, userId: userId)
        
        settingList.settingRealmList.appendContentsOf([phoneSetting])
        
        if addSettingList(settingList) {
            return settingList
        }
        
        return nil
        
    }
    
    func initSettingModel(settingType: String, userId: String) -> SettingRealmModel {
        
        let settingModel = SettingRealmModel()
        
        settingModel.isOpenSetting = true
        
        settingModel.settingType = settingType
        
        settingModel.userId = userId
        
        if settingType == L10n.SettingReminderPhoneType.string { //来电提醒
            
            settingModel.settingInfo = 0
            
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
    func querySetting(settingType: String, userId: String) -> SettingRealmModel? {
        
        let settingModels = realm.objects(SettingRealmModel).filter("settingType == '\(settingType)' && userId == '\(userId)'")
        
        if 0 == settingModels.count {
            //数据库没有相关设置，就设添加一个默认设置
            let settingModel = initModel(settingType, userId: userId)
            
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
     更新设置 开关
     */
    func updateSettingOpen(settingType: String, userId: String, settingOpen: Bool) -> Bool {
        
        
        guard let settingList = realm.objects(SettingRealmListModel).filter("userId = '\(userId)'").first else {
            return false
        }
        
        guard let settingModel = settingList.settingRealmList.filter("settingType = '\(settingType)'").first else {
            return false
        }
        
        do {
            
            realm .beginWrite()
            
            settingModel.isOpenSetting = settingOpen
            
            try realm.commitWrite()
            
        } catch {
            
            Log.error("Update setting error [\(settingType)]")
            return false
            
        }
        
        Log.info("Update setting success [\(settingType)]")
        return true
    }
    
    /**
     更新电话设置的时间index 
     */
    func updateSettingInfo(settingType: String, userId: String, settingInfo: Int) -> Bool {
        
        guard let settingList = realm.objects(SettingRealmListModel).filter("userId = '\(userId)'").first else {
            return false
        }
        
        guard let settingModel = settingList.settingRealmList.filter("settingType = '\(settingType)'").first else {
            return false
        }
        
        do {

            realm .beginWrite()
            
            settingModel.settingInfo = settingInfo
            
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
    func isSettingExist(settingType: String, userId: String) -> Bool {
        
        if let _ = querySetting(settingType, userId: userId) {
            return true
        }
        
        return false
    }
    
    func initModel(settingType: String, userId: String) -> SettingRealmModel {
        let settingModel = SettingRealmModel()
        
        settingModel.isOpenSetting = true
        
        settingModel.settingType = settingType
        
        settingModel.userId = userId
        
        if settingType == L10n.SettingReminderPhoneType.string { //来电提醒
            
            settingModel.settingInfo = 0
            
        }
        
        return settingModel
    }
    
}
