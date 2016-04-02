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

        userNetReq.forgotPasswd(userName, passwd: passwd, safetyCode: safetyCode) { result in
            
            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error!)
                return
            }
            
            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.code!)
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
        
        userNetReq.requestPhoneSecurityCode(para) { (result) in
            
            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error!)
                return
            }
            
            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.code!)
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
        
        userNetReq.requestSignUp(userName, safetyCode: safetyCode, passwd: passwd) { result in
            
            if result.isFailure {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error!)
                return
            }
            
            let msg: UserSignUpMsg = try! UserSignUpMsg(JSONDecoder(result.value!))
            
            if msg.commonMsg?.code! != WebApiCode.Success.rawValue {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.commonMsg!.code!)
                return
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = msg.userId ?? ""
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = self.userName
            
            Log.info("Sign up success")
            
            callBack?(msg.userId!)
            self.pushVC(StoryboardScene.Home.instantiateRootView())
            
        }
        
    }
    
}

/**
 *  登录
 */
protocol SignInDelegate {
    
    var userName: String { get }
    var passwd: String { get }
    
}

// MARK: - 登录协议扩展
extension SignInDelegate where Self: UIViewController {
    
    func signIn() {
        
        userNetReq.requestSignIn(userName, passwd: passwd) { result in
            
            if result.isFailure {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error!)
                return
            }
            
            let msg: UserSignUpMsg = try! UserSignUpMsg(JSONDecoder(result.value!))
            
            if msg.commonMsg?.code != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: msg.commonMsg!.code!)
                return
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = msg.userId ?? ""
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = self.userName
            
            self.pushVC(StoryboardScene.Guide.instantiateGuideView())
            
            Log.info("Sign in succeess")
            
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
