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
    var loadingView: UIActivityIndicatorView { get }
    
    /**
     ## 忘记密码 手机
     */
    func forgetPwdPhone()
    
    /**
     ## 忘记密码 邮箱
     */
    func forgetPwdEmail()
    
}

// MARK: - 找回密码协议扩展
extension ForgotPasswordDelegate where Self: UIViewController {
    
    
    
    func forgetPwdPhone() {
        
        loadingView.startAnimating()
        
        let para = [NetRequsetKey.Phone.rawValue: userName,
                    NetRequsetKey.Password.rawValue: passwd.md5(),
                    NetRequsetKey.Code.rawValue: safetyCode]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.ResetPwdPhone.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { [unowned self] (data) in
            self.loadingView.stopAnimating()
            self.navigationController?.popToViewController(self.popToViewController, animated: true)
            
        }) { (msg) in
            self.loadingView.stopAnimating()
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)
        }
        
    }
    
  
    func forgetPwdEmail() {
        
        loadingView.startAnimating()
        
        let para = [NetRequsetKey.Email.rawValue: userName,
                    NetRequsetKey.Password.rawValue: passwd.md5(),
                    NetRequsetKey.Code.rawValue: safetyCode]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.ResetPwdEmail.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { [unowned self] (data) in
            self.loadingView.stopAnimating()
            self.navigationController?.popToViewController(self.popToViewController, animated: true)
            
        }) { (msg) in
            self.loadingView.stopAnimating()
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)
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
    var sendSafetyCodeBtn: SendSafetyCodeButton { get }
    var loadingView: UIActivityIndicatorView { get }
    
    /**
     ## 邮箱注册验证码
     */
    func sendSignUpEmailCode(failBack: (CommenResponse -> Void)?)
    
    /**
     ## 手机号注册验证码
     */
    func sendSignUpPhoneCode(failBack: (CommenResponse -> Void)?)
    
    /**
     ## 忘记密码手机验证码
     */
    func sendResetPwdPhoneCode()
    
    /**
     ## 忘记密码邮箱验证码
     */
    func sendResetPwdEmailCode()
    
    /**
     检测用户名是否有效
     
     - returns:
     */
    func checkUsernameAvailable() -> Bool
    
}

// MARK: - 发送验证码协议扩展
extension SendSafetyCodeDelegate where Self: UIViewController {
    
    func checkUsernameAvailable() -> Bool {
        if userName.characters.count == 0 { return false }
        else { return true }
    }
    
    func sendSignUpEmailCode(failBack: (CommenResponse -> Void)? = nil) {
        
        loadingView.startAnimating()
        
        let para = [NetRequsetKey.Email.rawValue: userName]
        
        sendSafetyCodeBtn.enabled = false
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.SignUpEmailCode.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { [unowned self] (data) in
            
            self.loadingView.stopAnimating()
            
            self.sendSafetyCodeBtn.enabled = true
            
            self.sendSafetyCodeBtn.countDown()
            
        }) { (msg) in
            
            self.sendSafetyCodeBtn.enabled = true
            
            self.loadingView.stopAnimating()
            
            failBack?(msg)
        }
        
    }
    
    func sendSignUpPhoneCode(failBack: (CommenResponse -> Void)? = nil) {
        
        let para = [NetRequsetKey.Phone.rawValue: userName]
        loadingView.startAnimating()
        sendSafetyCodeBtn.enabled = false
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.SignUpPhoneCode.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { [unowned self] (data) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            self.sendSafetyCodeBtn.countDown()
            
        }) { (msg) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            failBack?(msg)
            
        }
    
    }
    
    func sendResetPwdPhoneCode() {
    
        let para = [NetRequsetKey.Phone.rawValue: userName]
        loadingView.startAnimating()
        sendSafetyCodeBtn.enabled = false
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.ResetPwdPhoneCode.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            self.sendSafetyCodeBtn.countDown()
            
        }) { (msg) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)
        }
        
    }
    
    func sendResetPwdEmailCode() {
        let para = [NetRequsetKey.Email.rawValue: userName]
        loadingView.startAnimating()
        sendSafetyCodeBtn.enabled = false
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.ResetPwdEmailCode.description, para: para, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            self.sendSafetyCodeBtn.countDown()
            
        }) { (msg) in
            
            self.sendSafetyCodeBtn.enabled = true
            self.loadingView.stopAnimating()
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)
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
    
    /**
     注册
     
     - parameter isEmail:     是否是邮箱注册
     - parameter successBack:
     - parameter failBack:    
     */
    func signUp(isEmail: Bool, successBack:(String -> Void)?, failBack: (CommenResponse -> Void)?)
    
}

// MARK: - 注册协议扩展
extension SignUpDelegate where Self: UIViewController {
    
    func signUp(isEmail: Bool = false, successBack:(String -> Void)? = nil, failBack: (CommenResponse -> Void)? = nil) {
        
        if isEmail {
            signUpEmial({ (data) in
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = data.userId ?? ""
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = self.userName
                
                successBack?(data.userId)
                
            }, failBack: { (msg) in
                failBack?(msg)
            })
        } else {
            signUpPhone({ (data) in
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = data.userId ?? ""
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = self.userName
                
                successBack?(data.userId)
                
            }, failBack: { (msg) in
                failBack?(msg)
            })
        }
        
    }
    
    func signUpEmial(successBack:(SignUpResponse -> Void)? = nil, failBack: (CommenResponse -> Void)? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Email.rawValue: userName,
                                               NetRequsetKey.Password.rawValue: passwd.md5(),
                                               NetRequsetKey.Code.rawValue: safetyCode]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.SignUpEmail.description, para: parameters, modelObject: SignUpResponse.self, successHandler: { data in
            
            successBack?(data)
            
        }) { (msg) in
            
            failBack?(msg)
            
        }
        
    }
    
    func signUpPhone(successBack:(SignUpResponse -> Void)? = nil, failBack: (CommenResponse -> Void)? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Phone.rawValue: userName,
                                               NetRequsetKey.Password.rawValue: passwd.md5(),
                                               NetRequsetKey.Code.rawValue: safetyCode]
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.SignUpPhone.description, para: parameters, modelObject: SignUpResponse.self, successHandler: { data in
            
            successBack?(data)
            
        }) { (msg) in
            
            failBack?(msg)
            
        }
        
    }
    
    
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
    func signIn(successBack: (Void -> Void)?, failBack: (Void -> Void)?)
    
}

// MARK: - 登录协议扩展
extension SignInDelegate where Self: UIViewController {
    
    func signIn(successBack: (Void -> Void)? = nil, failBack: (Void -> Void)? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequsetKey.UserName.rawValue: userName,
                                               NetRequsetKey.Password.rawValue: passwd.md5(),
                                               NetRequsetKey.DeviceSerial.rawValue: CavyDefine.bindBandInfos.bindBandInfo.deviceSerial]
        
        
        NetWebApi.shareApi.netPostRequest(WebApiMethod.Login.description, para: parameters, modelObject: LoginResponse.self, successHandler: { (data) in
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = data.userId
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = data.userName
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken = data.authToken

            successBack?()

        }) { (msg) in
            
            failBack?()
            
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
