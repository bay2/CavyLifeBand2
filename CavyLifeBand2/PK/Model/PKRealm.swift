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
    
    func queryPKRecordsRealmList() -> PKRecordsRealmModel
    
    func savePKRecordsRealm(pkRecords: PKRecordsRealmModel) -> Bool
    
    func deletePKRecordsRealm() -> Bool
    
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
    
    //物理上的删除Wait记录
    func deletePKWaitRealm(index: Int, pkRecords: PKRecordsRealmModel) -> Bool {
        
        self.realm.beginWrite()
        pkRecords.waitRealmList.removeAtIndex(index)
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    
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
    
//    //物理上的删除Finish记录,这里代码不对，不需要index TODO ，wait的删除也不对，同理
//    func deletePKFinishRealm(pkRecords: PKRecordsRealmModel) -> Bool {
//        
//        
//        //删除之前标记为未同步的数据
//        @available(iOS, deprecated=1.0, message="I'm not deprecated, please ***setUpElements**")
//        //TODO:这个应该是一个List，但是报错了
//        guard let finishList: [PKFinishRealmModel] = pkRecords.finishRealmList.filter("syncState = \(PKRecordsRealmSyncState.NotSync.rawValue)") else {
//            return false
//        }
//        
//        self.realm.beginWrite()
//        pkRecords.finishRealmList.removeLast()
//        do {
//            try self.realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//    }
    
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


















