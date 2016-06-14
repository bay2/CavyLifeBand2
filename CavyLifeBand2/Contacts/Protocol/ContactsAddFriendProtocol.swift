//
//  ContactsAddFriendProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

extension ContactsAddFriendCellDelegate {
    
    // 名字字体颜色
    var nameTextColor: UIColor { return UIColor(named: .EColor) }
    
    // 名字字体大小
    var nameFont: UIFont { return UIFont.mediumSystemFontOfSize(16) }
    
    // 副标题字体颜色
    var introductTextColor: UIColor { return UIColor(named: .FColor) }
    
    // 副标题字体大小
    var introduceFont: UIFont { return UIFont.systemFontOfSize(12) }
    
    // 按钮颜色
    var btnBGColor: UIColor { return UIColor(named: .JColor) }
    
    // 按钮字体大小
    var btnFont: UIFont { return UIFont.mediumSystemFontOfSize(16) }
    
    // 按钮title
    var bottonTitle: String { return L10n.ContactsListCellAdd.string }
    
    func clickCellBtn(sender: UIButton) -> Void {
    }
    
    
}

/**
 *  切换到请求添加好友页面
 */
protocol SwitchAddFirendReqView {
    
    var viewController: UIViewController { get }
    var friendId: String { get }
    
    var pushFirendReqView: ((Void) -> Void)? { get }
    
}

extension SwitchAddFirendReqView {
    
    var pushFirendReqView: ((Void) -> Void)? { return {
        
        let addFirendVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        
        let firendReqViewModel = ContactsFriendReqViewModel(viewController: addFirendVC, friendId: self.friendId)
        
        addFirendVC.viewConfig(firendReqViewModel)
        
        self.viewController.pushVC(addFirendVC)
        
        }
    }
    
}