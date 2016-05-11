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

typealias AccountInfoCellViewModelPresentable = protocol<AccountInfoSecurityListDataSource, UserInfoRealmOperateDelegate, AccountInfoSecurityUpdateByNetwork>

struct AccountInfoSecurityHeightCellViewModel: AccountInfoCellViewModelPresentable {
    
    var title: String { return L10n.ContactsShowInfoHeight.string }
    var realm: Realm
    var userId: String {
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
    var realmUserInfo: UserInfoModel?
    
    
    init(realm: Realm) {
        
        self.realm = realm
        self.realmUserInfo = queryUserInfo(userId)
        
    }
    
    var isOpen: Bool {
        
        guard let userInfo = realmUserInfo else {
            return true
        }
        
        return userInfo.isOpenHeight
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateUserInfo(userId) {
            $0.isOpenHeight = sender.on
            $0.isSync = false
            return $0
        }
        
        updateInfoSecurityAttir {
            
            guard $0 == true else {
                return
            }
            
            self.updateUserInfo(self.userId) {
                $0.isSync = true
                return $0
            }
        }
    }
    
}

struct AccountInfoSecurityWeightCellViewModel: AccountInfoCellViewModelPresentable {
    
    var title: String { return L10n.ContactsShowInfoWeight.string }
    var realm: Realm
    var userId: String {
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
    var realmUserInfo: UserInfoModel?
    
    init(realm: Realm) {
        
        self.realm = realm
        self.realmUserInfo = queryUserInfo(userId)
        
    }
    
    var isOpen: Bool {
        
        guard let userInfo: UserInfoModel =  queryUserInfo(userId) else {
            return true
        }
        
        return userInfo.isOpenWeight
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateUserInfo(userId) {
            $0.isOpenWeight = sender.on
            $0.isSync = false
            return $0
        }
        
        updateInfoSecurityAttir {
            
            guard $0 == true else {
                return
            }
            
            self.updateUserInfo(self.userId) {
                $0.isSync = true
                return $0
            }
        }
    }
    
}

struct AccountInfoSecurityBirthdayCellViewModel: AccountInfoCellViewModelPresentable {
    
    var title: String { return L10n.ContactsShowInfoBirth.string }
    var realm: Realm
    var userId: String {
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
    var realmUserInfo: UserInfoModel?
    
    init(realm: Realm) {
        
        self.realm = realm
        self.realmUserInfo = queryUserInfo(userId)
        
    }
    
    var isOpen: Bool {
        
        guard let userInfo: UserInfoModel =  queryUserInfo(userId) else {
            return true
        }
        
        return userInfo.isOpenWeight
    }
    
    /**
     改变按钮状态
     */
    func changeSwitchStatus(sender: UISwitch) {
        
        updateUserInfo(userId) {
            $0.isOpenBirthday = sender.on
            $0.isSync = false
            return $0
        }
        
        updateInfoSecurityAttir {
            
            guard $0 == true else {
                return
            }
            
            self.updateUserInfo(self.userId) {
                $0.isSync = true
                return $0
            }
        }
    }

}

