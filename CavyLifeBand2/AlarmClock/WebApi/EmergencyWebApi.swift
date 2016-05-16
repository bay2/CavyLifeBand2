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
    
    func setEmergencyPhoneList(callBack: CompletionHandlernType? = nil) throws {
        
        let phoneList = getPhoneNumberList()
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SetEmergencyPhone.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId,
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

}
