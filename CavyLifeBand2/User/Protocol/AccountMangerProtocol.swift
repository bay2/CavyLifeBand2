//
//  AccountMangerProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import Log
import Log.Swift



/**
 *  @author xuemincai
 *
 *  注册\忘记密码视图样式
 */
protocol AccountManagerViewDataSource {
    
    var isSignUp: Bool { get }
    var navTitle: String { get }
    var itemRightTitle: String { get }
    var userNameTextFieldTitle: String { get }
    var passwdTextFieldTitle: String { get }
    var viewMainBtnTitle: String { get }
    var isEmail: Bool { get }
    
}

/**
 *  @author xuemincai
 *
 *  找回密码
 */
protocol ForgotPasswordDelegate {
    
    var isEmail: Bool { get }
    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    var popToViewController: UIViewController { get }
    func forgotPwd()
    
}

// MARK: - 找回密码协议扩展
extension ForgotPasswordDelegate where Self: UIViewController {
    
    func forgotPwd() {

        if userName.isEmpty && isEmail {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .EmailNil)
            return
        } else if userName.isEmpty {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .PhoneNil)
            return
        }

        UserNetRequestData.shareApi.forgotPasswd(userName, passwd: passwd, safetyCode: safetyCode) { result in
            
            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error ?? UserRequestErrorType.UnknownError)
                return
            }
            
            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.code)
                return
            }
            
            Log.info("Forgot password success")
            
            self.navigationController?.popToViewController(self.popToViewController, animated: true)
            
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  发送验证码
 */
protocol SendSafetyCodeDelegate {
    
    var userName: String { get }
    func sendSafetyCode()
    var sendSafetyCodeBtn: SendSafetyCodeButton { get }
    
}

// MARK: - 发送验证码协议扩展
extension SendSafetyCodeDelegate where Self: UIViewController {
    
    func sendSafetyCode() {
        
        sendSafetyCodeBtn.enabled = false
        
        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName]
        
        UserNetRequestData.shareApi.requestPhoneSecurityCode(para) { (result) in
            
            self.sendSafetyCodeBtn.enabled = true
            
            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error ?? UserRequestErrorType.UnknownError)
                return
            }
            
            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.code)
                return
            }
            
            self.sendSafetyCodeBtn.countDown()
            
        }
        
    }
    
}

/**
 *  注册
 */
protocol SignUpDelegate {
    
    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    
    func signUp(callBack: (String -> Void)?)
    
}

// MARK: - 注册协议扩展
extension SignUpDelegate where Self: UIViewController {
    
    
    func signUp(callBack: (String -> Void)? = nil) {
        
        UserNetRequestData.shareApi.requestSignUp(userName, safetyCode: safetyCode, passwd: passwd) { result in
            
            if result.isFailure {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error ?? UserRequestErrorType.UnknownError)
                return
            }
            
            let msg: UserSignUpMsg = try! UserSignUpMsg(JSONDecoder(result.value!))
            
            if msg.commonMsg?.code != WebApiCode.Success.rawValue {
                
                //注册出现用户已存在情况需要特殊跳转流程
                if msg.commonMsg?.code == WebApiCode.UserExisted.rawValue {
                    callBack?(WebApiCode.UserExisted.rawValue)
                } else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.commonMsg?.code ?? "")
                }
                
                return
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = msg.userId ?? ""
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = self.userName
            
            Log.info("[\(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)] Sign up success")
            
            callBack?(msg.userId!)
            
            
        }
        
    }
    
}

/**
 *  登录
 */
protocol SignInDelegate {
    
    var userName: String { get }
    var passwd: String { get }
    func signIn(callBack: (Void -> Void)?)
    
}

// MARK: - 登录协议扩展
extension SignInDelegate where Self: UIViewController {
    
    func signIn(callBack: (Void -> Void)? = nil) {
        
        
        let parameters: [String: AnyObject] = [NetRequsetKey.UserName.rawValue: userName,
                                               NetRequsetKey.Password.rawValue: passwd.md5()]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.Login.description, para: parameters, modelObject: LoginResponse.self, successHandler: { (data) in
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = data.userId
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = data.userName
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken = data.authToken
            
            callBack?()
            
        }) { (msg) in
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)

        }
        
        return
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  输入参数校验
 */
protocol AccountMangerInputCheckDelegate {
    
    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    var isEmail: Bool { get }
    
    func checkInputIsNil() -> Bool
    
}

// MARK: - 输入参数校验
extension AccountMangerInputCheckDelegate where Self: UIViewController {
    
    /**
     文本输入参数校验
     
     - returns: 参数为空 false， 不为空 true
     */
    func checkInputIsNil() -> Bool {
        
        if userName.isEmpty {
            
            if isEmail {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .EmailNil)
            } else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .PhoneNil)
            }
            
            return false
        }
        
        if safetyCode.isEmpty {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .SecurityCodeNil)
            return false
        }
        
        if passwd.isEmpty {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: .PassWdNil)
            return false
        }
        
        return true
    }
    
}
