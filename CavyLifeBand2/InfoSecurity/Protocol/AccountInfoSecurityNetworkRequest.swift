//
//  AccountInfoSecurityNetworkRequest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import RealmSwift
import JSONJoy

protocol AccountInfoSecurityUpdateByNetwork {
    
    var realmUserInfo: UserInfoModel? { get }
    
    func updateInfoSecurityAttir(completeCallback: (Bool -> Void)?)
    
}

extension AccountInfoSecurityUpdateByNetwork {
    
    func updateInfoSecurityAttir(completeCallback: (Bool -> Void)?) {
        
        guard let userInfo = realmUserInfo else {
            completeCallback?(false)
            return
        }
        
        let subPara: [String: AnyObject] = [NetRequsetKey.ShareHeight.rawValue: userInfo.isOpenHeight.boolValue,
                                               NetRequsetKey.ShareWeight.rawValue: userInfo.isOpenWeight.boolValue,
                                               NetRequsetKey.ShareBirthday.rawValue: userInfo.isOpenBirthday.boolValue]
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Profile.rawValue: subPara]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.UsersProfile.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { data in

            completeCallback?(true)
            
        }) { (msg) in
            
            completeCallback?(false)
            
        }
        
    }
    
}