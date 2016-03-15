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
    var viewController: UIViewController? { get }
    func signIn(callBack: ((Bool) -> Void)?)
    
}

extension SignInDelegate {

    func signIn(callBack: ((Bool) -> Void)?) {

        let para = [UserNetRequsetKey.UserName.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd]

        userNetReq.requestSignIn(para) { (result) -> Void in

            if result.isFailure {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                callBack?(false)
                return
            }

            let msg: UserSignUpMsg = try! UserSignUpMsg(JSONDecoder(result.value!))

            if msg.commonMsg?.code != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.commonMsg!.code!)
                callBack?(false)
                return
            }

            let defaults = NSUserDefaults.standardUserDefaults()

            defaults["userName"] = self.userName
            defaults["passwd"] = self.passwd
            defaults.synchronize()

            Log.info("Sign in succeess")
            callBack?(true)

        }

        return
        
    }
    
}

/**
 *  登录代理
 */
protocol SignUpDelegate {

    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    var viewController: UIViewController? { get }

    func emailSignUp(callBack: ((Bool) -> Void)?)
    func phoneSignUp(callBack: ((Bool) -> Void)?)
    func signUp(para: [String: AnyObject], callBack: ((Bool) -> Void)?)

}

extension SignUpDelegate {

    func emailSignUp(callBack: ((Bool) -> Void)? = nil) {

        let para = [UserNetRequsetKey.Email.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        signUp(para, callBack: callBack)

    }

    func phoneSignUp(callBack: ((Bool) -> Void)? = nil) {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        signUp(para, callBack: callBack)

    }

    func signUp(para: [String: AnyObject], callBack: ((Bool) -> Void)? = nil) {

        userNetReq.requestSignUp(para) { (result) -> Void in

            if result.isFailure {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                callBack?(false)
                return
            }

            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))

            if msg.code! != WebApiCode.Success.rawValue {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
                callBack?(false)
                return
            }


            callBack?(true)
            Log.info("Sign up success")

        }

    }

}

protocol ForgotPasswordDelegate {

    var userName: String { get }
    var passwd: String { get }
    var safetyCode: String { get }
    var viewController: UIViewController? { get }
    func forgotPwd(para: [String: AnyObject], callBack: ((Bool) -> Void)?)
    func emailForgotPwd(callBack: ((Bool) -> Void)?)
    func phoneForgotPwd(callBack: ((Bool) -> Void)?)

}

extension ForgotPasswordDelegate {

    func forgotPwd(para: [String: AnyObject], callBack: ((Bool) -> Void)? = nil) {

        userNetReq.forgotPasswd(para) { (result) in

            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                callBack?(false)
                return
            }

            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
                callBack?(false)
                return
            }

            callBack?(true)
            Log.info("Forgot password success")

        }

    }

    /**
    手机找回密码
    */
    func phoneForgotPwd(callBack: ((Bool) -> Void)? = nil) {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        forgotPwd(para, callBack: callBack)

    }

    /**
     邮箱找回密码
     */
    func emailForgotPwd(callBack: ((Bool) -> Void)? = nil) {

        let para = [UserNetRequsetKey.Email.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        forgotPwd(para, callBack: callBack)
    }

}

protocol SendSafetyCodeDelegate {

    var userName: String { get }
    var viewController: UIViewController? { get }
    func sendSafetyCode(callBack: ((Bool) -> Void)?)

}

extension SendSafetyCodeDelegate {

    func sendSafetyCode(callBack: ((Bool) -> Void)? = nil) {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName]

        userNetReq.requestPhoneSecurityCode(para) { (result) in

            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                callBack?(false)
                return
            }

            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
                callBack?(false)
                return
            }

            callBack?(true)

        }

    }

}

