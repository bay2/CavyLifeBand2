//
//  ContactsViewControllerPresenter.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ContactsReqFriendViewControllerDataSource {
    
    var placeholderText: String { get }
    var textFieldTitle: String { get }
    
    var bottonTitle: String { get }
    
}

protocol ContactsReqFriendViewControllerDelegate {
    
    var verifyMsg: String { set get }
    func onClickButton()
    
}

protocol ContactsReqFriendDeleteItemDelegate {
    
    var viewController: UIViewController { get }
    var firendId: String  { get }
    var rowIndex: Int { get }
    
    func changeRequestBtnName(button: UIButton)
    
}

extension ContactsReqFriendDeleteItemDelegate {
    
    /**
     cell 添加按钮回调
     
     - parameter button: 按钮
     */
    func changeRequestBtnName(button: UIButton) {
        
        let friendReqVM =  ContactsFriendReqViewModel(viewController: viewController, friendId: firendId) {
            
            let userInfo: [NSObject: Int] = ["rowIndex": self.rowIndex]
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.ContactsFirendReqDeleteItem.rawValue, object: nil, userInfo: userInfo)
            
        }
        
        let addFirendVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        
        addFirendVC.viewConfig(friendReqVM, delegate: friendReqVM)
        
        viewController.pushVC(addFirendVC)
        
    }
    
}
