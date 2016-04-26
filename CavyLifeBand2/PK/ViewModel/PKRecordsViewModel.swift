//
//  PKRecordsViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import RealmSwift

struct PKRecordsViewModel: PKRecordsRealmModelOperateDelegate {
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd HH:mm:ss")
        return formatter
    }()
    
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
    
    func deletePKFinish(finishRealm: PKFinishRealmModel) -> Void {
        
        updatePKFinishRealm(finishRealm)
        
        do {
            
            let pk: [String: String] = [UserNetRequsetKey.PKId.rawValue: finishRealm.pkId]
            
            try PKWebApi.shareApi.deletePK(self.loginUserId, delPkList: [pk]) { (result) in
                
                guard result.isSuccess else {
                    //                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error)
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    //                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: resultMsg.commonMsg?.code ?? "")
                    return
                }
                
                self.syncPKRecordsRealm(PKFinishRealmModel.self)
                
            }
            
        } catch let error {
            Log.warning("\(error)")
            //            CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: error as? UserRequestErrorType)
        }
        
    }
    
    func acceptPKInvitation(waitRealm: PKWaitRealmModel) -> Bool {
        updatePKWaitRealm(waitRealm, updateType: PKRecordsRealmUpdateType.AcceptWait)
        
        let dueRealm = PKDueRealmModel()
        
        dueRealm.pkId = waitRealm.pkId
        dueRealm.loginUserId = waitRealm.loginUserId
        dueRealm.userId = waitRealm.userId
        dueRealm.avatarUrl = waitRealm.userId
        dueRealm.nickname = waitRealm.nickname
        dueRealm.pkDuration = waitRealm.pkDuration
        dueRealm.beginTime = PKRecordsViewModel.dateFormatter.stringFromDate(NSDate())
        dueRealm.syncState = PKRecordsRealmSyncState.NotSync.rawValue
        
        do {
            
            let pk: [String: String] = [UserNetRequsetKey.PKId.rawValue: dueRealm.pkId,
                                       UserNetRequsetKey.AcceptTime.rawValue: dueRealm.beginTime]
            
            try PKWebApi.shareApi.acceptPK(self.loginUserId, acceptPkList: [pk]) { (result) in
                
                guard result.isSuccess else {
//                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error)
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
//                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: resultMsg.commonMsg?.code ?? "")
                    return
                }
                
                self.syncPKRecordsRealm(PKDueRealmModel.self)
                
            }
            
        } catch let error {
            Log.warning("\(error)")
//            CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: error as? UserRequestErrorType)
        }

        return addPKDueRealm(dueRealm)
    }
    
    
    func loadData() {
        
        do {
            
            try PKWebApi.shareApi.getPKRecordList(self.loginUserId) { (result) in
                
                guard result.isSuccess else {
//                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error)
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
//                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: resultMsg.commonMsg?.code ?? "")
                    return
                }
                
                var waitRecordsRealm: [PKWaitRealmModel] = [PKWaitRealmModel]()
                
                var dueRecordsRealm: [PKDueRealmModel] = [PKDueRealmModel]()
                
                var finishRecordsRealm: [PKFinishRealmModel] = [PKFinishRealmModel]()
                
                for waitModel in resultMsg.waitList! {

                    waitRecordsRealm.append(self.translateWaitModelToRealm(waitModel))
                    
                }
                
                for dueModel in resultMsg.dueList! {
                    
                    dueRecordsRealm.append(self.translateDueModelToRealm(dueModel))
                    
                }
                
                for finishModel in resultMsg.finishList! {
                    
                    finishRecordsRealm.append(self.translateFinishModelToRealm(finishModel))
                    
                }
                
                Log.warning("tableview要重刷数据")
                
                self.deletePKRecordsRealm(PKWaitRealmModel.self)
                self.deletePKRecordsRealm(PKDueRealmModel.self)
                self.deletePKRecordsRealm(PKFinishRealmModel.self)
                
                self.savePKRecordsRealm(waitRecordsRealm)
                self.savePKRecordsRealm(dueRecordsRealm)
                self.savePKRecordsRealm(finishRecordsRealm)
                
            }
            
        } catch let error {
            Log.warning("\(error)")
//            CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: error as? UserRequestErrorType)
        }
        
    }
    
    func translateWaitModelToRealm(model: PKWaitRecord) -> PKWaitRealmModel {
        
        let realm = PKWaitRealmModel()
        
        realm.pkId         = model.pkId
        realm.loginUserId  = self.loginUserId
        realm.userId       = model.userId
        realm.avatarUrl    = model.avatarUrl
        realm.nickname     = model.nickname
        realm.type         = model.type
        realm.launchedTime = model.launchedTime
        realm.pkDuration   = model.pkDuration
        
        return realm
    }
    
    func translateDueModelToRealm(model: PKDueRecord) -> PKDueRealmModel {
        
        let realm = PKDueRealmModel()
        
        realm.pkId        = model.pkId
        realm.loginUserId = self.loginUserId
        realm.userId      = model.userId
        realm.avatarUrl   = model.avatarUrl
        realm.nickname    = model.nickname
        realm.beginTime   = model.beginTime
        realm.pkDuration  = model.pkDuration
        
        return realm
    }
    
    func translateFinishModelToRealm(model: PKFinishRecord) -> PKFinishRealmModel {
        
        let realm = PKFinishRealmModel()
        
        realm.pkId         = model.pkId
        realm.loginUserId  = self.loginUserId
        realm.userId       = model.userId
        realm.avatarUrl    = model.avatarUrl
        realm.nickname     = model.nickname
        realm.completeTime = model.completeTime
        realm.pkDuration   = model.pkDuration
        realm.isWin        = model.isWin
        
        return realm
    }


}
