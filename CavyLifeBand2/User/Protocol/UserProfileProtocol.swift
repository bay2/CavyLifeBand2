//
//  UserProfileProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions
import Log

protocol QueryUserInfoRequestsDelegate {
    
    var queryUserId: String { get }
    
    func queryUserInfoByNet(completeHeadle: (UserProfile? -> Void)?)
    
}

// MARK: - 用户信息网络请求协议
extension QueryUserInfoRequestsDelegate {
    
    /**
     查询用户信息
     */
    func queryUserInfoByNet(completeHandle: (UserProfile? -> Void)? = nil) {
        
        UserNetRequestData.shareApi.queryProfile(queryUserId) { result in
            
            guard result.isSuccess else {
                completeHandle?(nil)
                return
            }
            
            let resultMsg = try! UserProfileMsg(JSONDecoder(result.value!))
            
            guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                completeHandle?(nil)
                return
            }
            
            completeHandle?(resultMsg.userProfile)
            
        }
        
    }
    
    
}

/**
 *  @author xuemincai
 *
 *  设置用户信息请求
 */
protocol SetUserInfoRequestsDelegate {
    
    var userInfoPara: [String: AnyObject] { get }
    
    func setUserInfo(completeHandle: (Bool -> Void)?)
    
    var viewController: UIViewController? { get }
    
}


extension SetUserInfoRequestsDelegate {
    
    var viewController: UIViewController? { return nil }
    
    /**
     设置用户信息
     
     - parameter completeHandle: 完成回调
     */
    func setUserInfo(completeHandle: (Bool -> Void)? = nil) {
        
        UserNetRequestData.shareApi.setProfile(userInfoPara) { result in
            
            guard result.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                completeHandle?(false)
                return
            }
            
            let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: resultMsg.code!)
                completeHandle?(false)
                return
            }
            
            Log.info("Update user info success")
            completeHandle?(true)
            
        }
        
    }
    
}



