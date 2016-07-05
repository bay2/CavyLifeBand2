//
//  UserInfo.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log

class UserInfoModel: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var coins              = 0.0
    dynamic var phone              = ""
    dynamic var userId             = ""
    dynamic var sex                = 0
    dynamic var height             = 0.0
    dynamic var weight             = 0.0
    dynamic var birthday           = ""
    dynamic var avatarUrl          = ""
    dynamic var address            = ""
    dynamic var nickname           = ""
    dynamic var stepGoal: Int      = 0
    dynamic var sleepGoal: Int     = 0
    dynamic var isNotification     = true
    dynamic var isLocalShare       = true
    dynamic var isOpenBirthday     = true
    dynamic var isOpenHeight       = true
    dynamic var isOpenWeight       = true
    dynamic var isSync             = false
    dynamic var signUpDate: NSDate = NSDate()
    var awards = List<UserAwardsModel>()

    override class func primaryKey() -> String? {
        return "userId"
    }

}

extension UserInfoModel {
    
    func translateAwards() -> [Int] {
        guard self.awards.count > 0 else {
            return []
        }
        
        let awardArr = self.awards.map { (award) -> Int in
            return award.number.toInt() ?? 1
        }
        
        return awardArr
        
    }

}

class UserAwardsModel: Object {
    
    dynamic var date: NSDate = NSDate()
    dynamic var number: String = ""
    
    let owners = LinkingObjects(fromType: UserInfoModel.self, property: "awards")
    
}

protocol UserInfoRealmOperateDelegate {
    
    var realm: Realm { get }
    
    func queryUserInfo(userId: String) -> UserInfoModel?
    func queryUserInfo(userId: String) -> Results<UserInfoModel>
    func addUserInfo(userInfo: UserInfoModel) -> Bool
    func updateUserInfo(userInfo: UserInfoModel) -> Bool
    func updateUserInfo(userId: String, updateCall: ((UserInfoModel) -> UserInfoModel)) -> Bool
    
}

extension UserInfoRealmOperateDelegate {

    /**
     查询用户信息
     
     - parameter userId: 用户ID
     
     - returns: 用户信息
     */
    func queryUserInfo(userId: String) -> UserInfoModel? {
        
        
        let userInfo: Results<UserInfoModel> = queryUserInfo(userId)

        if userInfo.count == 0 {
            return nil
        }

        return userInfo[0]
            
    }
    
    func queryUserInfo(userId: String) -> Results<UserInfoModel> {
        
        return realm.objects(UserInfoModel).filter("userId == '\(userId)'")
        
    }

    /**
     添加用户信息
     
     - parameter userInfo: 用户信息
     
     - returns: 成功：true，失败： false
     */
    func addUserInfo(userInfo: UserInfoModel) -> Bool {

        do {

            try realm.write {
                realm.add(userInfo, update: false)
            }

        } catch {

            Log.error("Add user info error [\(userInfo)]")
            return false

        }

        Log.info("Add user info success")
        return true

    }
    
    /**
     更新用户信息
     
     - parameter userInfo: 用户信息
     
     - returns:
     */
    func updateUserInfo(userInfo: UserInfoModel) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(userInfo, update: true)
            }
            
        } catch {
            
            Log.error("Update user info error [\(userInfo)]")
            return false
            
        }
        
        Log.info("Update user info success")
        return true
        
    }

    /**
     更新用户信息
     
     - parameter userInfo: 用户信息
     
     - returns: 成功：true，失败：false
     */
    func updateUserInfo(userId: String, updateCall: ((UserInfoModel) -> UserInfoModel)) -> Bool {

        guard var userInfoModel: UserInfoModel = queryUserInfo(userId) else {
            Log.error("User info not exist [\(userId)]")
            return false
        }

        do {
            
            realm .beginWrite()
            
            userInfoModel = updateCall(userInfoModel)

            realm.add(userInfoModel, update: true)
            
            try realm.commitWrite()

        } catch {

            Log.error("Update user info error [\(userId)]")
            return false

        }

        Log.info("Update user info success [\(userId)]")
        return true

    }

}

