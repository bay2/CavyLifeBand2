//
//  ContactsWebApi.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log

class ContactsWebApi: NetRequestAdapter {
    
    
    enum ContactsApiCmd: String {
        
        case GetFriendList = "getFriendList"
        case SearchFriend = "searchFriend"
        case AddFriend = "addFriend"
        case GetFriendReqList = "getFriendReqList"
        case FollowFriend = "followUser"
        case DeleteFriend = "deleteFriend"
        
    }
    
    enum ContactsApiParaKey: String {
        
        case Cmd = "cmd"
        case UserId = "userId"
        case SearchType = "searchType"
        case UserName = "user"
        case LBS = "lsb"
        case PhoneNumList = "phoneNumList"
        case FriendId = "friendId"
        case VerifyMsg = "verifyMsg"
        case IsFollow  = "operate"
        
    }
    
    enum SearchType: Int {
        
        case UserName = 1
        case Recommend = 2
        case AddressBook = 3
        case Nearby = 4
        
    }
    

    
    static var shareApi = ContactsWebApi()
    
    /**
     获取好友列表
     
     - parameter userId:   用户id
     - parameter callBack: 回调
     */
    func getFriendList(userId: String, callBack: CompletionHandlernType? = nil) {
        
        let parameters: [String: AnyObject] = [ContactsApiParaKey.Cmd.rawValue: ContactsApiCmd.GetFriendList.rawValue,
                                               ContactsApiParaKey.UserId.rawValue: userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     搜索好友参数检查
     
     - parameter parametes: 参数
     
     - throws:
     */
    func checkSearchFriend(parametes: [String: AnyObject]) throws {
        
        guard let searchType = parametes[ContactsApiParaKey.SearchType.rawValue] as? Int else { throw UserRequestErrorType.SearchTypeNil }
        
        switch searchType {
            
        case SearchType.UserName.rawValue:
            if parametes.keys.contains(ContactsApiParaKey.UserName.rawValue) != true { throw UserRequestErrorType.UserNameNil }
            
        case SearchType.Nearby.rawValue:
            if parametes.keys.contains(ContactsApiParaKey.LBS.rawValue) != true { throw UserRequestErrorType.LBSNil }
            
        case SearchType.AddressBook.rawValue:
            if parametes.keys.contains(ContactsApiParaKey.PhoneNumList.rawValue) != true { UserRequestErrorType.PhoneNumListNil }
            
        default:
            break
        }
        
    }
    
    /**
     搜索好友
     
     - parameter parametes: 参数 SearchType, UserName, LBS, PhoneNumList
     - parameter callBack:  回调
     */
    func searchFriend(parametes: [String: AnyObject], callBack: CompletionHandlernType? = nil) throws {
        
        try checkSearchFriend(parametes)
        
        var para = parametes
        para[ContactsApiParaKey.Cmd.rawValue] = ContactsApiCmd.SearchFriend.rawValue
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: callBack)
        
    }
    
    /**
     通过用户账号搜索
     
     - parameter userName: 用户账号
     - parameter callBack: 回调
     
     - throws:
     */
    func searchFriendByUserName(userName: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.SearchType.rawValue: SearchType.UserName.rawValue,
                         ContactsApiParaKey.UserName.rawValue: userName]
        
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    
    /**
     获取推荐好友列表
     
     - parameter callBack: 回调
     
     - throws:
     */
    func getRecommendFriend(callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.SearchType.rawValue: SearchType.Recommend.rawValue]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     通过通讯录搜索好友
     
     - parameter phoneNumList: 手机号列表
     - parameter callBack:     回调
     
     - throws:
     */
    func searchFriendByAddressBook(phoneNumList: [String], callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.SearchType.rawValue: SearchType.AddressBook.rawValue,
                                              ContactsApiParaKey.PhoneNumList.rawValue: phoneNumList]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     获取附近好友
     
     - parameter lbs:      坐标
     - parameter callBack: 回调
     
     - throws:
     */
    func getNearbyFriend(lbs: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.SearchType.rawValue: SearchType.Nearby.rawValue,
                                              ContactsApiParaKey.LBS.rawValue: lbs]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     获取好友列表
     
     - parameter userId:   用户ID
     - parameter callBack: 回调
     */
    func getFriendReqList(userId: String, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.Cmd.rawValue: ContactsApiCmd.GetFriendReqList.rawValue,
                                              ContactsApiParaKey.UserId.rawValue: userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     添加好友
     
     - parameter userId:    用户ID
     - parameter friendId:  好友ID
     - parameter verifyMsg: 验证消息
     - parameter callBack:  回调
     */
    func addFriend(userId: String, friendId: String, verifyMsg: String = "", callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.Cmd.rawValue: ContactsApiCmd.AddFriend.rawValue,
                                              ContactsApiParaKey.UserId.rawValue: userId,
                                              ContactsApiParaKey.FriendId.rawValue: friendId,
                                              ContactsApiParaKey.VerifyMsg.rawValue: verifyMsg]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     删除好友
     
     - parameter userId:   用户ID
     - parameter friendId: 好友ID
     - parameter callBack: 回调
     */
    func delFriend(userId: String, friendId: String, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.Cmd.rawValue: ContactsApiCmd.DeleteFriend.rawValue,
                                              ContactsApiParaKey.UserId.rawValue: userId,
                                              ContactsApiParaKey.FriendId.rawValue: friendId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     关注或取消关注好友
     
     - parameter userId:   用户ID
     - parameter friendId: 好友ID
     - parameter follow:   关注/取消关注
     - parameter callBack: 回调
     */
    func followFriend(userId: String, friendId: String, follow: Bool, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [ContactsApiParaKey.Cmd.rawValue: ContactsApiCmd.FollowFriend.rawValue,
                                              ContactsApiParaKey.UserId.rawValue: userId,
                                              ContactsApiParaKey.FriendId.rawValue: friendId,
                                              ContactsApiParaKey.IsFollow.rawValue: follow]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
}

