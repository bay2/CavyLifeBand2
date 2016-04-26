//
//  PKRealm.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

protocol PKRecordRealmDataSource {
    var pkId: String { get }
    var loginUserId: String { get }
    var userId: String { get }
    var avatarUrl: String { get }
    var nickname: String { get }
    var pkDuration: String { get }
    var syncState: Int { get }
}

//等待响应的PK记录
class PKWaitRealmModel: Object, PKRecordRealmDataSource {
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
    
    override class func primaryKey() -> String? {
        return "pkId"
    }
    
}

//进行中的PK记录
class PKDueRealmModel: Object, PKRecordRealmDataSource {
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
    
    override class func primaryKey() -> String? {
        return "pkId"
    }
    
}

//已完成的PK记录
class PKFinishRealmModel: Object, PKRecordRealmDataSource {
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
    
    override class func primaryKey() -> String? {
        return "pkId"
    }
    
}

protocol PKRecordsRealmModelOperateDelegate {
    
    var realm: Realm { get }
    
    var loginUserId: String { get }
    
    //获取待回应pk记录
    func queryPKWaitRecordsRealm() -> Results<(PKWaitRealmModel)>
    
    //获取进行中pk记录
    func queryPKDueRecordsRealm() -> Results<(PKDueRealmModel)>
    
    //获取已完成pk记录
    func queryPKFinishRecordsRealm() -> Results<(PKFinishRealmModel)>
    
    /**
     更改未同步的待回应pk记录的同步状态
     
     - parameter type: 待回应pk记录类型 （发起、撤销、接受）
     
     - returns: Bool
     */
    func syncPKWaitRealm(type: PKWaitType) -> Bool
    
    //将某一类的未同步的记录的同步状态改为已同步
    func syncPKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Bool
    
    //存储某一类pk记录
    func savePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(recordList: [T]) -> Bool
    
    //删除某一类pk记录
    func deletePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Bool
    
    //获取某一类pk未同步记录的pkId的Array
    func getUnSyncPKIdList<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> [String]?
    
    /**
     获取未同步的待回应记录的pkId Array
     
     - parameter type: 待回应记录的类型（新发起、撤销、接受）
     
     - returns: pkId Array
     */
    func getUnSyncWaitPKIdListWithType(type: PKWaitType) -> [String]?
    
    //增加进行中PK记录
    func addPKDueRealm(pkDue: PKDueRealmModel) -> Bool
    
    //添加待回应记录（发起pk）
    func addPKWaitRealm(pkWait: PKWaitRealmModel) -> Bool
    
    //更新待回应记录的数据（接受pk或撤销pk）
    func updatePKWaitRealm(waitModel: PKWaitRealmModel, updateType: PKRecordsRealmUpdateType) -> Bool
    
    //更改已完成记录删除状态
    func updatePKFinishRealm(finishModel: PKFinishRealmModel) -> Bool
    
}


extension PKRecordsRealmModelOperateDelegate {
    
    func queryPKWaitRecordsRealm() -> Results<(PKWaitRealmModel)> {
        
        //loginUserID相等，且不是已撤销和已接受
        let predicate = NSPredicate(format: "loginUserId = %@ AND type != %d AND type != %d", loginUserId, PKWaitType.AcceptWait.rawValue, PKWaitType.UndoWait.rawValue)
        
        let waitList = realm.objects(PKWaitRealmModel).filter(predicate)

        return waitList
    
    }
    
    func queryPKDueRecordsRealm() -> Results<(PKDueRealmModel)> {
        let predicate = NSPredicate(format: "loginUserId = %@", loginUserId)
        
        let dueList = realm.objects(PKDueRealmModel).filter(predicate)
        
        return dueList
    }
    
    func queryPKFinishRecordsRealm() -> Results<(PKFinishRealmModel)> {
        let predicate = NSPredicate(format: "loginUserId = %@ AND isDelete = %@", loginUserId, false)
        
        let finishList = realm.objects(PKFinishRealmModel).filter(predicate)
        
        return finishList
    }
    
    //获取某一类pk记录
//    func queryPKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Results<(T)> {
//        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.Synced.rawValue)
//        
//        let pkRecords = realm.objects(modelClass).filter(predicate)
//        
//        return pkRecords
//    }
    
//    func savePKWaitRecordsRealm(waitList: [PKWaitRealmModel]) -> Bool {
//        
//        realm.beginWrite()
//        
//        realm.add(waitList, update: false)
//        
//        do {
//            try realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//        
//    }
//    
//    func savePKDueRecordsRealm(dueList: [PKDueRealmModel]) -> Bool {
//        
//        realm.beginWrite()
//        
//        realm.add(dueList, update: false)
//        
//        do {
//            try realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//        
//    }
//    
//    
//    func savePKFinishRecordsRealm(finishList: [PKFinishRealmModel]) -> Bool {
//        
//        realm.beginWrite()
//        
//        realm.add(finishList, update: false)
//        
//        do {
//            try realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//        
//    }
    
