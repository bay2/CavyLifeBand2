//
//  EmergencyWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import JSONJoy
import RealmSwift

class EmergencyWebApi: NetRequestAdapter, EmergencyContactRealmListOperateDelegate, NetRequest {
    
    static var shareApi = EmergencyWebApi()
    
    var realm: Realm = try! Realm()
    
    var userId: String = { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }()
    
    /**
     设置紧急联系人
     
     - parameter callBack: 回调
     
     - throws:
     */
    func setEmergencyPhoneList(phoneList: [[String: String]], callBack: (Void -> Void)? = nil) throws {
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Contacts.rawValue: phoneList]
        
        netPostRequest(WebApiMethod.EmergencyContacts.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            
            callBack?()
            
        }) { (msg) in
            
            Log.error(msg)
            
        }

        
    }
    
    func getPhoneNumberList() -> [String] {
        
        let realms: EmergencyContactRealmListModel = queryEmergencyContactList()!
        
        var phoneList = [String]()
        
        for realm in realms.emergencyContactRealmList {
            phoneList.append(realm.phoneNumber)
        }
        
        return phoneList
    }
    
    
    /**
     发送紧急消息
     
     - parameter callBack: 回调
     
     - throws:
     */
    func sendEmergencyMsg(callBack: (Void -> Void)? = nil) throws {
        
        SCLocationManager.shareInterface.startUpdateLocation { [unowned self] coordinate in
            
            let parameters: [String: AnyObject] = [NetRequsetKey.Latitude.rawValue: coordinate.latitude.toString,
                                                   NetRequsetKey.Longitude.rawValue: coordinate.longitude.toString]
            
            self.netPostRequest(WebApiMethod.Emergency.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { (data) in
                
                callBack?()
                
            }) { (msg) in
                
                Log.error(msg)
                
            }
            
        }
        
    }
    
}
