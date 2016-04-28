//
//  EmergencyContactRealmModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class EmergencyContactRealmModel: Object {
    dynamic var contactName = ""
    dynamic var phoneNumber = ""
    dynamic var userId = ""
    
    var owners: [EmergencyContactRealmListModel] {
        
        return linkingObjects(EmergencyContactRealmListModel.self, forProperty: "emergencyContactRealmList")
    }

}

class EmergencyContactRealmListModel: Object {
    
    dynamic var userId = ""
    
    var emergencyContactRealmList = List<EmergencyContactRealmModel>()
    
    override class func primaryKey() -> String? {
        return "userId"
    }
    
}

protocol EmergencyContactRealmListOperateDelegate {
    
    var realm: Realm { get }
    
    var userId: String { get }
    
    func queryEmergencyContactList() -> EmergencyContactRealmListModel?
    
}


extension EmergencyContactRealmListOperateDelegate {
    
    func queryEmergencyContactList() -> EmergencyContactRealmListModel? {
        guard isExistEmergencyContactList() else {
            return initEmergencyContactList()
        }
        
        let emergencyContactList = realm.objects(EmergencyContactRealmListModel).filter("userId = '\(userId)'")
        
        return emergencyContactList.first!
    }
    
    func isExistEmergencyContactList() -> Bool {
        let emergencyContactList = realm.objects(EmergencyContactRealmListModel).filter("userId = '\(userId)'")
        
        if emergencyContactList.count <= 0 {
            return false
        }
        
        return true
    }
    
    func initEmergencyContactList() -> EmergencyContactRealmListModel? {
        
        let emergencyContactList = EmergencyContactRealmListModel()
        
        emergencyContactList.userId = userId
        
        if addEmergencyContactList(emergencyContactList) {
            return emergencyContactList
        }
        
        return nil
        
    }
    
    func addEmergencyContactList(emergencyContactList: EmergencyContactRealmListModel) -> Bool {
        
        do {
            try realm.write {
                realm.add(emergencyContactList, update: false)
            }
        } catch {
            Log.error("Add emergencyContactList error [\(emergencyContactList)]")
            return false
        }
        
        Log.info("Add emergencyContactList success")
        return true
    }
    
    func deleteEmergencyContactRealm(index: Int, listModel: EmergencyContactRealmListModel) -> Bool {
        
        self.realm.beginWrite()
        
        listModel.emergencyContactRealmList.removeAtIndex(index)
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func addEmergencyContact(emergencyContact: EmergencyContactRealmModel, listModel: EmergencyContactRealmListModel) -> Bool {
        
        //在数据库找相同电话的联系人记录
        let oldAlarmList = listModel.emergencyContactRealmList.filter("phoneNumber = '\(emergencyContact.phoneNumber)'")
        
        if oldAlarmList.count == 0 {
            //没有相同电话的联系人记录，新加一个
            
            self.realm.beginWrite()
            listModel.emergencyContactRealmList.insert(emergencyContact, atIndex: 0)
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
        }
        
        return true
    }



}