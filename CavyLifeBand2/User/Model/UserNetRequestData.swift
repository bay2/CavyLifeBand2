//
//  UserRequestData.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Alamofire
import Log
import EZSwiftExtensions

let UserNetRequestParaKeyPhoneNumKey =  "phoneNum"
let UserNetRequestParaKeyEmailKey = "email"
let UserNetRequestParaKeyPasswdKey = "pwd"
let UserNetRequestParaKeySecurityCodeKey = "authCode"
let UserNetRequestParaKeyUserNameKey = "user"
let UserNetRequestParaKeyUserIDKey = "userId"
let UserNetRequestParaKeyAvatarKey = "imgFile"
let UserNetRequestParaKeyStepNumKey = "stepNum"
let UserNetRequestParaKeySleepTimeKey = "sleepTime"
let UserNetRequestParaKeyPhoneNumListKey = "phoneNumList"
let UserNetRequestParaKeyFriendIDKey = "friendId"
let UserNetRequestParaKeyFlagKey = "flag"
let UserNetRequestParaKeyLocalKey = "lbs"
let UserNetRequestParaKeyFriendIdListKey = "friendIds"
let UserNetRequestParaKeyOperateKey = "operate"
    
/**
 网络请求错误类型
 
 - NetErr:    网络错误
 - NetAPIErr: API接口错误
 - ParamErr:  参数错误
 */
enum UserRequestErrorType: ErrorType {
    case NetErr, NetAPIErr, ParaNil, ParaErr, EmailErr, PhoneErr
}

class UserNetRequestData: NSObject {
    
    typealias CompletionHandlernType = (Result<AnyObject, UserRequestErrorType>) -> Void
    
    private let webAPI = [UserNetRequestMethod.SendSecurityCode.rawValue: ""]
   

    
    /**
    网络请求API
    
    - SendSecurityCode: 发送验证码
    - SignUp:           注册
    - SignIn:           登录
    - UpdateAvatar:     上传头像
    - ForgotPwd:        找回密码
    - UserProfile:      查询个人信息
    - SetUserProfile:   设置个人信息
    - SearchFriends:    搜索好友
    - AddFriends:       添加好友
    - DelFriends:       删除好友
    - FriendsList:      查询好友列表
    - FriendsReqList:   查询请求添加好友列表
    - WatchFriend:      关注好友
    - ReportLocation:   上报坐标
    - SetTargetValue:   设置目标值
    - TargetValue:      查询目标值
    */
    enum UserNetRequestMethod: String {
        
        case SendSecurityCode
        case SignUp
        case SignIn
        case UpdateAvatar
        case ForgotPwd
        case UserProfile
        case SetUserProfile
        case SearchFriends
        case AddFriends
        case DelFriends
        case FriendsList
        case FriendsReqList
        case WatchFriend
        case ReportLocation
        case SetTargetValue
        case TargetValue
    }
    
    /**
     
     - parameter method:     请求类型
     - parameter parameters: 参数
     */
    func netRequestApi(method: UserNetRequestMethod, parameters: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) {
        
        switch method {
        case .SendSecurityCode:
            requestSecurityCode(parameters, completionHandler: completionHandler)
            
        default:
            Log.error("methoe Invalid (\(method))")
            
        }
        
    }
    
    /**
     请求短信验证码
     
     - parameter parameters: 参数 PhoneNumKey, EmailKey
     */
    private func requestSecurityCode(parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        let urlString = serverAddr + webAPI[UserNetRequestMethod.SendSecurityCode.rawValue]!
        
        //有效性校验
        guard let para = parameters else {
            completionHandler?(.Failure(.ParaNil))
            Log.error("Para nil")
            return
        }
        
        if para.indexForKey(UserNetRequestParaKeyPhoneNumKey) == nil && para.indexForKey(UserNetRequestParaKeyEmailKey) == nil {
            completionHandler?(.Failure(.ParaErr))
            Log.error("Para error")
            return
        }
        
        if let email: String = para[UserNetRequestParaKeyEmailKey] as? String {
            
            if email.isEmail != true {
                completionHandler?(.Failure(.EmailErr))
                Log.error("Email error")
                return
            }

        }
        
        if let phone: String = para[UserNetRequestParaKeyPhoneNumKey] as? String {
            
            if phone.isPhoneNum != true {
                completionHandler?(.Failure(.PhoneErr))
                Log.error("Phone error")
                return
            }
            
        }
        
        //发送API请求
        Log.netRequestFormater(urlString, para: para)
        Alamofire.request(.POST, urlString, parameters: para).responseJSON { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if response.result.isFailure {
                    completionHandler?(.Failure(.NetErr))
                    Log.error("Network error")
                    return
                }
                
                guard let responseResult = response.result.value else {
                    completionHandler?(.Failure(.NetAPIErr))
                    Log.error("Network API error")
                    return
                }
                
                completionHandler?(.Success(responseResult))
                
            })
        }
    }
    
}
