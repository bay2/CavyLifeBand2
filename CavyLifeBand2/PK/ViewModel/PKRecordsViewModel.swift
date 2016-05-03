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

struct PKRecordsViewModel: PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd HH:mm:ss")
        return formatter
    }()
    
    var loginUserId: String

    var realm: Realm
    
    weak var tableView: UITableView?
    
    var itemGroup: [[PKRecordsCellDataSource]]
    
    init(realm: Realm, tableView: UITableView) {
        self.realm = realm
        
        Log.warning("用户ID写死")
        self.loginUserId = "12"
        
        self.itemGroup = [[PKRecordsCellDataSource]]()
        
        self.tableView = tableView
        
        
//        let due1: PKWaitRealmModel = PKWaitRealmModel()
//        
//        
//        due1.pkId = "2"
//        
//        due1.nickname = "o"
//        due1.loginUserId = "12"
//        
//        let due2: PKWaitRealmModel = PKWaitRealmModel()
//        
//        
//        due2.pkId = "1"
//        
//        due2.nickname = "x"
//        due2.loginUserId = "12"
//        
//        let dues:[PKWaitRealmModel] = [due1, due2]
//        
//        self.savePKRecordsRealm(dues)
//
        
    }
    
    mutating func deletePKFinish(indexPath: NSIndexPath) -> Void {
        let finishVM: PKFinishRecordsCellViewModel = self.itemGroup[indexPath.section][indexPath.row] as! PKFinishRecordsCellViewModel
        
        let finishRealm: PKFinishRealmModel = finishVM.pkRecord
        
        updatePKFinishRealm(finishRealm)
        
        //调接口把删除操作同步到服务器
        deletePKFinish([finishRealm], loginUserId: self.loginUserId, callBack: {
            self.syncPKRecordsRealm(PKFinishRealmModel.self, pkId: finishRealm.pkId)
        }, failure: {(erreoMsg) in
            Log.warning("弹框提示失败" + erreoMsg)
        })

    }
    
    func canEdit(section: Int) -> Bool {
        if self.itemGroup[section][0] is PKFinishRecordsCellViewModel {
            return true
        }
        
        return false
    }
    
    func sectionTitle(section: Int) -> String {
        if self.itemGroup[section][0] is PKFinishRecordsCellViewModel {
            return L10n.PKRecordsVCFinishSectionTitle.string
        } else if self.itemGroup[section][0] is PKWaitRecordsCellViewModel {
            return L10n.PKRecordsVCWaitSectionTitle.string
        } else if self.itemGroup[section][0] is PKDueRecordsCellViewModel {
            return L10n.PKRecordsVCDueSectionTitle.string
        } else {
            return ""
        }
    }
    
    mutating func loadDataFromRealm() {
        
        var waitCellVMs: [PKRecordsCellDataSource] = [PKRecordsCellDataSource]()
        
        var dueCellVMs: [PKRecordsCellDataSource] = [PKRecordsCellDataSource]()
        
        var finishCellVMs: [PKRecordsCellDataSource] = [PKRecordsCellDataSource]()
        
        let waitRealms = self.queryPKWaitRecordsRealm()
        
        let dueRealms = self.queryPKDueRecordsRealm()
        
        let finishRealms = self.queryPKFinishRecordsRealm()
        
        for waitRealm in waitRealms {
            let waitCellVM: PKWaitRecordsCellViewModel = PKWaitRecordsCellViewModel(pkRecord: waitRealm, realm: self.realm, tableView: self.tableView)
            
            waitCellVMs.append(waitCellVM)
        }
        
        for dueRealm in dueRealms {
            let dueCellVM: PKDueRecordsCellViewModel = PKDueRecordsCellViewModel(pkRecord: dueRealm)
            
            dueCellVMs.append(dueCellVM)
        }
        
        for finishRealm in finishRealms {
            let finishCellVM: PKFinishRecordsCellViewModel = PKFinishRecordsCellViewModel(pkRecord: finishRealm, realm: self.realm, tableView: self.tableView)
            
            finishCellVMs.append(finishCellVM)
        }
        
        self.itemGroup.removeAll()
        
        if waitCellVMs.count > 0 {
            self.itemGroup.append(waitCellVMs)
        }
        
        if dueCellVMs.count > 0 {
            self.itemGroup.append(dueCellVMs)
        }
        
        if finishCellVMs.count > 0 {
            self.itemGroup.append(finishCellVMs)
        }
    
    }
    
    mutating func changeData() {
        let due1: PKDueRealmModel = PKDueRealmModel()
        
        let due2: PKDueRealmModel = PKDueRealmModel()
        
        due1.pkId = "6"
        due2.pkId = "5"
        
        due1.nickname = "o"
        due2.nickname = "p"
        
        due2.loginUserId = "12"
        due1.loginUserId = "12"
        
        let dues: [PKDueRealmModel] = [due1, due2]
        
        self.savePKRecordsRealm(dues)
        
        self.loadDataFromRealm()
        
        self.tableView?.reloadData()
    }
    
    mutating func loadDataFromWeb() {
        
        do {
            
            try PKWebApi.shareApi.getPKRecordList(self.loginUserId) {(result) in
                
                let queue = dispatch_queue_create("handleWebJson", DISPATCH_QUEUE_SERIAL)
                
                dispatch_async(queue) {
                    guard result.isSuccess else {
                        return
                    }
                    
                    let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                    
                    guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                        return
                    }
                    
                    var waitRecordsRealm: [PKWaitRealmModel] = [PKWaitRealmModel]()
                    
                    var dueRecordsRealm: [PKDueRealmModel] = [PKDueRealmModel]()
                    
                    var finishRecordsRealm: [PKFinishRealmModel] = [PKFinishRealmModel]()
                    
                    for waitModel in resultMsg.waitList! {
                        
                        let waitRealm = self.translateWaitModelToRealm(waitModel)
                        
                        waitRecordsRealm.append(waitRealm)
                    }
                    
                    for dueModel in resultMsg.dueList! {
                        
                        let dueRealm = self.translateDueModelToRealm(dueModel)
                        
                        dueRecordsRealm.append(dueRealm)
                    }
                    
                    for finishModel in resultMsg.finishList! {
                        
                        let finishRealm = self.translateFinishModelToRealm(finishModel)
                        
                        finishRecordsRealm.append(finishRealm)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.deletePKRecordsRealm(PKWaitRealmModel.self)
                        self.deletePKRecordsRealm(PKDueRealmModel.self)
                        self.deletePKRecordsRealm(PKFinishRealmModel.self)
                        
                        self.savePKRecordsRealm(waitRecordsRealm)
                        self.savePKRecordsRealm(dueRecordsRealm)
                        self.savePKRecordsRealm(finishRecordsRealm)
                        
                        self.loadDataFromRealm()
                    }
                    
                }
   
            }
            
        } catch let error {
            
            Log.warning("弹框提示失败\(error)")
            
        }
        
    }
    
    //把接口返回的待回应记录JSONModel转为Realm格式
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
    
    //把接口返回的进行中记录JSONModel转为Realm格式
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
    
    //把接口返回的已完成记录JSONModel转为Realm格式
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



