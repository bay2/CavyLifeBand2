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
    
    // 是否隐藏关注图标
    var hiddenCare: Bool
    
    // 头像Url
    var headImagUrl: String
    
    // 好友用户ID
    var friendId: String
    
    init(friendId: String, name: String, headImagUrl: String, hiddenCare: Bool = true) {
        
        self.name = name
        self.hiddenCare = hiddenCare
        self.headImagUrl = headImagUrl
        self.friendId = friendId
        
    }
    
    func setHeadImageView(headImage: UIImageView) {
        headImage.af_setCircleImageWithURL(NSURL(string: headImagUrl)!, placeholderImage: UIImage(asset: .DefaultHead_small))
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
 *  添加好友table ViewModel
 */
struct ContactsAddFriendViewModel: ContactsFriendListDataSource {
    
    // 名字
    var name: String { return L10n.ContactsAddFriendsCell.string }
    
    var friendId: String { return "" }
    
    // 头像
    var headImage: UIImageView { return UIImageView(image: UIImage(asset: .PKInvitationAddBtnOld)) }
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    /**
     点击事件处理
     
     - parameter viewController:
     */
    func onClickCell(viewController: UIViewController) {
        
        viewController.pushVC(StoryboardScene.Contacts.instantiateContactsAddFriendVC())
        
    }
    
    func setHeadImageView(headImage: UIImageView) {
        headImage.image = UIImage(asset: .PKInvitationAddBtnOld)
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
    
    var friendId: String { return "" }
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    /**
     点击事件处理
     
     - parameter viewController:
     */
    func onClickCell(viewController: UIViewController) {
        
        viewController.pushVC(StoryboardScene.Contacts.instantiateContactsNewFriendVC())
        
    }
    
    func setHeadImageView(headImage: UIImageView) {
        headImage.image = UIImage(asset: .ContactsListNew)
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
    
    // 是否隐藏关注图标
    var hiddenCare: Bool = true
    
    var friendId: String { return "" }
    
    /**
     点击事件处理
     
     - parameter viewController: 
     */
    func onClickCell(viewController: UIViewController) {
        
    }
    
    func setHeadImageView(headImage: UIImageView) {
        headImage.image = UIImage(asset: .ContactsListCavy)
    }
    
}

struct ContactsTableListModelView: ContactsAddFriendDataSync, ContactsTableViewSectionDataSource {
    
    typealias ItemType = ContactsFriendCellModelView
    
    var items: [ItemType]
    var sectionTitle: String
    
    var rowCount: Int {
        return items.count
    }
    
    init(items: [ItemType], sectionTitle: String) {
        
        self.items = items
        self.sectionTitle = sectionTitle
        
    }
    
    func loadData() { Log.warning("不做任何处理") }
    
    func createCell(tableView: UITableView, index: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ContactsFriendListCell", forIndexPath: index) as? ContactsFriendListCell else {
            fatalError()
        }
        
        cell.configure(items[index.row])
        
        return cell
        
    }
    
    func createSectionView() -> UIView? {
        
        let letterView = NSBundle.mainBundle().loadNibNamed("ContactsLetterView", owner: nil, options: nil).first as? ContactsLetterView
        
        letterView?.title.text = sectionTitle
        
        return letterView
        
    }
    
}
