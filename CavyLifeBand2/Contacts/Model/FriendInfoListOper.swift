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

var friendInfoListRealm = try! Realm()
class FriendInfoListOper {
    
    static var shareApi = FriendInfoListOper()
    
    /**
     保存好友列表
     
     - parameter userId: 用户id
     - parameter list:   好友列表
     
     - throws:
     */
    func saveFriendList(userId: String, list: List<FriendInfoRealm>) {
        
        let friendList = FriendInfoListRealm()
        
        friendList.userId = userId
        friendList.friendListInfo = list
        
        let isUpdate = isExistFriendList(userId)
        
        friendInfoListRealm.beginWrite()
        
        do {
            
            friendInfoListRealm.add(friendList, update: isUpdate)
            try friendInfoListRealm.commitWrite()
            
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
        
        let list = friendInfoListRealm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
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
    func queryFriendList(userId: String) -> List<FriendInfoRealm>? {
        
        Log.info("\(friendInfoListRealm.path)")
        
        guard isExistFriendList(userId) else {
            return nil
        }
        
        let friendList = friendInfoListRealm.objects(FriendInfoListRealm).filter("userId = '\(userId)'")
        
        return friendList[0].friendListInfo
    }
    
    /**
     解析好友列表数据
     
     - parameter result:
     */
    func parserFriendListData(result: ContactsFriendListMsg) -> FriendInfoListRealm? {
        
        guard result.commonMsg?.code == WebApiCode.Success.rawValue else {
            
            Log.error("Query friend list error \(result.commonMsg?.code)")
            return nil
            
        }
        
        let friendInfoListRealm = FriendInfoListRealm()
        
        if result.friendInfos?.count < 0 {
            friendInfoListRealm.friendListInfo = List<FriendInfoRealm>()
            return friendInfoListRealm
        }
        
        for friendInfo in result.friendInfos! {
            
            let friendInfoRealm = FriendInfoRealm()
            
            friendInfoRealm.headImage = friendInfo.avatarUrl!
            friendInfoRealm.friendId = friendInfo.userId!
            friendInfoRealm.nikeName = friendInfo.nickName!
            friendInfoRealm.isFollow = friendInfo.isFoolow!
            
            friendInfoListRealm.friendListInfo.append(friendInfoRealm)
            
        }
        
        return friendInfoListRealm
        
    }
    
    /**
     通过网络加载数据
     */
    func loadFriendListDataByNet(userId: String) {
        
        ContactsWebApi.shareApi.getFriendList(userId) { (result) in
            
            guard result.isSuccess else {
                
                Log.error("Get friend list error")
                return
            }
            
            do {
                
                let netResult = try ContactsFriendListMsg(JSONDecoder(result.value!))
                let friendInfoList = self.parserFriendListData(netResult)
                
                self.saveFriendList(userId, list: friendInfoList!.friendListInfo)
                
            } catch let error {
                
                Log.error("\(#function) result error (\(error))")
                
            }
            
        }
        
    }
    
}