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
import JSONJoy

protocol FriendInfoListDelegate {
    
    var realm: Realm { set get }
    var userId: String { get }
    
    func queryFriendList() -> FriendInfoListRealm?
    func saveFriendList(friendList: FriendInfoListRealm)
    func queryFriendListByLetter(letter: String) -> Results<FriendInfoRealm>?
    func isExistFriendList() -> Bool
    
}

extension FriendInfoListDelegate {
    
    /**
     查询好友列表
     
     - returns: 好友列表
     */
    func queryFriendList() -> FriendInfoListRealm? {
        
        guard isExistFriendList() else {
            return nil
        }
        
        let friendList = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
        return friendList.first
        
    }
    
    /**
     保存 friendList
     */
    func saveFriendList(friendList: FriendInfoListRealm) {
        
        let update = isExistFriendList()
        
        do {
            
            try realm.write {
                
                if update {
                    let oldList = queryFriendList()
                    realm.delete(oldList!.friendListInfo)
                    realm.add(friendList, update: true)
                } else {
                    realm.add(friendList, update: false)
                }
                
            }
            
        } catch let error {
            
            Log.error("Save friend list error \(error)")
            
        }
        
    }
    
    /**
     是否存在好友列表
     
     - returns: 存在 true 不存在 false
     */
    func isExistFriendList() -> Bool {
        
        let list = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
        if list.count <= 0 {
            return false
        }
        
        return true
    }
    
    /**
     通过首字母查询好友
     
     - parameter letter: 首字母
     
     - returns: 
     */
    func queryFriendListByLetter(letter: String) -> Results<FriendInfoRealm>? {
        
        guard let friendInfoList = queryFriendList() else {
            return nil
        }
        
        return friendInfoList.friendListInfo.filter("fullName BEGINSWITH '\(letter)'")
    }
    
}

/**
 *  @author xuemincai
 *
 *  关注好友协议
 */
protocol FollowFriendDelegate {
    
    var realm: Realm { get }
    var userId: String { get }
    
    func setFollowFriend(friendId: String, isFollow: Bool)
    
}

extension FollowFriendDelegate {
    
    /**
     设置好友关注
     
     - parameter friendId: 好友id
     - parameter isFollow: true 关注，false 不关注
     */
    func setFollowFriend(friendId: String, isFollow: Bool) {
        
        guard let friendList = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'").first else {
            return
        }
        
        guard let friendInfo = friendList.friendListInfo.filter("friendId = '\(friendId)'").first else {
            return
        }
        
        self.realm.beginWrite()
        
        friendInfo.isFollow = isFollow
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  删除好友
 */
protocol DeleteFriendDelegate {
    
    var realm: Realm { get }
    var userId: String { get }
    
    func deleteFriend(friendId: String)
    
}

extension DeleteFriendDelegate {
    
    func deleteFriend(friendId: String) {
        
        guard let friendList = realm.objects(FriendInfoListRealm).filter("userId = '\(userId)'").first else {
            return
        }
        
        guard let friendInfo = friendList.friendListInfo.filter("friendId = '\(friendId)'").first else {
            return
        }
        
        self.realm.beginWrite()
        
        self.realm.delete(friendInfo)
        
        do {
            try self.realm.commitWrite()
        } catch let error {
            Log.error("\(#function) error = \(error)")
        }
        
    }
    
}