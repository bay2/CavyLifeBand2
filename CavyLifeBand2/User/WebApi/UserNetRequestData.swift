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
    case NetErr, NetAPIErr, ParaNil, ParaErr, EmailErr, EmailNil, PhoneErr, PhoneNil, PassWdErr, PassWdNil, SecurityCodeErr, SecurityCodeNil, UserNameErr, UserNameNil, UserIdNil, SearchTypeNil, LBSNil, PhoneNumListNil
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
 - NickName:     昵称
 - Sex:          性别
 - Height:       身高
 - Weight:       体重
 - Birthday:     生日
 - Address:      地址
 - StepNum:      步数
 - SleepTime:    睡眠时间
 */
enum UserNetRequsetKey: String {
    
    case Cmd = "cmd"
    case PhoneNum = "phoneNum"
    case Passwd = "pwd"
    case SecurityCode = "authCode"
    case UserName = "user"
    case UserID = "userId"
    case Avater = "imgFile"
    case FriendID = "freiendId"
    case Flag = "flag"
    case Local = "lbs"
    case FriendIdList = "friendIds"
    case Operate = "operate"
    case NickName = "nickname"
    case Sex = "sex"
    case Height = "height"
    case Weight = "weight"
    case Birthday = "birthday"
    case Address = "address"
    case StepNum = "stepNum"
    case SleepTime = "sleepTime"

}

let userNetReq = UserNetRequestData()



class UserNetRequestData: NetRequestAdapter {
   
    
    
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
        
