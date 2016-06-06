//
//  ContactsAddFriendViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions


/// 添加好友协议集
typealias ContactsAddFriendPortocols = protocol<ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate, SwitchAddFirendReqView>

/// 添加完好友后删除tableview的好友cell
typealias ContactsAddFriendDelItemPortocols = protocol<ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate, ContactsReqFriendDeleteItemDelegate>

/// 新的朋友 协议集
typealias ContactsNewFriendPortocols = protocol<ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate>

/// 好友请求 协议集
typealias ContactsReqFriendPortocols = protocol<ContactsReqFriendViewControllerDelegate, ContactsReqFriendViewControllerDataSource>

struct ContactsRecommendCellViewModel: ContactsAddFriendDelItemPortocols {
    
    var viewController: UIViewController
    
    var friendId: String
    
    var headImageUrl: String
    
    var name: String
    
    var introudce: String { return "" }
    
    var rowIndex: Int
    
    init(viewController: UIViewController, rowIndex: Int, friendId: String = "", name: String = "", headImageUrl: String = "") {
        
        self.viewController = viewController
        self.friendId = friendId
        self.name = name
        self.headImageUrl = headImageUrl
        self.rowIndex = rowIndex
        
    }
    
    func clickCellBtn(sender: UIButton) {
        self.clickBtn(sender)
    }
    
}

/**
 *  @author xuemincai
 *
 *  添加好友 cell ViewModel
 */
struct ContactsAddFriendCellViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var friendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return "" }
    
    
    init(viewController: UIViewController, friendId: String = "", name: String = "", headImageUrl: String = "") {
        
        self.viewController = viewController
        self.friendId = friendId
        self.name = name
        self.headImageUrl = headImageUrl
        
    }
    
    func clickCellBtn(sender: UIButton) {
        self.pushFirendReqView?()
    }
    
}

/**
 *  @author xuemincai
 *
 *  通信录好友 cell ViewModel
 */
struct ContactsAddressBookViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var friendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    init(viewController: UIViewController, friendId: String = "", name: String = "", introudce: String = "", headImageUrl: String = "") {
        
        self.name = name
        self.headImageUrl = headImageUrl
        self.viewController = viewController
        self.friendId = friendId
        self.introudce = introudce
        
    }
    
    func clickCellBtn(sender: UIButton) {
        self.pushFirendReqView?()
    }
    
}

/**
 *  @author xuemincai
 *
 *  附近好友 cell ViewModel
 */
struct ContactsNearbyCellViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var friendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    init(viewController: UIViewController, name: String = "", friendId: String = "", headImageUrl: String = "", introudce: String = "") {
        
        self.name = name
        self.headImageUrl = headImageUrl
        self.friendId = friendId
        self.viewController = viewController
        self.introudce = introudce
        
    }
    
    func clickCellBtn(sender: UIButton) {
        self.pushFirendReqView?()
    }
    
}

/**
 *  @author xuemincai
 *
 *  新朋友 cell ViewModel
 */
struct ContactsNewFriendCellViewModel: ContactsNewFriendPortocols {
    
    var viewController: UIViewController
    
    var friendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    // 请求按钮 title
    var bottonTitle: String { return L10n.ContactsListCellAgree.string}
    
    // 按钮颜色
    var btnBGColor: UIColor { return UIColor(named: .ContactsAgreeButtonColor) }
    
    init(viewController: UIViewController, name: String = "", friendId: String = "", headImageUrl: String = "", introudce: String = "") {
        
        self.friendId = friendId
        self.name = name
        self.headImageUrl = headImageUrl
        self.introudce = introudce
        self.viewController = viewController
        
    }
    
    func clickCellBtn(sender: UIButton) {
        
        ContactsWebApi.shareApi.agreeFriend(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, friendId: friendId) {
            
            if $0.isSuccess {
                
                sender.enabled = false
                sender.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
                sender.backgroundColor = UIColor.clearColor()
                sender.setTitle(L10n.ContactsListCellAlreaydAdd.string, forState: .Normal)
                sender.setTitleColor(UIColor(named: .FColor), forState: .Normal)
                
            }
        }
    }
    
}

/**
 *  请求添加好友
 */
struct ContactsFriendReqViewModel: ContactsReqFriendPortocols {
    
    var textFieldTitle: String = L10n.ContactsRequestVerifyMsg.string + CavyDefine.userNickname
    
    var placeholderText: String {
        return L10n.ContactsRequestPlaceHolder.string
    }
    
    var bottonTitle: String {
        return L10n.ContactsRequestSendButton.string
    }
    
    var navTitle: String = L10n.ContactsTitle.string
    
    var friendId: String
    
    var viewController: UIViewController
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (Void -> Void)?
    
    init(viewController: UIViewController, friendId: String, onClickButtonCellBack: (Void -> Void)? = nil) {
        
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
            
            self.onClickButtonCellBack?()
            
            self.viewController.popVC()
            
        }
        
        ContactsWebApi.shareApi.addFriend(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, friendId: friendId, verifyMsg: textFieldTitle, callBack: msgParse)
        
    }
    
}
