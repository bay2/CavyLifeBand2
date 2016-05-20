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
    case NetErr, NetAPIErr, ParaNil, ParaErr, EmailErr, EmailNil, PhoneErr, PhoneNil, PassWdErr, PassWdNil, SecurityCodeErr, SecurityCodeNil, UserNameErr, UserNameNil, UserIdNil, SearchTypeNil, LBSNil, PhoneNumListNil, FriendIdNil, UnknownError
}

extension UserRequestErrorType: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .NetErr:
            return L10n.UserModuleErrorCodeNetError.string
        case .NetAPIErr:
            return L10n.UserModuleErrorCodeNetAPIError.string
        case .ParaNil:
            return L10n.UserModuleErrorCodeParaNil.string
        case .ParaErr:
            return L10n.UserModuleErrorCodeParaError.string
        case .EmailErr:
            return L10n.UserModuleErrorCodeEmailError.string
        case.EmailNil:
            return L10n.UserModuleErrorCodeEmailNil.string
        case .PhoneErr:
            return L10n.UserModuleErrorCodePhoneError.string
        case .PhoneNil:
            return L10n.UserModuleErrorCodePhoneNil.string
        case .PassWdErr:
            return L10n.UserModuleErrorCodePasswdError.string
        case .PassWdNil:
            return L10n.UserModuleErrorCodePasswdNil.string
        case .SecurityCodeErr:
            return L10n.UserModuleErrorCodeSecurityError.string
        case .SecurityCodeNil:
            return L10n.UserModuleErrorCodeSecurityNil.string
        case .UserNameErr:
            return L10n.UserModuleErrorCodeUserNameError.string
        case .UserNameNil:
            return L10n.UserModuleErrorCodeUserNameNil.string
        case .UserIdNil:
            return L10n.UserModuleErrorCodeUserIdNil.string
        case .SearchTypeNil:
            return L10n.UserModuleErrorCodeSearchTypeNil.string
        case .LBSNil:
            return L10n.UserModuleErrorCodeLBSNil.string
        case .PhoneNumListNil:
            return L10n.UserModuleErrorCodePhoneNumListNil.string
        case .FriendIdNil:
            return L10n.UserModuleErrorCodeFriendIdNil.string
        case .UnknownError:
            return L10n.UserModuleErrorCodeUnknownError.string
        }

    }

}


class UserNetRequestData: NetRequestAdapter {
   
    static var shareApi = UserNetRequestData()
    
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
    func queryProfile(userId: String, completionHandler: CompletionHandlernType?) {
        
        if userId.isEmpty {
            completionHandler?(.Failure(.UserIdNil))
            Log.error("User id is nil")
            return
        }
        
        let parameter = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.UserProfile.rawValue,
                         UserNetRequsetKey.UserID.rawValue: userId]

        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameter, completionHandler: completionHandler)

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
            parameters!.keys.contains(UserNetRequsetKey.Address.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.UserID.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.Address.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.StepNum.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.SleepTime.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.IsNotification.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.IsLocalShare.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.IsOpenBirthday.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.IsOpenHeight.rawValue) ||
            parameters!.keys.contains(UserNetRequsetKey.IsOpenWeight.rawValue)) {

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
    func uploadPicture(userId: String, filePath: String, completionHandler: CompletionHandlernType?) {
        
        Alamofire.upload(.POST, NSURL(string: CavyDefine.updateImgAddr)!, multipartFormData: { multipartFormData in
            
            multipartFormData.appendBodyPart(fileURL: NSURL(string: filePath)!, name: UserNetRequsetKey.Avater.rawValue)
            multipartFormData.appendBodyPart(data: userId.dataUsingEncoding(NSUTF8StringEncoding)!, name: UserNetRequsetKey.UserID.rawValue)
            
            }) { encodingResult in
                
                switch encodingResult {
                    
                case .Success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON {
                        if $0.result.isFailure {
                            completionHandler?(.Failure(.NetErr))
                            Log.error("Network error")
                            return
                        }
                        
                        guard let responseResult = $0.result.value else {
                            completionHandler?(.Failure(.NetErr))
                            Log.error("Network error")
                            return
                        }
                        
                        completionHandler?(.Success(responseResult))
                    }
                    
                case .Failure(let error):
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(message: error.toString)
                    
                }
                
        }
        
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
