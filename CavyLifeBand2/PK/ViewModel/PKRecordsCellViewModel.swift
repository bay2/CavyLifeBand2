//
//  PKRecordsCellViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

typealias PKCellProtocols = protocol<PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol, ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate>

//待回应cell 的 viewmodel
struct PKWaitRecordsCellViewModel: PKCellProtocols {
    
    var realm: Realm
    
    var loginUserId: String
    
    var introudce: String
    
    var bottonTitle: String
    
    var btnBGColor: UIColor
    
    var headImageUrl: String
    
    var friendId: String
    
    var name: String

    var pkRecord: PKWaitRealmModel
    
    init(pkRecord: PKWaitRealmModel, realm: Realm) {
        
        self.realm         = realm
        self.pkRecord      = pkRecord
        self.loginUserId   = pkRecord.loginUserId
        self.name          = pkRecord.nickname
        self.introudce     = pkRecord.pkDuration + L10n.PKRecordsCellDurationDescription.string
        self.bottonTitle   = (pkRecord.type == PKWaitType.MeWaitOther.rawValue) ? L10n.PKRecordsCellUndoBtnTitle.string : L10n.PKRecordsCellAcceptBtnTitle.string
        self.btnBGColor    = (pkRecord.type == PKWaitType.MeWaitOther.rawValue) ? UIColor(named: .NColor) : UIColor(named: .RColor)
        self.headImageUrl  = pkRecord.avatarUrl
        self.friendId      = pkRecord.userId
        
    }
    
    func clickCellBtn(sender: UIButton) {
        
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
            dueRealm.syncState   = PKRecordsRealmSyncState.NotSync.rawValue
            
            //把新的进行中记录加入数据库
            addPKDueRealm(dueRealm)
            
            //调接口接受PK,调接口成功后把那条刚加入数据库的进行中记录的同步状态改为已同步
            acceptPKInvitation([dueRealm], loginUserId: self.loginUserId, callBack: {
                self.changeDueBeginTime(dueRealm, time: dateFormatter.stringFromDate(NSDate()))
                self.syncPKRecordsRealm(PKDueRealmModel.self, pkId: dueRealm.pkId)
            }, failure: {
                Log.warning("弹框提示" + $0)
            })
         
            break
            
        case PKWaitType.MeWaitOther.rawValue://撤销
            
            
            let alertView = UIAlertController(title: "", message: L10n.AlertUndoPKWaitRecordMsg.string, preferredStyle: .Alert)
            
            let sureAction = UIAlertAction(title: L10n.AlertSureActionTitle.string, style: .Default, handler: { (action) in
                //将待回应记录的type改为已撤销
                self.updatePKWaitRealm(self.pkRecord, updateType: PKRecordsRealmUpdateType.UndoWait)
                
                //如果撤销一条未同步到服务器的pk，不需要调接口
                if self.pkRecord.pkId != "" {
                    
                    self.updatePKWaitRealm(self.pkRecord, updateType: PKRecordsRealmUpdateType.UndoWait)
                    
                    self.undoPK([self.pkRecord], loginUserId: self.loginUserId, callBack: {
                        self.syncPKRecordsRealm(PKWaitRealmModel.self, pkId: self.pkRecord.pkId)
                        }, failure: {
                            Log.warning("弹框提示" + $0)
                    })
                    
                } else {
                    self.updatePKWaitRealm(self.pkRecord, updateType: PKRecordsRealmUpdateType.UndoWait)
                }

            })
            
            let cancelAction = UIAlertAction(title: L10n.AlertCancelActionTitle.string, style: .Cancel, handler: nil)
            
            alertView.addAction(sureAction)
            alertView.addAction(cancelAction)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
            
            
            break
        default:
            break
        }
        
    }
    
}

//进行中 cell 的 viewmodel
struct PKDueRecordsCellViewModel: ContactsAddFriendCellDataSource, ContactsAddFriendCellDelegate {
    
    var name: String
    
    var introudce: String
    
    var bottonTitle: String
    
    var btnBGColor: UIColor
    
    var pkRecord: PKDueRealmModel
    
    var friendId: String
    
    var headImageUrl: String
    
    init(pkRecord: PKDueRealmModel) {
        
        self.friendId     = pkRecord.userId
        self.headImageUrl = pkRecord.avatarUrl
        self.pkRecord     = pkRecord
        self.name         = pkRecord.nickname
        self.introudce    = "\(pkRecord.pkDuration)" + L10n.PKRecordsCellDurationDescription.string
        self.bottonTitle  = ""
        self.btnBGColor   = UIColor.whiteColor()
        
    }

}

//已完成 cell 的 viewmodel
struct PKFinishRecordsCellViewModel: PKCellProtocols {
    
    
    var realm: Realm
    
    var loginUserId: String
    
    var bottonTitle: String
    
    var friendId: String
    
    var headImageUrl: String
    
    var name: String
    
    var introudce: String
    
    var btnBGColor: UIColor
    
    var pkRecord: PKFinishRealmModel
    
    init(pkRecord: PKFinishRealmModel, realm: Realm) {
        
        self.realm         = realm
        self.pkRecord      = pkRecord
        self.friendId      = pkRecord.userId
        self.headImageUrl  = pkRecord.avatarUrl
        self.loginUserId   = pkRecord.loginUserId
        self.name          = pkRecord.isWin ? L10n.PKRecordsCellYouWin.string : pkRecord.nickname + L10n.PKRecordsCellWin.string
        self.introudce     = pkRecord.pkDuration + L10n.PKRecordsCellDurationDescription.string
        self.bottonTitle   = L10n.PKRecordsCellPKAgainBtnTitle.string
        self.btnBGColor    = UIColor(named: .PKRecordsCellPKAgainBtnBGColor)
        
    }
    
    func clickCellBtn(sender: UIButton) -> Void {
        
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
        
        launchPK([waitRecord], loginUserId: self.loginUserId, callBack: {
            
            let pkId = $0[0]
            
            let launchTimeStr = dateFormatter.stringFromDate(NSDate())
            
            waitRecord.launchedTime = launchTimeStr
            waitRecord.pkId         = pkId
            waitRecord.syncState    = PKRecordsRealmSyncState.Synced.rawValue
            
            self.addPKWaitRealm(waitRecord)
            
        }, failure: {
            Log.warning("弹窗提示失败" + $0)
        })
        
    }
    
    func clickDelete() {
        
        
        self.updatePKFinishRealm(pkRecord)
        
        deletePKFinish([pkRecord], loginUserId: pkRecord.loginUserId, callBack: {
            
            self.syncPKRecordsRealm(PKFinishRealmModel.self, pkId: self.pkRecord.pkId)
            
            
        }, failure: {
            
            Log.warning("弹窗提示失败" + $0)
                
        })

        
    }
    
}