    func savePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(recordList: [T]) -> Bool {
        realm.beginWrite()
        
        realm.add(recordList, update: false)
        
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func deletePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Bool {
        
        let predicate = NSPredicate(format: "loginUserId = %@", loginUserId)
        
        let modelList = realm.objects(modelClass).filter(predicate)
        
        if modelList.count <= 0 {
            return true
        }

        realm.beginWrite()
        
        realm.delete(modelList)
        
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    //增加待回应的记录出现在邀请PK，这时候不需要让VM持有pkRecords
    func addPKWaitRealm(pkWait: PKWaitRealmModel) -> Bool {
        
        realm.beginWrite()
        
        realm.add(pkWait, update: false)

        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    
    
    //更新待回应数据 撤销或接受PK
    func updatePKWaitRealm(waitModel: PKWaitRealmModel, updateType: PKRecordsRealmUpdateType) -> Bool {
        
        realm.beginWrite()
        
        switch updateType {
        case .UndoWait:
            waitModel.type = PKWaitType.UndoWait.rawValue
            waitModel.syncState = PKRecordsRealmSyncState.NotSync.rawValue
            
        case .AcceptWait:
            waitModel.type = PKWaitType.AcceptWait.rawValue
            waitModel.syncState = PKRecordsRealmSyncState.NotSync.rawValue
            
        default:
            break
        }
        
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    //增加进行中PK记录
    func addPKDueRealm(pkDue: PKDueRealmModel) -> Bool {
        realm.beginWrite()
        realm.add(pkDue, update: false)
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
        
    }
    
    //更改待回应记录同步状态
    func syncPKWaitRealm(type: PKWaitType) -> Bool {
        
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d AND type = %@", loginUserId, PKRecordsRealmSyncState.NotSync.rawValue, type.rawValue)
        
        let waitList = realm.objects(PKWaitRealmModel).filter(predicate)
        
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
    
//    //更改待进行中记录同步状态
//    func syncPKDueRealm() -> Bool {
//        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.Synced.rawValue)
//        
//        let dueList = realm.objects(PKDueRealmModel).filter(predicate)
//        
//        if dueList.count <= 0 {
//            return true
//        }
//        
//        self.realm.beginWrite()
//        
//        for i in 0..<dueList.count {
//            dueList[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
//        }
//        
//        do {
//            try self.realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//        
//    }
//
//    //更改已完成记录同步状态
//    func syncPKFinishRealm() -> Bool {
//        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.Synced.rawValue)
//        
//        let finishList = realm.objects(PKFinishRealmModel).filter(predicate)
//        
//        if finishList.count <= 0 {
//            return true
//        }
//        
//        realm.beginWrite()
//        
//        for i in 0..<finishList.count {
//            finishList[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
//        }
//        
//        do {
//            try realm.commitWrite()
//        } catch let error {
//            Log.error("\(#function) error = \(error)")
//            return false
//        }
//        
//        return true
//        
//    }
    
    func syncPKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Bool {
        
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.Synced.rawValue)
        
        let pkRecords = realm.objects(PKWaitRealmModel).filter(predicate)
        
        if pkRecords.count <= 0 {
            return true
        }
        
        self.realm.beginWrite()
        
        for i in 0..<pkRecords.count {
            pkRecords[i].syncState = PKRecordsRealmSyncState.Synced.rawValue
        }
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    
    //更改已完成记录删除状态
    func updatePKFinishRealm(finishModel: PKFinishRealmModel) -> Bool {
        realm.beginWrite()
        finishModel.isDelete  = true
        finishModel.syncState = PKRecordsRealmSyncState.NotSync.rawValue
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    //未同步pkId Array
    func getUnSyncPKIdList<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> [String]? {
        
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.NotSync.rawValue)
        
        let modelList = realm.objects(modelClass).filter(predicate)
        
        if modelList.count <= 0 {
            return nil
        }
        
        var pkIdList = [String]()
        
        for model in modelList {
            pkIdList.append(model.valueForKey("pkId") as? String ?? "")
        }
        
        return pkIdList

    }
    
    //未同步waitList 的 pkId Array
    func getUnSyncWaitPKIdListWithType(type: PKWaitType) -> [String]? {
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d And type = %@", loginUserId, PKRecordsRealmSyncState.NotSync.rawValue, type.rawValue)
        
        let waitList = realm.objects(PKWaitRealmModel).filter(predicate)
        
        if waitList.count <= 0 {
            return nil
        }
        
        var pkIdList = [String]()
        
        for model in waitList {
            pkIdList.append(model.valueForKey("pkId") as? String ?? "")
        }
        
        return pkIdList

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


















