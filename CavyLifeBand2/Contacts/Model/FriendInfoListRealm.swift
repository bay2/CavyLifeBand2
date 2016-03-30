//
//  FriendInfoRealm.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift

/// 好友信息
class FriendInfoRealm: Object {
    
    dynamic var friendId = ""
    dynamic var nikeName = ""
    dynamic var headImage = ""
    dynamic var isFollow = false
    
//    override static func primaryKey() -> String? {
//        return "userId"
//    }
    
    var owners: [FriendInfoListRealm] {
        // Realm 并不会存储这个属性，因为这个属性只定义了 getter
        // 定义“owners”，和 Person.dogs 建立反向关系
        return linkingObjects(FriendInfoListRealm.self, forProperty: "friendListInfo")
    }
    
}

/// 好友列表
class FriendInfoListRealm: Object {
    
    dynamic var userId = ""
    let friendListInfo = List<FriendInfoRealm>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    
}
