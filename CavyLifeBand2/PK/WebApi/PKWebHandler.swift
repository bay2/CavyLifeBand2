//
//  PKWebHandler.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct PKWebHandler {
    
    var pkRecordList: PKRecordList?
    
    var userId: String {
        Log.warning("ReminderSettingVCViewModel 用户ID写死")
        
        return "1"
        
//        return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    }
    
//    /**
//     通过网络加载数据
//     */
//    func loadFriendListDataByNet() {
//        
//        ContactsWebApi.shareApi.getFriendList(userId) { (result) in
//            
//            guard result.isSuccess else {
//                
//                Log.error("Get friend list error")
//                return
//            }
//            
//            do {
//                
//                let netResult = try PKRecordList(JSONDecoder(result.value!))
//                self.parserFriendListData(netResult)
//                
//            } catch let error {
//                
//                Log.error("\(#function) result error (\(error))")
//                
//            }
//            
//        }
//    }
//    
//    
//    /**
//     解析PK列表数据
//     */
//    func parserPKRecordListData(result: PKRecordList) {
//        
//        guard result.commonMsg?.code == WebApiCode.Success.rawValue else {
//            Log.error("Query friend list error \(result.commonMsg?.code)")
//            return
//        }
//        
//        let pkRecordList = FriendInfoListRealm()
//        
//        friendList.userId = userId
//        
//        for friendInfo in result.friendInfos! {
//            
//            let friendInfoRealm = FriendInfoRealm()
//            
//            friendInfoRealm.headImage = friendInfo.avatarUrl!
//            friendInfoRealm.friendId = friendInfo.userId!
//            friendInfoRealm.nikeName = friendInfo.nickName!
//            friendInfoRealm.isFollow = friendInfo.isFoolow!
//            
//            friendList.friendListInfo.append(friendInfoRealm)
//            
//        }
//        
//        saveFriendList(friendList)
//        
//    }
}
