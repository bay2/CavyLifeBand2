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
    case NetErr, NetAPIErr, ParaNil, ParaErr, EmailErr, EmailNil, PhoneErr, PhoneNil, PassWdErr, PassWdNil, SecurityCodeErr, SecurityCodeNil, UserNameErr, UserNameNil
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
    
    case Cmd = "cmd"
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
    
    private let webAPI = [UserNetRequestMethod.SendSecurityCode.rawValue: "sendAuthCode",
    UserNetRequestMethod.SignIn.rawValue: "userLogin",
    UserNetRequestMethod.SignUp.rawValue: "userReg",
    UserNetRequestMethod.ForgotPwd.rawValue: "resetPsw",
    UserNetRequestMethod.UpdateAvatar.rawValue: "updateAvatar"]
    
   

    
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
     注册
     
     - parameter parameters:        参数：UserNetRequestParaKeyEmailKey, UserNetRequestParaKeyPhoneNumKey, UserNetRequestParaKeyPasswdKey, UserNetRequestParaKeySecurityCodeKey
     - parameter completionHandler: 回调
     */
    func requestSignUp(var parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
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

            let check = emailCheck(email)
            guard check.0 else {
                completionHandler?(.Failure(check.1!))
                return
            }
        }
        
        if let phone = parameters![UserNetRequsetKey.PhoneNum.rawValue] as? String {

            let check = phoneNumCheck(phone)
            guard check.0 else {
                completionHandler?(.Failure(check.1!))
                return
            }

        }

        if let pwd = parameters![UserNetRequsetKey.Passwd.rawValue] as? String {

            let check = passwordCheck(pwd)
            if check.0 == false {
                completionHandler?(.Failure(check.1!))
                return
            }
        }
        
        parameters![UserNetRequsetKey.Cmd.rawValue] = webAPI[UserNetRequestMethod.SignUp.rawValue]!
        
        netPostRequestAdapter(webApiAddr, para: parameters, completionHandler: completionHandler)
        
    }
    
    /**
     用户登录
     
     - parameter parameters:        UserNetRequsetKey.UserName, UserNetRequsetKey.Passwd
     - parameter completionHandler: 回调
     */
    func requestSignIn(var parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        if parameters == nil {
            
            completionHandler?(.Failure(.ParaNil))
            Log.error("Para is nil")
            return
            
        }
        
        if let userName = parameters![UserNetRequsetKey.UserName.rawValue] as? String {

            let check = userNameCheck(userName)
            if check.0 == false {
                
                completionHandler?(.Failure(check.1!))
                Log.error("UserName error")
                return
            }
            
        }
        
        if let pwd = parameters![UserNetRequsetKey.Passwd.rawValue] as? String {

            let check = passwordCheck(pwd)

            if check.0 != true {
                completionHandler?(.Failure(check.1!))
                Log.error("Password error")
                return
            }
        }
        
        parameters![UserNetRequsetKey.Cmd.rawValue] = webAPI[UserNetRequestMethod.SignIn.rawValue]!
        
        netPostRequestAdapter(webApiAddr, para: parameters, completionHandler: completionHandler)
        
    }
    
    /**
     用户有效性校验
     
     - parameter userName: 用户名
     
     - returns: 用户名有效返回 true，否则 false
     */
    func passwordCheck(passwd: String) -> (Bool, UserRequestErrorType?) {

        if passwd.length == 0 {
            Log.error("Password is nil")
            return (false, .PassWdNil)
        }
        
        if passwd.length < 6 || passwd.length > 16 {
            Log.error("Password error")
            return (false, .PassWdErr)
        }
        
        return (true, nil)
        
    }
    
    /**
     检查手机验证码是否有效
     
     - parameter securityCode: 验证码
     
     - returns: true 有效，false 无效
     */
    func phoneSecurityCodeCheck(securityCode: String) -> (Bool, UserRequestErrorType?) {

        if securityCode.length == 0 {
            Log.error("Security code is nil")
            return  (false, .SecurityCodeNil)
        }

        if securityCode.length != 4 {
            Log.error("Security code error")
            return (false, .SecurityCodeErr)
        }
        
        guard let _ = securityCode.toInt() else {
            Log.error("Security code error")
            return (false, .SecurityCodeErr)
        }
        
        return (true, nil)
    }
    
    /**
     邮箱验证码是否有效
     
     - parameter securityCode: 验证码
     
     - returns: true 有效，false 无效
     */
    func emailSecurityCodeCheck(securityCode: String) -> (Bool, UserRequestErrorType?) {

        if securityCode.length == 0 {
            Log.error("Security code is nil")
            return (false, .SecurityCodeNil)
        }
        
        if securityCode.length != 4 {
            Log.error("Security code error")
            return (false, .SecurityCodeErr)
        }
        
        return (true, nil)
        
    }
    
    /**
     找回密码
     
     - parameter parameter:         PhoneNum, Email, Passwd, SecurityCode
     - parameter completionHandler: 回调
     */
    func forgotPasswd(parameter: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        guard var para = parameter else {
            Log.error("Parameter is nil")
            completionHandler?(.Failure(.ParaNil))
            return
        }
        
        // 参数不存在手机号码和邮箱
        if para.keys.contains(UserNetRequsetKey.PhoneNum.rawValue) == false && para.keys.contains(UserNetRequsetKey.Email.rawValue) == false {
            Log.error("Parameter error")
            completionHandler?(.Failure(.ParaErr))
            return
        }
        
        guard let securityCode = para[UserNetRequsetKey.SecurityCode.rawValue] as? String else {
            Log.error("Security code is nil")
            completionHandler?(.Failure(.ParaErr))
            return
        }

        // 手机号码校验
        if let phoneNum = para[UserNetRequsetKey.PhoneNum.rawValue] as? String {

            if phoneNum.length == 0 {
                Log.error("Phone is nil")
                completionHandler?(.Failure(.SecurityCodeNil))
                return
            }
            
            if phoneNum.isPhoneNum == false {
                Log.error("Phone Num error")
                completionHandler?(.Failure(.PhoneErr))
                return
            }

            let phoneCheck = phoneSecurityCodeCheck(securityCode)
            if phoneCheck.0 == false {
                completionHandler?(.Failure(phoneCheck.1!))
                return
            }
        }
        
        // 邮箱校验
        if let email = para[UserNetRequsetKey.Email.rawValue] as? String {

            var check = emailCheck(email)
            guard check.0 else {
                completionHandler?(.Failure(check.1!))
                return
            }

            check = emailSecurityCodeCheck(securityCode)
            if check.0 == false {
                completionHandler?(.Failure(check.1!))
                return
            }
        }
        
        // 密码校验
        guard let pwd = para[UserNetRequsetKey.Passwd.rawValue] as? String else {
            Log.error("Passwd is nil")
            completionHandler?(.Failure(.ParaErr))
            return
        }

        let check = passwordCheck(pwd)
        if check.0 != true {
            completionHandler?(.Failure(check.1!))
            return
        }
        
        para[UserNetRequsetKey.Cmd.rawValue] = webAPI[UserNetRequestMethod.ForgotPwd.rawValue]!
        
        netPostRequestAdapter(webApiAddr, para: para, completionHandler: completionHandler)
        
    }
    
    /**
     请求发送短信验证码
     
     - parameter parameter:         PhoneNum
     - parameter completionHandler: 回调
     */
    func requestPhoneSecurityCode(parameter: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        guard var para = parameter else {
            Log.error("Parameter is nil")
            completionHandler?(.Failure(.ParaNil))
            return
        }
        
        if let phoneNum = para[UserNetRequsetKey.PhoneNum.rawValue] as? String {

            let check = phoneNumCheck(phoneNum)
            if check.0 == false {
                completionHandler?(.Failure(check.1!))
                return
            }
        }

        para[UserNetRequsetKey.Cmd.rawValue] = webAPI[UserNetRequestMethod.SendSecurityCode.rawValue]!
        
        netPostRequestAdapter(webApiAddr, para: para, completionHandler: completionHandler)
        
    }
    
    /**
     上传照片
    
     - parameter parameter:  UserID，Avater
     - parameter completion: 回调
     */
    func uploadPicture(parameter: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {
        
        guard var para = parameter else {
            Log.error("Parameter is nil")
            completionHandler?(.Failure(.ParaNil))
            return
        }
        
        guard let image = para[UserNetRequsetKey.Avater.rawValue] as? UIImage else {
            Log.error("Avater is nil")
            completionHandler?(.Failure(.ParaErr))
            return
        }
        
        guard let _ = para[UserNetRequsetKey.UserID.rawValue] else {
            Log.error("User ID is nil")
            completionHandler?(.Failure(.ParaErr))
            return
        }
        
        para[UserNetRequsetKey.Avater.rawValue] = UIImagePNGRepresentation(image)
        para[UserNetRequsetKey.Cmd.rawValue] = webAPI[UserNetRequestMethod.UpdateAvatar.rawValue]!
        
        netPostRequestAdapter(webApiAddr, para: para, completionHandler: completionHandler)
        
    }

    /**
     邮箱校验
     
     - parameter email: 邮箱
     
     - returns:
     */
    func emailCheck(email: String) -> (Bool, UserRequestErrorType?) {

        if email.length == 0 {
            Log.error("Email is nil")
            return (false, .EmailNil)
        }

        guard email.isEmail else {
            Log.error("Email error")
            return (false, .EmailErr)
        }

        return (true, nil)
    }

    /**
     手机号校验
     
     - parameter phoneNum: 手机号
     
     - returns:
     */
    func phoneNumCheck(phoneNum: String) -> (Bool, UserRequestErrorType?) {

        if phoneNum.length == 0 {
            Log.error("Phone is nil")
            return (false, .PhoneNil)
        }

        guard phoneNum.isPhoneNum else {
            Log.error("Phone num error")
            return (false, .PhoneErr)
        }

        return (true, nil)
    }

    /**
     用户名校验
     
     - parameter userName: 用户名
     
     - returns: 
     */
    func userNameCheck(userName: String) -> (Bool, UserRequestErrorType?) {

        if userName.length == 0 {
            Log.error("UserName is nil")
            return (false, .UserNameNil)
        }

        if userName.isEmail != true && userName.isPhoneNum != true {
            Log.error("UserName error")
            return (false, .UserNameErr)
        }

        return (true, nil)

    }
    
}
