//
//  ContactsAddFriendViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy

extension ContactsAddFriendCellDelegate {
    
    // 名字字体颜色
    var nameTextColor: UIColor { return UIColor(named: .ContactsName) }
    
    // 名字字体大小
    var nameFont: UIFont { return UIFont.systemFontOfSize(16) }
    
    // 副标题字体颜色
    var introductTextColor: UIColor { return UIColor(named: .ContactsIntrouduce) }
    
    // 副标题字体大小
    var introduceFont: UIFont { return UIFont.systemFontOfSize(12) }
    
    // 按钮颜色
    var requestBtnColor: UIColor { return UIColor(named: .ContactsAddFriendButtonColor) }
    
    // 按钮字体大小
    var requestBtnFont: UIFont { return UIFont.systemFontOfSize(14) }
    
    // 按钮title
    var requestBtnTitle: String { return L10n.ContactsListCellAdd.string }
    
}

/**
 *  切换到添加好友页面
 */
protocol SwitchAddFirendReqView {
    
    var viewController: UIViewController { get }
    var firendId: String { get }
    
    var pushFirendReqView: ((Void) -> Void)? { get }
    
}

extension SwitchAddFirendReqView {
    
    var pushFirendReqView: ((Void) -> Void)? { return {
        
        let addFirendVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        
        let firendReqViewModel = ContactsFriendReqViewModel(viewController: addFirendVC, friendId: self.firendId)
        
        addFirendVC.viewConfig(firendReqViewModel, delegate: firendReqViewModel)
            
        self.viewController.pushVC(addFirendVC)
        
        }
    }
    
}

typealias ContactsAddFriendPortocols = protocol<ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate, SwitchAddFirendReqView>

/**
 *  @author xuemincai
 *
 *  添加好友 cell ViewModel
 */
struct ContactsAddFriendCellViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var firendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return "" }
    
    // 按钮回调
    var changeRequestBtnName: ((UIButton) -> Void)?
    
    init(viewController: UIViewController, firendId: String = "", name: String = "", headImageUrl: String = "") {
        
        self.viewController = viewController
        self.firendId = firendId
        self.name = name
        self.headImageUrl = headImageUrl
        
        changeRequestBtnName = { _ in
            self.pushFirendReqView?()
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  通信录好友 cell ViewModel
 */
struct ContactsAddressBookViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var firendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    // 按钮回调
    var changeRequestBtnName: ((UIButton) -> Void)?
    
    init(viewController: UIViewController, firendId: String = "", name: String = "", introudce: String = "", headImageUrl: String = "") {
        
        self.name = name
        self.headImageUrl = headImageUrl
        self.viewController = viewController
        self.firendId = firendId
        self.introudce = introudce
        
        changeRequestBtnName = { _ in
            self.pushFirendReqView?()
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  附近好友 cell ViewModel
 */
struct ContactsNearbyCellViewModel: ContactsAddFriendPortocols {
    
    var viewController: UIViewController
    
    var firendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    // 按钮回调
    var changeRequestBtnName: ((UIButton) -> Void)?
    
    init(viewController: UIViewController, name: String = "", firendId: String = "", headImageUrl: String = "", introudce: String = "") {
        
        self.name = name
        self.headImageUrl = headImageUrl
        self.firendId = firendId
        self.viewController = viewController
        self.introudce = introudce
        
        changeRequestBtnName = { _ in
            self.pushFirendReqView?()
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  新朋友 cell ViewModel
 */
struct ContactsNewFriendCellViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate {
    
    var viewController: UIViewController
    
    var firendId: String
    
    // 头像
    var headImageUrl: String
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String
    
    // 请求按钮 title
    var requestBtnTitle: String { return L10n.ContactsListCellAgree.string}
    
    // 按钮颜色
    var requestBtnColor: UIColor { return UIColor(named: .ContactsAgreeButtonColor) }
    
    // 按钮回调
    var changeRequestBtnName: ((UIButton) -> Void)?
    
    init(viewController: UIViewController, name: String = "", firendId: String = "", headImageUrl: String = "", introudce: String = "") {
        
        self.firendId = firendId
        self.name = name
        self.headImageUrl = headImageUrl
        self.introudce = introudce
        self.viewController = viewController
        
        changeRequestBtnName = {
            
            $0.enabled = false
            $0.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
            $0.backgroundColor = UIColor.clearColor()
            $0.setTitle(L10n.ContactsListCellAlreaydAdd.string, forState: .Normal)
            $0.setTitleColor(UIColor(named: .ContactsIntrouduce), forState: .Normal)
            
        }
        
    }
    
}

/**
 *  请求添加好友
 */
struct ContactsFriendReqViewModel: ContactsReqFriendViewControllerDelegate, ContactsReqFriendViewControllerDataSource {
    
    var textFieldTitle: String {
        return L10n.ContactsRequestVerifyMsg.string + CavyDefine.userNickname
    }
    
    var placeholderText: String {
        return L10n.ContactsRequestPlaceHolder.string
    }
    
    var bottonTitle: String {
        return L10n.ContactsRequestSendButton.string
    }
    
    var verifyMsg: String = L10n.ContactsRequestVerifyMsg.string + CavyDefine.userNickname
    
    var friendId: String
    
    var viewController: UIViewController
    
    init(viewController: UIViewController, friendId: String) {
        
        self.viewController = viewController
        self.friendId = friendId
        
    }
    
    func onClickButton() {
        
        let msgParse: CompletionHandlernType = {
            
            guard $0.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: $0.error)
                return
            }
            
            let resultMsg: CommenMsg = try! CommenMsg(JSONDecoder($0.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                return
            }
            
        }
        
        ContactsWebApi.shareApi.addFriend(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, friendId: friendId, verifyMsg: verifyMsg, callBack: msgParse)
        
    }
    
}
