//
//  PKInvitationVCViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift
import JSONJoy

struct PKInvitationVCViewModel: PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
    var loginUserId: String
    
    var selectTime: String?
    
    
    var selectIndex: Int = 1 {
        didSet {
            selectTime = timeArr[selectIndex]
            pkWaitRealmModel.pkDuration = selectTime!
        }
    }
    
    let timeArr: [String] = ["1", "2", "3", "4", "5"]
    
    var realm: Realm
    
    var pkWaitRealmModel: PKWaitRealmModel
    
    init(realm: Realm) {
        self.realm = realm
        
        self.loginUserId  = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        
        pkWaitRealmModel = PKWaitRealmModel()
        
        pkWaitRealmModel.loginUserId = self.loginUserId
        pkWaitRealmModel.syncState   = PKRecordsRealmSyncState.NotSync.rawValue
        
    }
    
    //直接传入pkWait操作数据库，该pkWait应该是调接口后才add入数据库，pkId需要接口返回,同步状态为已同步
    func addPKWaitRecord() -> Bool {
        return addPKWaitRealm(self.pkWaitRealmModel)
    }
    
    //设置待回应记录的对方的信息
    func setPKWaitCompetitorInfo(userId: String, nickName: String, avatarUrl: String) -> Void {
        
        pkWaitRealmModel.userId    = userId
        pkWaitRealmModel.avatarUrl = avatarUrl
        pkWaitRealmModel.nickname  = nickName
        
    }
    
    //调接口发起PK
    func launchPK() -> Void {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFromString("yyyy-MM-dd HH:mm:ss")        
        
        launchPK([pkWaitRealmModel], loginUserId: self.loginUserId, callBack: {
            
            let pkId = $0[0]
            
            let launchTimeStr = dateFormatter.stringFromDate(NSDate())
            
            self.pkWaitRealmModel.launchedTime = launchTimeStr
            self.pkWaitRealmModel.pkId         = pkId
            self.pkWaitRealmModel.syncState    = PKRecordsRealmSyncState.Synced.rawValue
            
            self.addPKWaitRealm(self.pkWaitRealmModel)
            
        }, failure: { (errorMsg) in
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: errorMsg)
            Log.warning("弹窗提示失败" + errorMsg)
        })
        
    }
    
}
