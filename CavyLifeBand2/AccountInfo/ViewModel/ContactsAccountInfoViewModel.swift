//
//  ContactsAccountInfoViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import Alamofire
import Log
import EZSwiftExtensions

/**
 *  账户信息
 */
protocol AccountInfoDelegate {
    
    var userId: String { get }
    var viewController: UIViewController? { get }
    
}

extension AccountInfoDelegate {
    
    
    func accountInfo(callBack: ((Bool) -> Void)? = nil) {
    
        let para = [UserNetRequsetKey.UserID.rawValue: userId]
        showAcountInfo(para, callBack: callBack)
    
    }
    
    
    func showAcountInfo(para: [String: AnyObject], callBack: ((Bool) -> Void)? = nil) {
        
        userNetReq.queryProfile(para) { (result) -> Void in
            
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
