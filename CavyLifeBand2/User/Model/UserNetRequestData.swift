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
import CryptoSwift


/**
 网络请求错误类型
 
 - NetErr:    网络错误
 - NetAPIErr: API接口错误
 - ParamErr:  参数错误
 */
enum UserRequestErrorType: ErrorType {
    case NetErr, NetAPIErr, ParaNil, ParaErr, EmailErr, PhoneErr, PassWdErr, SecurityErr, UserNameErr
}

/**
 web api参数
 
 - PhoneNum:     手机号
 - Email:        邮箱
 - Passwd:       密码
 - SecurityCode: 验证码
 - UserName:     用户名
 - UserID:       用户ID
 - Avater:       头像
 - StepNum:      步数
 - SleepTime:    睡眠时间
 - FriendID:     好友ID
 - Flag:         标识
 - Local:        坐标
 - FriendIdList: 好友列表
 - Operate:      操作
 */
enum UserNetRequsetKey: String {
    
    case PhoneNum = "phoneNum"
    case Email = "email"
    case Passwd = "pwd"
    case SecurityCode = "authCode"
    case UserName = "user"
    case UserID = "userId"
    case Avater = "imgFile"
    case StepNum = "stepNum"
    case SleepTime = "phoneNumList"
    case FriendID = "freiendId"
    case Flag = "flag"
    case Local = "lbs"
    case FriendIdList = "friendIds"
    case Operate = "operate"
    
}

let userNetReq = UserNetRequestData()

class UserNetRequestData: NetRequestAdapter {
    
    typealias CompletionHandlernType = (Result<AnyObject, UserRequestErrorType>) -> Void
    
    private let webAPI = [UserNetRequestMethod.SendSecurityCode.rawValue: "sendSecurityCode",
    UserNetRequestMethod.SignIn.rawValue: "signIn",
    UserNetRequestMethod.SignUp.rawValue: "signUp"]
    
   

    
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
     请求短信验证码
     
     - parameter parameters:        参数 UserNetRequestParaKeyEmailKey，UserNetRequestParaKeyEmailKey
     - parameter completionHandler: 回调
     */
    func requestSecurityCode(parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        let urlString = serverAddr + webAPI[UserNetRequestMethod.SendSecurityCode.rawValue]!
        
        //有效性校验
        guard let para = parameters else {
            completionHandler?(.Failure(.ParaNil))
            Log.error("Parameter nil")
            return
        }
        
        if let phone: String = para[UserNetRequsetKey.PhoneNum.rawValue] as? String {
            
            if phone.isPhoneNum != true {
                completionHandler?(.Failure(.PhoneErr))
                Log.error("Phone error")
                return
            }
            
        }
        
        netPostRequestAdapter(urlString, para: para, completionHandler: completionHandler)
        
   }
    
    /**
     注册
     
     - parameter parameters:        参数：UserNetRequestParaKeyEmailKey, UserNetRequestParaKeyPhoneNumKey, UserNetRequestParaKeyPasswdKey, UserNetRequestParaKeySecurityCodeKey
     - parameter completionHandler: 回调
     */
    func requestSignUp(var parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        let urlString = serverAddr + webAPI[UserNetRequestMethod.SignIn.rawValue]!
        
        //参数有效性检测
        if parameters == nil {
            completionHandler?(.Failure(.NetErr))
            Log.error("Parameter nil")
            return
        }
        
        if !parameters!.keys.contains(UserNetRequsetKey.SecurityCode.rawValue) || !parameters!.keys.contains(UserNetRequsetKey.Passwd.rawValue) {
            
            completionHandler?(.Failure(.ParaErr))
            Log.error("Parameter error")
            return
            
        }
        
        if !parameters!.keys.contains(UserNetRequsetKey.Email.rawValue) && !parameters!.keys.contains(UserNetRequsetKey.PhoneNum.rawValue) {
            
            completionHandler?(.Failure(.ParaErr))
            Log.error("Parameter error")
            return
            
        }
        
        if let email = parameters![UserNetRequsetKey.Email.rawValue] as? String {
            guard email.isEmail else {
                completionHandler?(.Failure(.EmailErr))
                Log.error("Email error")
                return
            }
        }
        
        if let phone = parameters![UserNetRequsetKey.PhoneNum.rawValue] as? String {
            guard phone.isPhoneNum else {
                completionHandler?(.Failure(.PhoneErr))
                Log.error("Phone num error")
                return
            }
        }
        
        
        if let pwd = parameters![UserNetRequsetKey.Passwd.rawValue] as? String {
            
            if passwordCheck(pwd) != true {
                completionHandler?(.Failure(.PassWdErr))
                Log.error("Password error")
                return
            }
            
            // 密码进行MD5加密
            parameters![UserNetRequsetKey.Passwd.rawValue] = pwd.md5()
            
        }
        
        netPostRequestAdapter(urlString, para: parameters, completionHandler: completionHandler)
        
    }
    
    /**
     用户登录
     
     - parameter parameters:        UserNetRequsetKey.UserName, UserNetRequsetKey.Passwd
     - parameter completionHandler: 回调
     */
    func requestSignIn(var parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        let urlString  = webAPI[UserNetRequestMethod.SignUp.rawValue]!
        
        if parameters == nil {
            
            completionHandler?(.Failure(.ParaNil))
            Log.error("Para is nil")
            return
            
        }
        
        if let userName = parameters![UserNetRequsetKey.UserName.rawValue] as? String {
            
            if userName.isPhoneNum != true && userName.isEmail != true {
                
                completionHandler?(.Failure(.UserNameErr))
                Log.error("UserNmae error")
                return
            }
            
        }
        
        // 密码MD5 加密
        if let pwd = parameters![UserNetRequsetKey.Passwd.rawValue] as? String {
            
            if passwordCheck(pwd) != true {
                completionHandler?(.Failure(.PassWdErr))
                Log.error("Password error")
                return
            }
            
            parameters![UserNetRequsetKey.Passwd.rawValue] = pwd.md5()
        }
        
        netPostRequestAdapter(urlString, para: parameters, completionHandler: completionHandler)
        
    }
    
    /**
     用户有效性校验
     
     - parameter userName: 用户名
     
     - returns: 用户名有效返回 true，否则 false
     */
    func passwordCheck(passwd: String) -> Bool {
        
        if passwd.length < 6 || passwd.length > 16 {
            return false
        }
        
        return true
        
    }
    
    /**
     找回密码
     
     - parameter parameter:         <#parameter description#>
     - parameter completionHandler: 回调
     */
    func forgotPasswd(parameter: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        
        
    }
    
}
