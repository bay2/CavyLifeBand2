//
//  ReminderSettingVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

typealias ReminderSettingSViewModelPresentable = protocol<SettingRealmListOperateDelegate, RemindersSettingVCDataSource>

struct ReminderSettingVCViewModel: ReminderSettingSViewModelPresentable {
    
    var userId: String {
        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
    var realm: Realm
    
    var settingListModel: SettingRealmListModel {
        return querySettingList()!
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    
    
}

