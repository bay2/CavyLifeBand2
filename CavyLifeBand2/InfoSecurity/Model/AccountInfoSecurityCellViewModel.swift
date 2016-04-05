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
    
    var realm = try! Realm()
    
    var title: String
    
    var isOpen: Bool
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId}
    
    init(title: String, isOpenOrNot: Bool = true) {
        
        self.title = title
        self.isOpen = isOpenOrNot
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        Log.info("----\(title)----------\(sender.on)")

        updataRealmWithTitle(title, openOrNot: sender.on)
        
        
        
    }
    
    
     /**
     更新本地数据库 和 上传数据 

     - parameter title:         对应的行
     - parameter openOrNot:     是否打开
     - parameter userInfoModel: 本地存储的数据
     */
    
    func updataRealmWithTitle(title: String, openOrNot: Bool) {
        
        let userInfoModel: UserInfoModel = UserInfoOperate().queryUserInfo(userId)!
        
        if title == L10n.ContactsShowInfoHeight.string {
            
            try! realm.write {
                
                userInfoModel.isOpenHeight = openOrNot
                UserInfoModelView.shareInterface.userInfo!.isOpenHeight = openOrNot

            }
            
        }
        
        if title == L10n.ContactsShowInfoWeight.string {
            
            try! realm.write {
                
                userInfoModel.isOpenWeight = openOrNot
                
                UserInfoModelView.shareInterface.userInfo!.isOpenWeight = openOrNot

            }
            
        }
        
        if title == L10n.ContactsShowInfoBirth.string {
            
            try! realm.write {
                
                userInfoModel.isOpenBirthday = openOrNot
                
                UserInfoModelView.shareInterface.userInfo!.isOpenBirthday = openOrNot

            }
            
        }

    }
    
    
    
}

