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
    var syncState: Int { get set }
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
    dynamic var type: Int = PKWaitType.MeWaitOther.rawValue
    dynamic var avatarUrl = ""
    dynamic var nickname = ""
    dynamic var launchedTime = ""
    dynamic var pkDuration = ""
    dynamic var isAllowWatch: Int = PKAllowWatchState.OtherNoWatch.rawValue
    
    /**
     1，已同步；
     2，未同步；
     */
    dynamic var syncState = PKRecordsRealmSyncState.Synced.rawValue
    
//    override class func primaryKey() -> String? {
//        return "pkId"
//    }
    
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
    
//    override class func primaryKey() -> String? {
//        return "pkId"
//    }
    
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
    
//    override class func primaryKey() -> String? {
//        return "pkId"
//    }
    
}

/**
 *  pk 数据库 单条记录操作
 */
protocol SinglePKRealmModelOperateDelegate {
    
    var realm: Realm { get }
    
    // 通过pkId 获取进行中pk记录
    func getPKDueRecordByPKId(pkid: String) -> PKDueRealmModel?
    
    // 通过PKId 获取已完成pk记录
    func getPKFinishRecordByPKId(pkid: String) -> PKFinishRealmModel?
    
}

extension SinglePKRealmModelOperateDelegate {

    func getPKDueRecordByPKId(pkid: String) -> PKDueRealmModel? {
        let predicate = NSPredicate(format: "pkId = %@ AND loginUserId = %@", pkid, CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)
        
        guard let due = realm.objects(PKDueRealmModel).filter(predicate).first else {
            Log.warning("\(#function) 该记录不存在")
            return nil
        }
        
        return due
    }
    
    func getPKFinishRecordByPKId(pkid: String) -> PKFinishRealmModel? {
        let predicate = NSPredicate(format: "pkId = %@ AND loginUserId = %@", pkid, CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)
        
        guard let finish = realm.objects(PKFinishRealmModel).filter(predicate).first else {
            Log.warning("\(#function) 该记录不存在")
            return nil
        }
        
        return finish
    }

}


/**
 *  pk 数据库 列表操作
 */
protocol PKRecordsRealmModelOperateDelegate {
    
    var realm: Realm { get }
    
    var loginUserId: String { get }
    
    //获取待回应pk记录
    func queryPKWaitRecordsRealm() -> Results<(PKWaitRealmModel)>
    
    //获取进行中pk记录
    func queryPKDueRecordsRealm() -> Results<(PKDueRealmModel)>
    
    //获取已完成pk记录
    func queryPKFinishRecordsRealm() -> Results<(PKFinishRealmModel)>
    
