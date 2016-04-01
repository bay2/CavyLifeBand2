//
//  UserModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import Alamofire
import Log
import EZSwiftExtensions


/**
 *  登录操作代理
 */
protocol SignInDelegate {

    var userName: String { get }
    var passwd: String { get }
    
}

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

            let defaults = NSUserDefaults.standardUserDefaults()
            defaults[UserDefaultsKey.SignInUserId.rawValue] = msg.userId
            defaults[UserDefaultsKey.SignUserName.rawValue] = self.userName
            
            defaults.synchronize()
            
            self.pushVC(StoryboardScene.Guide.instantiateGuideView())
            
            Log.info("Sign in succeess")
            
        }

        return
        
    }
    
}

/**
 *  注册代理
 */
protocol SignUpDelegate {

    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }

    func signUp(callBack: (String -> Void)?)

}

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

            let defaults = NSUserDefaults.standardUserDefaults()
            defaults[UserDefaultsKey.SignInUserId.rawValue] = msg.userId
            defaults[UserDefaultsKey.SignUserName.rawValue] = self.userName
            
            defaults.synchronize()
            
            Log.info("Sign up success")
            
            callBack?(msg.userId!)
            self.pushVC(StoryboardScene.Home.instantiateRootView())
            
        }

    }

}

protocol ForgotPasswordDelegate {

    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    var popToViewController: UIViewController { get }
    func forgotPwd()

}

extension ForgotPasswordDelegate where Self: UIViewController {
    
    
    func forgotPwd() {
        
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

protocol SendSafetyCodeDelegate {

    var userName: String { get }
    func sendSafetyCode()
    var sendSafetyCodeBtn: SendSafetyCodeButton { get }

}

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

protocol AccountManagerViewDataSource {
    
    var isSignUp: Bool { get }
    var navTitle: String { get }
    var itemRightTitle: String { get }
    var userNameTextFieldTitle: String { get }
    var passwdTextFieldTitle: String { get }
    var viewMainBtnTitle: String { get }
}


struct PhoneSignUpViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return true }
    var navTitle: String { return L10n.SignUpTitle.string }
    var itemRightTitle: String { return L10n.SignUpPhoneRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpPhoneNumTextField.string }
    var passwdTextFieldTitle: String { return L10n.SignInPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.SignUpSignUpBtn.string }
    
}

struct EmailSignUpViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return true }
    var navTitle: String { return L10n.SignUpTitle.string }
    var itemRightTitle: String { return L10n.SignUpEmailRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpEmailTextField.string }
    var passwdTextFieldTitle: String { return L10n.SignInPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.SignUpSignUpBtn.string }
    
}

struct PhoneForgotPwdViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return false }
    var navTitle: String { return L10n.ForgotTitle.string }
    var itemRightTitle: String { return L10n.SignUpPhoneRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpPhoneNumTextField.string }
    var passwdTextFieldTitle: String { return L10n.ForgotPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.ForgotFinish.string }
    
}

