//
//  ContactsViewControllerPresenter.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

/**
 *  请求添加好友view 数据源
 */
protocol ContactsReqFriendViewControllerDataSource {
    
    var placeholderText: String { get }
    
    var textFieldTitle: String { set get }
    
    var bottonTitle: String { get }
    
    var navTitle: String { get }
    
    var restrictedInput: Bool { get }
    
}

protocol ContactsReqFriendViewControllerDelegate {
    
    mutating func onClickButton()
    
}

/**
 *  请求完成删除添加好友列表处理
 */
protocol ContactsReqFriendDeleteItemDelegate {
    
    var viewController: UIViewController { get }
    var friendId: String  { get }
    var rowIndex: Int { get }
    
    func clickBtn(button: UIButton)
    
}

extension ContactsReqFriendDeleteItemDelegate {
    
    /**
     cell 添加按钮回调
     
     - parameter button: 按钮
     */
    func clickBtn(button: UIButton) {
        
        let friendReqVM =  ContactsFriendReqViewModel(viewController: viewController, friendId: friendId) {
            
            let userInfo: [NSObject: Int] = ["rowIndex": self.rowIndex]
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.ContactsFirendReqDeleteItem.rawValue, object: nil, userInfo: userInfo)
            
        }
        
        let addFirendVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        
        addFirendVC.viewConfig(friendReqVM)
        
        viewController.pushVC(addFirendVC)
        
    }
    
}
