//
//  PKRealm.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class PKRecordsRealmModel: Object {
    var loginUserId = ""
    
    var waitRealmList = List<PKWaitRealmModel>()
    var dueRealmList = List<PKDueRealmModel>()
    var finishRealmList = List<PKFinishRealmModel>()
    
    override class func primaryKey() -> String? {
        return "loginUserId"
    }
    
}


//等待响应的PK记录
class PKWaitRealmModel: Object {
    dynamic var pkId = ""
    dynamic var loginUserId = ""
    dynamic var userId = ""
    
    /**
     0，等待对方接受；
     1，对方等待你接受；
     2，我接受请求，添加进行中Model，但还没同步到服务器，同步到服务器删除Model；
     3，撤销请求，但还没同步到服务器，同步到服务器后删除Model；
    */
    dynamic var type = PKWaitType.MeWaitOther.rawValue
    dynamic var avatarUrl = ""
    dynamic var nickname = ""
    dynamic var launchedTime = ""
    dynamic var pkDuration = ""
    
    /**
     1，已同步；
     2，未同步；
     */
    dynamic var syncState = PKRecordsRealmSyncState.Synced.rawValue
    
    var owners: [PKRecordsRealmModel] {
        
        return linkingObjects(PKRecordsRealmModel.self, forProperty: "waitRealmList")
    }
    
}

//进行中的PK记录
class PKDueRealmModel: Object {
    dynamic var pkId = ""
    dynamic var loginUserId = ""
    dynamic var userId = ""
    dynamic var avatarUrl = ""
    dynamic var nickname = ""
    dynamic var beginTime = ""
    dynamic var pkDuration = ""
    
    /**
     1，已同步；
     2，未同步；
     */
    dynamic var syncState = PKRecordsRealmSyncState.Synced.rawValue
    
    var owners: [PKRecordsRealmModel] {
        
        return linkingObjects(PKRecordsRealmModel.self, forProperty: "dueRealmList")
    }
    
}

//已完成的PK记录
class PKFinishRealmModel: Object {
    dynamic var pkId = ""
    dynamic var loginUserId = ""
    dynamic var userId = ""
    dynamic var avatarUrl = ""
    dynamic var nickname = ""
    dynamic var isWin = true
    dynamic var completeTime = ""
    dynamic var pkDuration = ""
    dynamic var isDelete = false
    
    /**
     1，已同步；
     2，未同步；
     */
    dynamic var syncState = PKRecordsRealmSyncState.Synced.rawValue
    
    var owners: [PKRecordsRealmModel] {
        
        return linkingObjects(PKRecordsRealmModel.self, forProperty: "finishRealmList")
    }
    
}

protocol PKRecordsRealmModelOperateDelegate {
    
    var realm: Realm { get }
    
    var loginUserId: String { get }
    
    func queryPKRecordsRealm() -> PKRecordsRealmModel
    
    func savePKRecordsRealm(pkRecords: PKRecordsRealmModel) -> Bool
    
    func deletePKRecordsRealm() -> Bool
    
    func addPKWaitRealm(pkWait: PKWaitRealmModel) -> Bool
    
}


extension PKRecordsRealmModelOperateDelegate {
    
    func queryPKRecordsRealm() -> PKRecordsRealmModel {
        
        guard isExistPKRecordsRealm() else {
            return initPKRecordsRealm()!
        }

        let pkRecords = realm.objects(PKRecordsRealmModel).filter("loginUserId = '\(loginUserId)'")

        return pkRecords.first!
    
    }
    
    
    func isExistPKRecordsRealm() -> Bool {
        let pkRecords = realm.objects(PKRecordsRealmModel).filter("loginUserId = '\(loginUserId)'")
        
        if pkRecords.count <= 0 {
            return false
        }
        
        return true
    }
    
    func initPKRecordsRealm() -> PKRecordsRealmModel? {
        
        let pkRecords = PKRecordsRealmModel()
        
        pkRecords.loginUserId = loginUserId
        
        Log.warning("需要删除以下代码")
        //------
        let finish = PKFinishRealmModel()
        finish.loginUserId = loginUserId
        finish.pkId = "123"
        
        pkRecords.finishRealmList.append(finish)
        //-------
        
        if savePKRecordsRealm(pkRecords) {
            return pkRecords
        }
        
        return nil
        
    }
    
