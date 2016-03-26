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
    
    var friendId = ""
    var nikeName = ""
    var headImage = UIImage()
    
}

/// 好友列表
class FriendInfoListRealm: Object {
    
    dynamic var userId = ""
    dynamic var friendListInfo = [FriendInfoRealm]()
    
    override static func ignoredProperties() -> [String] {
        return ["userId"]
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    
}
