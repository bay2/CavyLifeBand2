//
//  AccountInfoSecurityCellViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/31.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift
import Log

/**
 *  @author xuemincai
 *
 *  好友列表cell ViewModel
 */
struct AccountInfoSecurityCellViewModel: AccountInfoSecurityListDataSource {
    
    var title: String
    
    var isOpen: Bool
    
    var realm: Realm
 
    var userId: String { return loginUserId}
    
    init(realm: Realm, title: String, isOpenOrNot: Bool = true) {
        
        self.title = title
        self.isOpen = isOpenOrNot
        self.realm = realm
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        
        Log.info(sender.tag)

        // 更新本地数据库
        
        // 上传更新数据
    }


}

