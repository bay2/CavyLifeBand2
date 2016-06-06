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

class EmergencyWebApi: NetRequestAdapter, EmergencyContactRealmListOperateDelegate {
    
    static var shareApi = EmergencyWebApi()
    
    var realm: Realm = try! Realm()
    
    var userId: String = { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }()
    
    /**
     设置紧急联系人
     
     - parameter callBack: 回调
     
     - throws:
     */
    func setEmergencyPhoneList(phoneList: [[String: String]], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SetEmergencyPhone.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: self.userId,
                                               UserNetRequsetKey.PhoneList.rawValue: phoneList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
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
    func sendEmergencyMsg(callBack: CompletionHandlernType? = nil) throws {
        
        SCLocationManager.shareInterface.startUpdateLocation { coordinate in
            
            let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SendEmergencyMsg.rawValue,
                UserNetRequsetKey.UserID.rawValue: self.userId,
                UserNetRequsetKey.Latitude.rawValue: coordinate.latitude.toString,
                UserNetRequsetKey.Longitude.rawValue: coordinate.longitude.toString]
            
            self.netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
            
        }
        
    }
    
    /**
     获取紧急联系人列表
     
     - parameter callBack: 回调
     
     - throws:
     */
    func getEmergencyList(callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetEmergencyPhone.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: self.userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }

}
