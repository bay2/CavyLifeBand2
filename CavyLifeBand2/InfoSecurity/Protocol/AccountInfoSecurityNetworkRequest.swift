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
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: userInfo.userId,
                                               UserNetRequsetKey.IsOpenHeight.rawValue: true,
                                               UserNetRequsetKey.IsOpenWeight.rawValue: userInfo.isOpenWeight.boolValue,
                                               UserNetRequsetKey.IsOpenBirthday.rawValue: userInfo.isOpenBirthday.boolValue]
        
        UserNetRequestData.shareApi.setProfile(parameters) { result in
            
            guard result.isSuccess else {
                completeCallback?(false)
                return
            }
            
            let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                completeCallback?(false)
                return
            }
            
            completeCallback?(true)
            
        }
        
    }
    
}