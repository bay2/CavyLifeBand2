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

// 注册 ViewModel
struct SignUpViewModel {

    var userName: String
    var passwd: String
    var safetyCode: String
    var viewController: UIViewController
    var succeedCallBack: (Void -> Void)?

    init(viewController: UIViewController, userName: String, passwd: String, safetyCode: String, callBack: (Void -> Void)? = nil) {
        self.userName = userName
        self.passwd = passwd
        self.safetyCode = safetyCode
        self.viewController = viewController
        succeedCallBack = callBack
    }
    
    /**
     注册
     
     - parameter para: 参数
     */
    private func userSignUp(para: [String: AnyObject]) {
        
        userNetReq.requestSignUp(para) { (result) -> Void in
            
            if result.isFailure {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                return
            }
            
            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            
            if msg.code! != WebApiCode.Success.rawValue {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
                return
            }
            

            self.succeedCallBack?()
            Log.info("Sign up success")
            
            let signInVm = SignInViewModel(viewController: self.viewController, userName: self.userName, passwd: self.passwd) {
                UserInfoModelView.shareInterface.updateInfo(userId: $0)
            }
            signInVm.userSignIn()
        }
    }

    /**
     手机注册
     */
    func phoneSignUp() {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        userSignUp(para)

    }

    /**
     邮箱注册
     */
    func emailSignUp() {
        
        let para = [UserNetRequsetKey.Email.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        userSignUp(para)
    }
    
}

// 登录 ViewModel
struct SignInViewModel {

    var userName: String
    var passwd: String
    var viewController: UIViewController
    var succeedCallBack: (String -> Void)?

    init(viewController: UIViewController, userName: String, passwd: String, callBack: (String -> Void)? = nil) {

        self.userName = userName
        self.passwd = passwd
        self.viewController = viewController
        self.succeedCallBack = callBack
    }

    /**
     用户登录
     */
    func userSignIn() -> Void {

        let para = [UserNetRequsetKey.UserName.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd]

        userNetReq.requestSignIn(para) { (result) -> Void in

            if result.isFailure {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                return
            }

            let msg: UserSignUpMsg = try! UserSignUpMsg(JSONDecoder(result.value!))

            if msg.commonMsg?.code != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.commonMsg!.code!)
                return
            }

            let defaults = NSUserDefaults.standardUserDefaults()

            defaults["userName"] = self.userName
            defaults["passwd"] = self.passwd
            defaults.synchronize()

            self.succeedCallBack?(msg.userId!)
            Log.info("Sign in succeess")

        }

    }


}

// 找回密码 ViewModel
struct ForgotPasswordViewModel{

    var userName: String
    var passwd: String
    var safetyCode: String
    var viewController: UIViewController
    var succeedCallBack: (Void -> Void)?

    init(viewController: UIViewController, userName: String, passwd: String, safetyCode: String, callBack: (Void -> Void)? = nil) {

        self.userName = userName
        self.passwd = passwd
        self.safetyCode = safetyCode
        self.viewController = viewController
        succeedCallBack = callBack
    }

    /**
     找回密码

     - parameter para: 参数
     */
    private func userForgotPwd(para: [String: AnyObject]) {

        userNetReq.forgotPasswd(para) { (result) in

            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                return
            }

            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
                return
            }

            Log.info("Forgot password success")

        }

    }

   /**
     手机找回密码
     */
    func phoneForgotPwd() {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        userForgotPwd(para)

    }

    /**
     邮箱找回密码
     */
    func emailForgotPwd() {

        let para = [UserNetRequsetKey.Email.rawValue: userName, UserNetRequsetKey.Passwd.rawValue: passwd, UserNetRequsetKey.SecurityCode.rawValue: safetyCode]
        userForgotPwd(para)
    }

}

// 发送验证码
struct SendSafetyCodeViewModel {
    
    var viewController: UIViewController
    var userName: String
    var succeedCallBack: (Void -> Void)?
    var button: UIButton?
    
    init(viewController: UIViewController, button: UIButton, userName: String, callBack: (Void -> Void)? = nil){
        
        self.userName = userName
        self.succeedCallBack = callBack
        self.viewController = viewController
        
    }

    /**
     发送验证码
     */
    func sendSafetyCode() {

        let para = [UserNetRequsetKey.PhoneNum.rawValue: userName]
        

        userNetReq.requestPhoneSecurityCode(para) { (result) in

            if result.isFailure {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error!)
                self.button?.enabled = true
                return
            }

            let msg: CommenMsg = try! CommenMsg(JSONDecoder(result.value!))
            if msg.code! != WebApiCode.Success.rawValue {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: msg.code!)
            }

            self.succeedCallBack?()

        }

    }
    
 }
