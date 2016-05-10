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
    dynamic var fullName = ""
    
    let owners = LinkingObjects(fromType: FriendInfoListRealm.self, property: "friendListInfo")
    
}

/// 好友列表
class FriendInfoListRealm: Object {
    
    dynamic var userId = ""
    let friendListInfo = List<FriendInfoRealm>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    
}
