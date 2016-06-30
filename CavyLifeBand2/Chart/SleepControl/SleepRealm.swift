//
//  SleepRealm.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift

class SleepWebRealm: Object {
    
    dynamic var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    dynamic var date: NSDate = NSDate()
    
    dynamic var totalTime: Int = 0
    
    dynamic var deepTime: Int = 0
    
}

extension SleepWebRealm {
    
    /**
     用接口模型快捷初始化数据库模型
     
     - parameter jsonModel: JSONJoy 模型
     
     - returns:
     */
    convenience init(jsonModel: SingleSleepData) {
        
        self.init()
        
        self.date      = jsonModel.date
        self.totalTime = jsonModel.totalTime
        self.deepTime  = jsonModel.deepTime

    }
    
    /**
     转换至Tuple格式
     
     - returns: 
     */
    func transformToTuple() -> (Double, Double, Double) {
        
        let totalTime: Double = self.totalTime.toDouble
        let deepTime: Double  = self.deepTime.toDouble
        let lightTime: Double = totalTime - deepTime
        
        return (totalTime, deepTime, lightTime)
        
    }
    
    
}

protocol SleepWebRealmOperate {
    
    var realm: Realm { get }
    
    /**
     添加睡眠数据
     
     - parameter model:
     
     - returns:
     */
    func addSleepWebRealm(model: SleepWebRealm) -> Bool
    
    /**
     获取一段时间内的睡眠数据
     
     - parameter userId:
     - parameter startDate:
     - parameter endDate:
     
     - returns:
     */
    func querySleepWebRealm(userId: String, startDate: NSDate, endDate: NSDate) -> Results<(SleepWebRealm)>?
    
    /**
     删除数据
     
     - parameter userId:
     - parameter startDate:
     - parameter endDate:
     
     - returns:
     */
    func deleteSleepWebRealm(userId: String, startDate: NSDate, endDate: NSDate) -> Bool
    
    /**
     获取该用户所有睡眠数据
     
     - parameter userId:
     
     - returns:
     */
    func queryUserSleepWebRealm(userId: String) -> Results<(SleepWebRealm)>?

}

extension SleepWebRealmOperate {
    
    func addSleepWebRealm(model: SleepWebRealm) -> Bool {
        
        do {
            
            try realm.write {
                
                realm.add(model, update: false)
            }
            
        } catch {
            
            Log.error("Add SleepWebRealm error [\(model)]")
            return false
            
        }
        
        Log.info("Add SleepWebRealm success")
        
        return true
        
    }
    
    func querySleepWebRealm(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, startDate: NSDate, endDate: NSDate) -> Results<(SleepWebRealm)>? {
        
        let predicate = NSPredicate(format: "userId == %@ AND date >= %@ AND date <= %@", userId, startDate, endDate)
        
        let sleepData = realm.objects(SleepWebRealm).filter(predicate)
        
        guard sleepData.count > 0 else {
            Log.info("There is no sleepWebData during the days(\(startDate)---\(endDate)) for this userId")
            return nil
        }
        
        return sleepData
    
    }
    
    func deleteSleepWebRealm(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, startDate: NSDate, endDate: NSDate) -> Bool {
        
        let predicate = NSPredicate(format: "userId == %@ AND date >= %@ AND date <= %@", userId, startDate, endDate)
        
        let sleepData = realm.objects(SleepWebRealm).filter(predicate)
        
        if sleepData.count <= 0 {
            return true
        }
        
        realm.beginWrite()
        
        realm.delete(sleepData)
        
        do {
            try realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
            return false
        }
        
        return true

    }
    
    func queryUserSleepWebRealm(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(SleepWebRealm)>? {
        
        let predicate = NSPredicate(format: "userId == %@", userId)
        
        let sleepData = realm.objects(SleepWebRealm).filter(predicate)
        
        guard sleepData.count > 0 else {
            Log.info("There is no sleepWebData for this userId")
            return nil
        }
        
        return sleepData
        
    }

}