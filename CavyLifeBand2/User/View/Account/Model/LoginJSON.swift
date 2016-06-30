//
//  LoginJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy

/**
 *  通用响应模型
 */
struct LoginResponse: CommenResponseProtocol, JSONJoy {
    //通用消息头
    var commonMsg: CommenResponse
    
    var userId: String
    
    var userName: String
    
    var authToken: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        do { userId    = try decoder["user_id"].getString() } catch { userId = "" }
        do { userName  = try decoder["username"].getString() } catch { userName = "" }
        do { authToken = try decoder["auth_token"].getString() } catch { authToken = "" }
        
    }
    
}


//        let parameters: [String: AnyObject] = [NetRequsetKey.UserName.rawValue: userName,
//                                               NetRequsetKey.Password.rawValue: passwd.md5()]
//
//        NetWebApi.shareApi.netPostRequest(WebApiMethod.Login.description, para: parameters, modelObject: LoginResponse.self, successHandler: { (data) in
//
//            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = data.userId
//            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = data.userName
//            CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken = data.authToken
//
//            callBack?()
//
//        }) { (msg) in
//            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: msg.msg)
//        }