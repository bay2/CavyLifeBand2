//
//  PKRecordsCellViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

protocol PKRecordsCellDataSource {
    
    var nickName: String { get }
    
    var pkDescription: String { get }
    
    var btnTitle: String { get }
    
    var btnBGColor: UIColor { get }
    
    var isShowBtn: Bool { get }
    
    func clickBtn() -> Void
}

extension PKRecordsCellDataSource {
    
    func clickBtn() -> Void {
        Log.info("啥也不干啦")
    }
    
}

//待回应cell 的 viewmodel
struct PKWaitRecordsCellViewModel: PKRecordsCellDataSource, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    var tableView: UITableView?
    
    var realm: Realm
    
    var loginUserId: String
    
    var nickName: String
    
    var pkDescription: String
    
    var btnTitle: String
    
    var btnBGColor: UIColor
    
    var isShowBtn: Bool

    var pkRecord: PKWaitRealmModel
    
    init(pkRecord: PKWaitRealmModel, realm: Realm, tableView: UITableView? = nil) {
        self.isShowBtn     = true
        self.realm         = realm
        self.pkRecord      = pkRecord
        self.tableView     = tableView
        self.loginUserId   = pkRecord.loginUserId
        self.nickName      = pkRecord.nickname
        self.pkDescription = "\(pkRecord.pkDuration)" + L10n.PKRecordsCellDurationDescription.string
        self.btnTitle      = (pkRecord.type == PKWaitType.MeWaitOther.rawValue) ? L10n.PKRecordsCellUndoBtnTitle.string : L10n.PKRecordsCellAcceptBtnTitle.string
        self.btnBGColor    = (pkRecord.type == PKWaitType.MeWaitOther.rawValue) ? UIColor(named: .PKRecordsCellUndoBtnBGColor) : UIColor(named: .PKRecordsCellAcceptBtnBGColor)
        
    }
    
    func clickBtn() -> Void {
        
        switch self.pkRecord.type {
        case PKWaitType.OtherWaitMe.rawValue: //接受
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFromString("yyyy-MM-dd HH:mm:ss")
            
            //将待回应记录的type改为已接受
            updatePKWaitRealm(pkRecord, updateType: PKRecordsRealmUpdateType.AcceptWait)
            //根据待回应记录生成新的进行中记录
            let dueRealm = PKDueRealmModel()
    
            dueRealm.pkId        = pkRecord.pkId
            dueRealm.loginUserId = pkRecord.loginUserId
            dueRealm.userId      = pkRecord.userId
            dueRealm.avatarUrl   = pkRecord.userId
            dueRealm.nickname    = pkRecord.nickname
            dueRealm.pkDuration  = pkRecord.pkDuration
            dueRealm.beginTime   = dateFormatter.stringFromDate(NSDate())
            dueRealm.syncState   = PKRecordsRealmSyncState.NotSync.rawValue
            //把新的进行中记录加入数据库
            addPKDueRealm(dueRealm)
            //调接口接受PK,调接口成功后把那条刚加入数据库的进行中记录的同步状态改为已同步
            acceptPKInvitation([dueRealm], loginUserId: self.loginUserId, callBack: {
                self.syncPKRecordsRealm(PKDueRealmModel.self, pkId: dueRealm.pkId)
            }, failure: {(errorMsg) in
                Log.warning("弹框提示" + errorMsg)
            })
         
            break
            
        case PKWaitType.MeWaitOther.rawValue://撤销
            //将待回应记录的type改为已撤销
            updatePKWaitRealm(pkRecord, updateType: PKRecordsRealmUpdateType.UndoWait)
            //如果撤销一条未同步到服务器的pk，不需要调接口
            if pkRecord.pkId != "" {
                
                undoPK([pkRecord], loginUserId: self.loginUserId, callBack: {
                    self.syncPKRecordsRealm(PKDueRealmModel.self, pkId: self.pkRecord.pkId)
                }, failure: {(errorMsg) in
                        Log.warning("弹框提示" + errorMsg)
                })
               
            }

            break
        default:
            break
        }
        
    }
    
}

//进行中 cell 的 viewmodel
struct PKDueRecordsCellViewModel: PKRecordsCellDataSource {
    var nickName: String
    
    var pkDescription: String
    
    var btnTitle: String
    
    var btnBGColor: UIColor
    
    var isShowBtn: Bool
    
    var pkRecord: PKDueRealmModel
    
    init(pkRecord: PKDueRealmModel) {
        self.isShowBtn = false
        self.pkRecord = pkRecord
        self.nickName = pkRecord.nickname
        self.pkDescription = "\(pkRecord.pkDuration)" + L10n.PKRecordsCellDurationDescription.string
        self.btnTitle = ""
        self.btnBGColor = UIColor.whiteColor()
        
    }

}

//已完成 cell 的 viewmodel
struct PKFinishRecordsCellViewModel: PKRecordsCellDataSource, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    var tableView: UITableView?
    
    var realm: Realm
    
    var loginUserId: String
    
    var nickName: String
    
    var pkDescription: String
    
    var btnTitle: String
    
    var btnBGColor: UIColor
    
    var isShowBtn: Bool
    
    var pkRecord: PKFinishRealmModel
    
    init(pkRecord: PKFinishRealmModel, realm: Realm, tableView: UITableView? = nil) {
        self.isShowBtn     = true
        self.realm         = realm
        self.pkRecord      = pkRecord
        self.loginUserId   = pkRecord.loginUserId
        self.nickName      = pkRecord.isWin ? L10n.PKRecordsCellYouWin.string : "\(pkRecord.nickname)" + L10n.PKRecordsCellWin.string
        self.pkDescription = "\(pkRecord.pkDuration)" + L10n.PKRecordsCellDurationDescription.string
        self.btnTitle      = L10n.PKRecordsCellPKAgainBtnTitle.string
        self.btnBGColor    = UIColor(named: .PKRecordsCellPKAgainBtnBGColor)
        self.tableView     = tableView
    }
    
    func clickBtn() -> Void {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFromString("yyyy-MM-dd HH:mm:ss")
        
        //发起pk
        let waitRecord: PKWaitRealmModel = PKWaitRealmModel()
        
        waitRecord.loginUserId  = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        waitRecord.userId       = pkRecord.userId
        waitRecord.avatarUrl    = pkRecord.avatarUrl
        waitRecord.nickname     = pkRecord.nickname
        waitRecord.pkDuration   = pkRecord.pkDuration
        waitRecord.syncState    = PKRecordsRealmSyncState.NotSync.rawValue
        waitRecord.launchedTime = dateFormatter.stringFromDate(NSDate())
        
        launchPK([waitRecord], loginUserId: self.loginUserId, callBack: {
            let pkId = $0[0].pkId
            
            waitRecord.pkId      = pkId
            waitRecord.syncState = PKRecordsRealmSyncState.Synced.rawValue
            
            self.addPKWaitRealm(waitRecord)
            
        }, failure: {(errorMsg) in
            Log.warning("弹窗提示失败" + errorMsg)
        })
        
    }
    
}