    func savePKRecordsRealm(pkRecords: PKRecordsRealmModel) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(pkRecords, update: false)
            }
            
        } catch {
            
            Log.error("save pkRecords error [\(pkRecords)]")
            return false
            
        }
        
        Log.info("save pkRecords success")
        return true
    }
    
    func deletePKRecordsRealm() -> Bool {
        if isExistPKRecordsRealm() {
            //
            let pkRecords = realm.objects(PKRecordsRealmModel).filter("loginUserId = '\(loginUserId)'")
            self.realm.beginWrite()
            
            self.realm.delete(pkRecords)
            
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
            
            return true
        }
        
        return true
    }
    
    func addPKWaitRealm(pkWait: PKWaitRealmModel, pkRecords: PKRecordsRealmModel) -> Bool {
        self.realm.beginWrite()
        pkRecords.waitRealmList.insert(pkWait, atIndex: 0)
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    //增加待回应的记录出现在邀请PK，这时候不需要让VM持有pkRecords
    func addPKWaitRealm(pkWait: PKWaitRealmModel) -> Bool {
        
        let pkRecords = queryPKRecordsRealm()
        
        self.realm.beginWrite()
        pkRecords.waitRealmList.insert(pkWait, atIndex: 0)
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    
    
    //更新待回应数据 撤销或接受PK
    func updatePKWaitRealm(index: Int, updateType: PKRecordsRealmUpdateType, pkRecords: PKRecordsRealmModel) -> Bool {
        
        switch updateType {
        case .UndoWait:
            self.realm.beginWrite()
            pkRecords.waitRealmList[index].type = PKWaitType.UndoWait.rawValue
            pkRecords.waitRealmList[index].syncState = PKRecordsRealmSyncState.NotSync.rawValue
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
        case .AcceptWait:
            self.realm.beginWrite()
            pkRecords.waitRealmList[index].type = PKWaitType.AcceptWait.rawValue
            pkRecords.waitRealmList[index].syncState = PKRecordsRealmSyncState.NotSync.rawValue
            
            //增加进行中
            do {
                try self.realm.commitWrite()
            } catch let error {
                Log.error("\(#function) error = \(error)")
                return false
            }
        default:
            break
        }
        
        return true
    }
    
    //增加进行中PK记录
    func addPKDueRealm(pkDue: PKDueRealmModel, pkRecords: PKRecordsRealmModel) -> Bool {
        self.realm.beginWrite()
        pkRecords.dueRealmList.insert(pkDue, atIndex: 0)
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    //更改待回应记录同步状态
    func syncPKWaitRealm(pkRecords: PKRecordsRealmModel) -> Bool {
        let waitList = pkRecords.waitRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
        if waitList.count <= 0 {
            return true
        }
        
        self.realm.beginWrite()
        
        for i in 0..<waitList.count {
            waitList[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    //更改待进行中记录同步状态
    func syncPKDueRealm(pkRecords: PKRecordsRealmModel) -> Bool {
        let dueList = pkRecords.dueRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
        if dueList.count <= 0 {
            return true
        }
        
        self.realm.beginWrite()
        
        for i in 0..<dueList.count {
            dueList[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }

    //更改已完成记录同步状态
    func syncPKFinishRealm(pkRecords: PKRecordsRealmModel) -> Bool {
        let finishList = pkRecords.finishRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
        if finishList.count <= 0 {
            return true
        }
        
        self.realm.beginWrite()
        
        for i in 0..<finishList.count {
            finishList[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    //更新已完成记录删除状态
    func updatePKFinishRealm(index: Int, pkRecords: PKRecordsRealmModel) -> Bool {
        self.realm.beginWrite()
        pkRecords.finishRealmList[index].isDelete = true
        pkRecords.finishRealmList[index].syncState = PKRecordsRealmSyncState.NotSync.rawValue
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func getUnSyncPKIdList() -> [String:[String]] {
        
        let pkRecords = realm.objects(PKRecordsRealmModel).filter("loginUserId = '\(loginUserId)'").first
        
        
        let waitList = pkRecords?.waitRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
        let finishList = pkRecords?.finishRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
        let dueList = pkRecords?.dueRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)")
        
    }
    
    
}


enum PKRecordsRealmUpdateType {
    
    case UndoWait
    case AcceptWait
    case Sync
    case DeleteFinish

}

enum PKRecordsRealmSyncState: Int {
    
    case Synced = 1
    case NotSync = 2
 
}

enum PKWaitType: String {
    case MeWaitOther = "0"
    case OtherWaitMe = "1"
    case AcceptWait = "2"
    case UndoWait = "3"
}


















