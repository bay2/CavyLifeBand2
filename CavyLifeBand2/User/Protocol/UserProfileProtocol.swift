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
    
    
    func queryUserInfoByNet(vc: UIViewController?, completeHeadle: (UserProfile? -> Void)?)
    
}

// MARK: - 用户信息网络请求协议
extension QueryUserInfoRequestsDelegate {
    
    /**
     查询用户信息
     */
    func queryUserInfoByNet(vc: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, completeHeadle completeHandle: (UserProfile? -> Void)? = nil) {

        NetWebApi.shareApi.netGetRequest(WebApiMethod.UsersProfile.description, modelObject: UserProfileMsg.self, successHandler: { (data) in

            completeHandle?(data.userProfile)

        }) { (msg) in
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: msg.msg)
        }
        
        
    }
    
    
}

/**
 *  @author xuemincai
 *
 *  设置用户信息请求
 */
protocol SetUserInfoRequestsDelegate {
    
    var userInfoPara: [String: AnyObject] { get set }
    
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
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Profile.rawValue: userInfoPara]

        NetWebApi.shareApi.netPostRequest(WebApiMethod.UsersProfile.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            
            completeHandle?(true)
     
        }) { (msg) in
            completeHandle?(false)
        }
        
    }
    
}



