//
//  ContactsAddFriendViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


/**
 *  @author xuemincai
 *
 *  添加好友table ViewModel
 */
struct ContactsAddFriendViewModel: ContactsFriendListDataSource {
    
    // 名字
    var name: String { return L10n.ContactsAddFriendsCell.string }
    
    // 头像
    var headImage: UIImage { return UIImage(asset: .ContactsListAdd) }
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    /**
     点击事件处理
     
     - parameter viewController:
     */
    func onClickCell(viewController: UIViewController) {
        
        viewController.pushVC(StoryboardScene.Contacts.instantiateContactsAddFriendVC())
        
    }
    
}


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
 *  @author xuemincai
 *
 *  推荐好友 cell ViewModel
 */
struct ContactsRecommendCellViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate{
    
    // 头像
    var headImage: UIImage
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return " 我爱吃草莓啊~~~" }
    
    // 按钮回调
    var changeRequestBtnName: ((String) -> Void)?
    
    init(name: String = "吖保鸡丁", headImage: UIImage = UIImage(asset: .GuideGenderBoyChosen), changeRequest: ((String) -> Void)? = nil) {
        
        self.name = name
        self.headImage = headImage
        self.changeRequestBtnName = changeRequest
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  通信录好友 cell ViewModel
 */
struct ContactsAddressBookViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate {
    
    // 头像
    var headImage: UIImage
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return "" }
    
    // 按钮回调
    var changeRequestBtnName: ((String) -> Void)?
    
    init(name: String = "吖保鸡丁", headImage: UIImage = UIImage(asset: .GuideGenderBoyChosen), changeRequest: ((String) -> Void)? = nil) {
        
        self.name = name
        self.headImage = headImage
        self.changeRequestBtnName = changeRequest
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  附近好友 cell ViewModel
 */
struct ContactsNearbyCellViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate{
    
    // 头像
    var headImage: UIImage
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return " 我爱吃草莓啊~~~" }
    
    // 按钮回调
    var changeRequestBtnName: ((String) -> Void)?
    
    init(name: String = "吖保鸡丁", headImage: UIImage = UIImage(asset: .GuideGenderBoyChosen), changeRequest: ((String) -> Void)? = nil) {
        
        self.name = name
        self.headImage = headImage
        self.changeRequestBtnName = changeRequest
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  新朋友 cell ViewModel
 */
struct ContactsNewFriendCellViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate {
    
    // 头像
    var headImage: UIImage
    
    // 名字
    var name: String
    
    // 副标题
    var introudce: String { return "" }
    
    // 请求按钮 title
    var requestBtnTitle: String { return L10n.ContactsListCellAgree.string}
    
    // 按钮颜色
    var requestBtnColor: UIColor { return UIColor(named: .ContactsAgreeButtonColor) }
    
    // 按钮回调
    var changeRequestBtnName: ((String) -> Void)?
    
    init(name: String = "吖保鸡丁", headImage: UIImage = UIImage(asset: .GuideGenderBoyChosen), changeRequest: ((String) -> Void)? = nil) {
        
        self.name = name
        self.headImage = headImage
        self.changeRequestBtnName = changeRequest
        
    }
    
}