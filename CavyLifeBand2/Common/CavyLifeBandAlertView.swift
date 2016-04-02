//
//  CavyLifeBandAlertView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit

class CavyLifeBandAlertView {

    static let sharedIntance = CavyLifeBandAlertView()


    /**
     显示信息提示
     
     - parameter title:   <#title description#>
     - parameter message: <#message description#>
     */
   func showViewTitle(viewController: UIViewController?, title: String = "", message: String) {

        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)

        alertView.addAction(defaultAction)

       viewController?.presentViewController(alertView, animated: true, completion: nil)

    }

    /**
     通过用户错误码提示错误信息
     
     - parameter userErrorCode:
     */
    func showViewTitle(viewController: UIViewController?, userErrorCode: UserRequestErrorType) {

        let errorMessage = [UserRequestErrorType.EmailErr: L10n.UserModuleErrorCodeEmailError.string,
        UserRequestErrorType.EmailNil: L10n.UserModuleErrorCodeEmailNil.string,
        UserRequestErrorType.NetAPIErr: L10n.UserModuleErrorCodeNetAPIError.string,
        UserRequestErrorType.NetErr: L10n.UserModuleErrorCodeNetAPIError.string,
        UserRequestErrorType.PassWdErr: L10n.UserModuleErrorCodePasswdError.string,
        UserRequestErrorType.PassWdNil: L10n.UserModuleErrorCodePasswdNil.string,
        UserRequestErrorType.PhoneNil: L10n.UserModuleErrorCodePhoneNil.string,
        UserRequestErrorType.PhoneErr: L10n.UserModuleErrorCodePhoneError.string,
        UserRequestErrorType.SecurityCodeErr: L10n.UserModuleErrorCodeSecurityError.string,
        UserRequestErrorType.SecurityCodeNil: L10n.UserModuleErrorCodeSecurityNil.string,
        UserRequestErrorType.UserNameErr: L10n.UserModuleErrorCodeUserNameError.string,
        UserRequestErrorType.UserNameNil: L10n.UserModuleErrorCodeUserNameNil.string]

        showViewTitle(viewController, title: "", message: errorMessage[userErrorCode]!)

    }

    /**
     通过web返回错误码提示错误信息
     
     - parameter webApiErrorCode:
     */
    func showViewTitle(viewController: UIViewController?, webApiErrorCode: String) {

        let errorMessage = [WebApiCode.ParaError.rawValue: L10n.WebErrorCode1000.string,
        WebApiCode.UserPasswdError.rawValue: L10n.WebErrorCode1001.string,
        WebApiCode.PhoneNumError.rawValue: L10n.WebErrorCode1002.string,
        WebApiCode.SecurityCodeError.rawValue: L10n.WebErrorCode1003.string,
        WebApiCode.MobifyUserError.rawValue: L10n.WebErrorCode1004.string,
        WebApiCode.UserExisted.rawValue: L10n.WebErrorCode1005.string,
        WebApiCode.UserNotExisted.rawValue: L10n.WebErrorCode1006.string,
        WebApiCode.SendSecutityCodeError.rawValue: L10n.WebErrorCode1007.string]

        if let message = errorMessage[webApiErrorCode] {

            showViewTitle(viewController, title: "", message: message)

        } else {

            showViewTitle(viewController, title: "", message: L10n.UserModuleErrorCodeNetAPIError.string)

        }

    }
    


}
