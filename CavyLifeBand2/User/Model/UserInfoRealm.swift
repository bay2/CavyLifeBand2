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
    
    dynamic var userId = ""
    dynamic var sex = 0
    dynamic var height = ""
    dynamic var weight = ""
    dynamic var birthday = ""
    dynamic var avatarUrl = ""
    dynamic var address = ""
    dynamic var nickname = ""
    dynamic var stepNum = 0
    dynamic var sleepTime = ""
    dynamic var isNotification = true
    dynamic var isLocalShare = true
    dynamic var isOpenBirthday = true
    dynamic var isOpenHeight = true
    dynamic var isOpenWeight = true
    dynamic var isSync = false

    override class func primaryKey() -> String? {
        return "userId"
    }

}

protocol UserInfoRealmOperateDelegate {
    
    var realm: Realm { get }
    
    func queryUserInfo(userId: String) -> UserInfoModel?
    func addUserInfo(userInfo: UserInfoModel) -> Bool
    func updateUserInfo(userId: String, updateCall: ((UserInfoModel) -> UserInfoModel)) -> Bool
    func isUserExist(userId: String) -> Bool
    
}

extension UserInfoRealmOperateDelegate {

    /**
     查询用户信息
     
     - parameter userId: 用户ID
     
     - returns: 用户信息
     */
    func queryUserInfo(userId: String) -> UserInfoModel? {
        
        if realm.objects(UserInfoModel).count == 0 {
            return nil
        }
        
        let userInfo = realm.objects(UserInfoModel).filter("userId == '\(userId)'")

        if userInfo.count == 0 {
            return nil
        }

        return userInfo[0]
            
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
     
     - returns: 成功：true，失败：false
     */
    func updateUserInfo(userId: String, updateCall: ((UserInfoModel) -> UserInfoModel)) -> Bool {

        guard var userInfoModel = queryUserInfo(userId) else {
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

    /**
     查询用户信息是否存在
     
     - parameter userId: 用户Id
     
     - returns:
     */
    func isUserExist(userId: String) -> Bool {

        if let _ = queryUserInfo(userId) {
            return true
        }

        return false

    }

}

