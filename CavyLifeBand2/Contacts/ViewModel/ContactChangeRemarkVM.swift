//
//  ContactChangeRemarkVM.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions


/**
 *  修改备注
 */
struct ContactsChangeRemarkViewModel: ContactsReqFriendPortocols {
    
    var navTitle: String = L10n.ContactsNavTitleRemark.string
    
    var textFieldTitle: String = ""
    
    var placeholderText: String {
        return L10n.ContactsChangeNotesNamePlaceHolder.string
    }
    
    var bottonTitle: String {
        return L10n.ContactsRequestSureButton.string
    }
    
    var friendId: String
    
    var viewController: UIViewController
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (String -> Void)?
    
    init(viewController: UIViewController, friendId: String, onClickButtonCellBack: (String -> Void)? = nil) {
        
        self.viewController = viewController
        self.friendId = friendId
        self.onClickButtonCellBack = onClickButtonCellBack
        
    }
    
    func onClickButton() {
        
        let msgParse: CompletionHandlernType = {
            
            guard $0.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: $0.error)
                return
            }
            
            let resultMsg: CommenMsg = try! CommenMsg(JSONDecoder($0.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: resultMsg.code ?? "")
                return
            }
            
            self.onClickButtonCellBack?(self.textFieldTitle)
            
            self.viewController.popVC()
            
        }
        
        ContactsWebApi.shareApi.setFriendRemark(friendId: friendId, remark: textFieldTitle, callBack: msgParse)
        
    }
    
}
