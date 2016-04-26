//
//  PKRecordsViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

struct PKRecordsViewModel: PKRecordsRealmModelOperateDelegate {
    
    var loginUserId: String 
    
    var realm: Realm
    
    var waitList: Results<(PKWaitRealmModel)> {
        return queryPKWaitRecordsRealm()
    }
    
    var dueList: Results<(PKDueRealmModel)> {
        return queryPKDueRecordsRealm()
    }
    
    var finishList: Results<(PKFinishRealmModel)> {
        return queryPKFinishRecordsRealm()
    }
    
    init(realm: Realm) {
        self.realm = realm
        Log.warning("用户ID写死")
        self.loginUserId = "12"
    }
    
//    func acceptPKInvitation(<#parameters#>) -> Bool {
//        <#function body#>
//    }
    
    
    func savePKRecordsToRealm() -> Bool {
//        let finish1 = PKFinishRealmModel()
//        finish1.loginUserId = "12"
//        finish1.pkId = "121"
//        
//        let finish2 = PKFinishRealmModel()
//        finish2.loginUserId = "12"
//        finish2.pkId = "120"
//        
//        let finishList: [PKFinishRealmModel] = [finish1, finish2]
//        
//        return savePKRecordsRealm(finishList)
        return true
    }

}
