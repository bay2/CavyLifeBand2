//
//  ContactsFriendListViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


/**
 *  @author xuemincai
 *
 *  好友列表cell ViewModel
 */
struct ContactsFriendCellModelView: ContactsFriendListDataSource {
    
    // 名字
    var name: String
    
    // 头像
    var headImage: UIImage
    
    // 是否隐藏关注图标
    var hiddenCare: Bool
    
    init(name: String, headImage: UIImage = UIImage(asset: .GuidePairSeccuss), hiddenCare: Bool = true) {
        
        self.name = name
        self.headImage = headImage
        self.hiddenCare = hiddenCare
        
    }
    
    /**
     点击事件处理
     
     - parameter viewController:
     */
    func onClickCell(viewController: UIViewController) {
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  新好友cell ViewModel
 */
struct ContactsNewFriendCellModelView: ContactsFriendListDataSource {
    
    // 名字
    var name: String { return L10n.ContactsNewFriendsCell.string }
    
    // 头像
    var headImage: UIImage { return UIImage(asset: .ContactsListNew) }
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    /**
     点击事件处理
     
     - parameter viewController:
     */
    func onClickCell(viewController: UIViewController) {
        
        viewController.pushVC(StoryboardScene.Contacts.instantiateContactsNewFriendVC())
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  生活豚鼠cell ViewModel
 */
struct ContactsCavyModelView: ContactsFriendListDataSource {
    
    // 名字
    var name: String { return L10n.ContactsListCellCavy.string }
    
    // 头像
    var headImage: UIImage { return UIImage(asset: .ContactsListCavy) }
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    /**
     点击事件处理
     
     - parameter viewController: 
     */
    func onClickCell(viewController: UIViewController) {
        
    }
    
}
