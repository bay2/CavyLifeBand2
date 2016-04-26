//
//  PKInvitationVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

struct PKInvitationVCViewModel: PKRecordsRealmModelOperateDelegate {
    
    var loginUserId: String
    
    var competitorId: String = { return "" }()
    
    var selectTime: String?
    
    var selectIndex: Int = 1 {
        didSet {
            selectTime = timeArr[selectIndex]
        }
    }
    
    var otherCanSee: Bool = false
    
    var timeArr: [String] = {
        return ["",
                "1",
                "2",
                "3",
                "4",
                "5",
                ""]
    }()
    
    var realm: Realm
    
    var pkWaitRealmModel: PKWaitRealmModel{
        let pkWait = PKWaitRealmModel()
        pkWait.loginUserId = self.loginUserId
        return pkWait
    }
    
    init(realm: Realm) {
        self.realm = realm
        
        Log.warning("用户ID写死")
        
        self.loginUserId = "12"
    }
    
    //直接传入pkWait操作数据库，该pkWait应该是调接口后才add入数据库，pkId需要接口返回,同步状态为已同步
    func addPKWaitRecord() -> Bool {
        return addPKWaitRealm(self.pkWaitRealmModel)
    }
    
}