        case SendSecurityCode = "sendAuthCode"
        case SignUp = "userReg"
        case SignIn = "userLogin"
        case UpdateAvatar
        case ForgotPwd = "resetPsw"
        case UserProfile = "getUserInfo"
        case SetUserProfile = "setUserInfo"
    }

    /**
     注册
     
     - parameter parameters:        参数：UserNetRequestParaKeyEmailKey, UserNetRequestParaKeyPhoneNumKey, UserNetRequestParaKeyPasswdKey, UserNetRequestParaKeySecurityCodeKey
     - parameter completionHandler: 回调
     */
    func requestSignUp(userName: String, safetyCode: String, passwd: String, completionHandler: CompletionHandlernType?) {

        if userName.isEmail == false && userName.isPhoneNum == false {
            
            completionHandler?(.Failure(.UserNameErr))
            Log.error("User name is error")
            return
            
        }
        
        guard passwordCheck(passwd) else {
            
            completionHandler?(.Failure(.PassWdErr))
            Log.error("Passwrod is error")
            return
            
        }
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SignUp.rawValue,
                                               UserNetRequsetKey.UserName.rawValue: userName,
                                               UserNetRequsetKey.SecurityCode.rawValue: safetyCode,
                                               UserNetRequsetKey.Passwd.rawValue: passwd.md5()]

        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: completionHandler)
        
    }
    
    /**
     用户登录
     
     - parameter parameters:        UserNetRequsetKey.UserName, UserNetRequsetKey.Passwd
     - parameter completionHandler: 回调
     */
    func requestSignIn(userName: String, passwd: String, completionHandler: CompletionHandlernType?) {
        
        //参数有效性检测
        if userName.isEmpty {
            
            completionHandler?(.Failure(.UserNameNil))
            return
        }
        
        if userName.isEmail == false && userName.isPhoneNum == false {
            completionHandler?(.Failure(.UserNameErr))
            return
        }
        
        if passwd.isEmpty {
            completionHandler?(.Failure(.PassWdNil))
            return
        }
        
        guard passwordCheck(passwd) else {
            completionHandler?(.Failure(.PassWdErr))
            return
        }
        
        let parameters = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SignIn.rawValue,
                          UserNetRequsetKey.UserName.rawValue: userName,
                          UserNetRequsetKey.Passwd.rawValue: passwd.md5()]
        
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: completionHandler)
        
    }

    /**
     查询用户信息
     
     - parameter parameters:        UserId
     - parameter completionHandler: 回调
     */
    func queryProfile(parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {

        if parameters == nil {

            completionHandler?(.Failure(.ParaNil))
            Log.error("Parameters is nil")
            return

        }

        guard let _ = parameters![UserNetRequsetKey.UserID.rawValue] else {

            completionHandler?(.Failure(.UserIdNil))
            Log.error("User id is nil")
            return

        }

        var para = parameters
        para![UserNetRequsetKey.Cmd.rawValue] = UserNetRequestMethod.UserProfile.rawValue

        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: completionHandler)

    }

    /**
     设置用户信息
     
     - parameter parameters:        NickName， PhoneNum， Sex， Height， Weight， Birthday， Address
     - parameter completionHandler: 回调
     */
    func setProfile(parameters: [String: AnyObject]?, completionHandler: CompletionHandlernType?) {

        if parameters == nil {

            completionHandler?(.Failure(.ParaNil))
            Log.error("Parameters is nil")
            return

        }

        guard let _ = parameters![UserNetRequsetKey.UserID.rawValue] else {

            completionHandler?(.Failure(.ParaNil))
            Log.error("Parameters is nil")
            return

        }

        if !(parameters!.keys.contains(UserNetRequsetKey.NickName.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Sex.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Height.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Weight.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Birthday.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Address.rawValue)) {

            completionHandler?(.Failure(.ParaErr))
            Log.error("Parameters error")
            return

        }
        

        var para = parameters
        para![UserNetRequsetKey.Cmd.rawValue] = UserNetRequestMethod.SetUserProfile.rawValue

        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: completionHandler)

    }
    
    /**
     用户有效性校验
     
     - parameter userName: 用户名
     
     - returns: 用户名有效返回 true，否则 false
     */
    func passwordCheck(passwd: String) -> Bool {

        
        if passwd.length < 6 || passwd.length > 16 {
            Log.error("Password error")
            return false
        }
        
        return true
        
    }
    
    /**
     检查手机验证码是否有效
     
     - parameter securityCode: 验证码
     
     - returns: true 有效，false 无效
     */
    func phoneSecurityCodeCheck(securityCode: String) -> (Bool, UserRequestErrorType?) {

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
    func forgotPasswd(userName: String, passwd: String, safetyCode: String, completionHandler: CompletionHandlernType?) {
        
        if userName.isPhoneNum == false && userName.isEmail == false {
            completionHandler?(.Failure(.UserNameErr))
            Log.error("User name is error")
            return
        }
        
        guard passwordCheck(passwd) else {
            
            completionHandler?(.Failure(.PassWdErr))
            Log.error("Passwrod is error")
            return
            
        }
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.ForgotPwd.rawValue,
                                               UserNetRequsetKey.UserName.rawValue: userName,
                                               UserNetRequsetKey.SecurityCode.rawValue: safetyCode,
                                               UserNetRequsetKey.Passwd.rawValue: passwd.md5()]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: completionHandler)
        
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
        
        guard let phoneNum = para[UserNetRequsetKey.PhoneNum.rawValue] as? String else {
            
            Log.error("Phone num error")
            completionHandler?(.Failure(.PhoneNil))
            return

        }
        
        if phoneNum.isEmpty {
            
            Log.error("Phone num is nil")
            completionHandler?(.Failure(.PhoneNil))
            return
        }
        
        if phoneNum.isPhoneNum != true {
            
            Log.error("")
            completionHandler?(.Failure(.PhoneErr))
            return
            
        }

        para[UserNetRequsetKey.Cmd.rawValue] = UserNetRequestMethod.SendSecurityCode.rawValue
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: completionHandler)
        
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
        para[UserNetRequsetKey.Cmd.rawValue] = UserNetRequestMethod.UpdateAvatar.rawValue
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: completionHandler)
        
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
