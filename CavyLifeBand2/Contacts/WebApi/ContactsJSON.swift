//
//  ContactsJSON.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

/**
 *  @author xuemincai
 *
 *  好友列表消息
 */
struct ContactsFriendListMsg: JSONJoy {
    
    //通用消息头
    var commonMsg: CommenMsg
    
    //好友信息
    var friendInfos: [ContactsFriendInfo] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        guard let friendInfoArray =  decoder["friendInfos"].array else {
            friendInfos = [ContactsFriendInfo]()
            return
        }
        
        for friendInfo in friendInfoArray {
            
            friendInfos.append(try ContactsFriendInfo(friendInfo))
            
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  搜索好友消息
 */
struct ContactsSearchFriendMsg: JSONJoy {
    
    //通用消息头
    var commonMsg: CommenMsg?
    
    //好友信息列表
    var friendInfos: [ContactsSearchFriendInfo]?
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        friendInfos = [ContactsSearchFriendInfo]()
        guard let friendInfoArray = decoder["friendInfos"].array else {
            return
        }
        
        for friendInfo in friendInfoArray {
            
            friendInfos!.append(try ContactsSearchFriendInfo(friendInfo))
            
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  好友信息
 */
struct ContactsFriendInfo: JSONJoy {
    
    //用户ID
    var userId: String
    
    //昵称
    var nickName: String
    
    //头像
    var avatarUrl: String
    
    //是否关注
    var isFoolow: Bool
    
    //计步数
    var stepNum: Int
    
    //睡眠时间
    var sleepTime: String?
    
    init(_ decoder: JSONDecoder) throws {
        
        isFoolow = decoder["isFollow"].bool
        
        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { stepNum = try decoder["stepNum"].getInt() } catch { stepNum = 0 }
        do { sleepTime = try decoder["sleepTime"].getString() } catch { sleepTime = "" }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  搜索好友信息
 */
struct ContactsSearchFriendInfo: JSONJoy {
    
    //用户ID
    var userId: String
    
    //匿名
    var nickName: String
    
    //头像
    var avatarUrl: String
    
    //距离
    var distance: String
   
    var phoneNum: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { distance = try decoder["distance"].getString() } catch { distance = "" }
        do { phoneNum = try decoder["phoneNum"].getString() } catch { phoneNum = "" }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  好友请求验证消息
 */
struct ContactsFriendReqMsg: JSONJoy {
    
    //通用消息头
    var commendMsg: CommenMsg?
    
    var userInfos: [ContactsFriendReqInfo] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        commendMsg = try CommenMsg(decoder)
        
        guard let userInfoArray = decoder["userInfos"].array else {
            return
        }
        
        for userInfo in userInfoArray {
            userInfos.append(try! ContactsFriendReqInfo(userInfo))
        }
        
    }
    
}

struct ContactsFriendReqInfo {
    
    //用户ID
    var userId: String
    
    //匿名
    var nickName: String
    
    //头像
    var avatarUrl: String
    
    //验证消息
    var verifyMsg: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { verifyMsg = try decoder["verifyMsg"].getString() } catch { verifyMsg = "" }
        
    }
}

/**
 *  好友详细信息
 */
struct ContactPsersonInfoResponse: JSONJoy {
    
    var commendMsg: CommenMsg
    var avatarUrl: String
    var isHonour: Bool
    var remark: String
    var sex: String
    var height: String
    var weight: String
    var birthday: String
    var stepNum: Int
    var sleepTime: String
    var address: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commendMsg = try CommenMsg(decoder)
        
        isHonour = decoder["isHonour"].bool
        
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { remark = try decoder["remark"].getString() } catch { remark = "" }
        do { sex = try decoder["sex"].getString() } catch { sex = "" }
        do { height = try decoder["height"].getString() } catch { height = "" }
        do { weight = try decoder["weight"].getString() } catch { weight = "" }
        do { birthday = try decoder["birthday"].getString() } catch { birthday = "" }
        do { stepNum = try decoder["stepNum"].getInt() } catch { stepNum = 0 }
        do { sleepTime = try decoder["sleepTime"].getString() } catch { sleepTime = "" }
        do { address = try decoder["address"].getString() } catch { address = "" }

    }

}
