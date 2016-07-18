//
//  CavyLifeBandAlertView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import EZSwiftExtensions

class CavyLifeBandAlertView {

    static let sharedIntance = CavyLifeBandAlertView()

    /**
     显示信息提示
     
     - parameter title:   <#title description#>
     - parameter message: <#message description#>
     */
    func showViewTitle(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, title: String = "", message: String) {

        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)

        alertView.addAction(defaultAction)
    
        viewController?.presentViewController(alertView, animated: true, completion: nil)

    }
    
    /**
     显示信息提示 不带操作按钮
     
     - parameter viewController:
     - parameter title:
     - parameter message:
     */
    func showViewTitleWithoutAction(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, title: String = "", message: String) -> UIAlertController {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        viewController?.presentViewController(alertView, animated: true, completion: nil)
        
        return alertView
    }

    /**
     通过用户错误码提示错误信息
     
     - parameter userErrorCode:
     */
    func showViewTitle(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, userErrorCode: UserRequestErrorType?) {
        
        let userError = userErrorCode ?? UserRequestErrorType.UnknownError
        
        showViewTitle(viewController, message: userError.description)
        
    }
    
    /**
     通过用户错误码提示错误信息 不带操作按钮
     
     - parameter userErrorCode:
     */
    func showViewTitleWithoutAction(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, userErrorCode: UserRequestErrorType?) -> UIAlertController {
        
        let userError = userErrorCode ?? UserRequestErrorType.UnknownError
        
        return showViewTitleWithoutAction(viewController, message: userError.description)
        
    }

    /**
     通过web返回错误码提示错误信息
     
     - parameter webApiErrorCode:
     */
    func showViewTitle(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, webApiErrorCode: String) {

        showViewTitle(viewController, message: WebApiCode(apiCode: webApiErrorCode).description)

    }
    
    /**
     通过web返回错误码提示错误信息 不带操作按钮
     
     - parameter webApiErrorCode:
     */
    func showViewTitleWithoutAction(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, webApiErrorCode: String) -> UIAlertController {
        
        return showViewTitleWithoutAction(viewController, message: WebApiCode(apiCode: webApiErrorCode).description)
        
    }
    
    /**
     通过web返回错误码提示错误信息:Get方法的API
     
     - parameter webGetApiErrorCode: 
     */
    func showViewTitle(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, webGetApiErrorCode: String) {
        
        showViewTitle(viewController, message: WebGetApiCode(apiCode: webGetApiErrorCode).description)
        
    }
    
    /**
     通过web返回错误码提示错误信息:Get方法的API 不带操作按钮
     
     - parameter webGetApiErrorCode:
     */
    func showViewTitleWithoutAction(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController, webGetApiErrorCode: String) -> UIAlertController {
        
        return showViewTitleWithoutAction(viewController, message: WebGetApiCode(apiCode: webGetApiErrorCode).description)
        
    }

}