    //将某一类的某一条记录的同步状态改为已同步
    func syncPKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type, pkId: String) -> Bool
    
    //存储某一类pk记录
    func savePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(recordList: [T]) -> Bool
    
    //删除某一类pk记录
    func deletePKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> Bool
    
    //获取某一类pk未同步记录的Array
    func getUnSyncPKList<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> [T]?
    
    /**
     获取未同步的待回应记录 Array
     
     - parameter type: 待回应记录的类型（新发起、撤销、接受）
     
     - returns: Array
     */
    func getUnSyncWaitPKListWithType(type: PKWaitType) -> [PKWaitRealmModel]?
    
    //增加进行中PK记录
    func addPKDueRealm(pkDue: PKDueRealmModel) -> Bool
    
    //添加待回应记录（发起pk）
    func addPKWaitRealm(pkWait: PKWaitRealmModel) -> Bool
    
    //更新待回应记录的数据（接受pk或撤销pk）
    func updatePKWaitRealm(waitModel: PKWaitRealmModel, updateType: PKRecordsRealmUpdateType) -> Bool
    
    //更改已完成记录删除状态
    func updatePKFinishRealm(finishModel: PKFinishRealmModel) -> Bool
    
    //更改进行中记录的开始时间
    func changeDueBeginTime(pkDue: PKDueRealmModel, time: String) -> Bool
    
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
        let predicate = NSPredicate(format: "loginUserId = %@ AND pkId = %@", loginUserId, pkWait.pkId)
        
        guard realm.objects(PKWaitRealmModel).filter(predicate).first == nil else {
            Log.warning("\(#function) 该记录已经存在")
            return false
        }
        
        do {
            try realm.write {
                realm.add(pkWait, update: false)
            }
            
        } catch {
            Log.error("Add PKWait error [\(pkWait)]")
            return false
        }
        
        Log.info("Add PKWait success")
        return true
    }
    
    //更新待回应数据 撤销或接受PK
    func updatePKWaitRealm(waitModel: PKWaitRealmModel, updateType: PKRecordsRealmUpdateType) -> Bool {
        realm.beginWrite()
        
        waitModel.syncState = PKRecordsRealmSyncState.NotSync.rawValue
        
        switch updateType {
        case .UndoWait:
            if waitModel.pkId == "" { //如果pkId为空字符串说明这条记录还没来得及同步到服务器可以直接删除
                realm.delete(waitModel)
            } else {
                waitModel.type = PKWaitType.UndoWait.rawValue
            }
            
        case .AcceptWait:
            waitModel.type = PKWaitType.AcceptWait.rawValue
            
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
        let predicate = NSPredicate(format: "loginUserId = %@ AND pkId = %@", loginUserId, pkDue.pkId)
        
        guard realm.objects(PKDueRealmModel).filter(predicate).first == nil else {
            Log.warning("\(#function) 该记录已经存在")
            return false
        }
        
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
    
    //更改进行中记录的开始时间
    func changeDueBeginTime(pkDue: PKDueRealmModel, time: String) -> Bool {
        let predicate = NSPredicate(format: "loginUserId = %@ AND pkId = %@", loginUserId, pkDue.pkId)
        
        guard realm.objects(PKDueRealmModel).filter(predicate).first != nil else {
            Log.warning("\(#function) 该记录不存在")
            return false
        }
        
        realm.beginWrite()
        
        pkDue.beginTime = time
        
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true
    }
    
    func syncPKRecordsRealm<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type, pkId: String) -> Bool {
        
        let predicate = NSPredicate(format: "loginUserId = %@ AND pkId = %@", loginUserId, pkId)
        
        guard var pkRecord = realm.objects(modelClass).filter(predicate).first else {
            Log.warning("\(#function) 该记录不存在")
            return false
        }
        
        self.realm.beginWrite()
        
        pkRecord.syncState = PKRecordsRealmSyncState.Synced.rawValue
        
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
    func getUnSyncPKList<T: PKRecordRealmDataSource where T: Object>(modelClass: T.Type) -> [T]? {
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d", loginUserId, PKRecordsRealmSyncState.NotSync.rawValue)
        
        let modelList = realm.objects(modelClass).filter(predicate)
        
        if modelList.count <= 0 {
            return nil
        }
        
        var pkList = [T]()
        
        for model in modelList {
            pkList.append(model)
        }
        
        return pkList
    }
    
    //未同步waitList 的 Array
    func getUnSyncWaitPKListWithType(type: PKWaitType) -> [PKWaitRealmModel]? {
        let predicate = NSPredicate(format: "loginUserId = %@ AND syncState = %d And type = %d", loginUserId, PKRecordsRealmSyncState.NotSync.rawValue, type.rawValue)
        
        let waitList = realm.objects(PKWaitRealmModel).filter(predicate)
        
        if waitList.count <= 0 {
            return nil
        }
        
        var pkIdList = [PKWaitRealmModel]()
        
        for model in waitList {
            pkIdList.append(model)
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

enum PKAllowWatchState: Int {
    
    case OtherNoWatch = 0
    case AllWatch = 1
    
}

enum PKWaitType: Int {
    case MeWaitOther = 0
    case OtherWaitMe = 1
    case AcceptWait = 2
    case UndoWait = 3
}








