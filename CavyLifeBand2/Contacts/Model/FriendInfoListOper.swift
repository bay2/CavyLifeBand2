//
//  FriendInfoListOper.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log

class FriendInfoListOper {
    
    var realm = try! Realm()
    
    /**
     保存好友列表
     
     - parameter userId: 用户id
     - parameter list:   好友列表
     
     - throws:
     */
    func saveFriendList(userId: String, list: [FriendInfoRealm]) {
        
        let friendList = FriendInfoListRealm()
        
        friendList.userId = userId
        friendList.friendListInfo = list
        
        let isUpdate = isExistFriendList(userId)
        
        do {
            
            try realm.write {
                realm.add(friendList, update: isUpdate)
            }
            
        } catch let error {
            Log.error("Save Friend List Error \(error)")
        }
        
    }
    
    /**
     是否存在好友列表
     
     - parameter userId: 用户id
     
     - returns: 存在 true 不存在 false
     */
    func isExistFriendList(userId: String) -> Bool {
        
        let list = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
        if list.count <= 0 {
            return false
        }
        
        return true
    }
    
    /**
     查询好友列表
     
     - parameter userId: 用户Id
     
     - returns: 好友列表
     */
    func queryFriendList(userId: String) -> [FriendInfoRealm]? {
        
        guard isExistFriendList(userId) else {
            return nil
        }
        
        let friendList = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
        return friendList[0].friendListInfo
    }
    
}