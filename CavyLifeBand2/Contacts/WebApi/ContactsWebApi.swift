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
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetFriendList.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     搜索好友参数检查
     
     - parameter parametes: 参数
     
     - throws:
     */
    func checkSearchFriend(parametes: [String: AnyObject]) throws {
        
        guard let searchType = parametes[UserNetRequsetKey.SearchType.rawValue] as? Int else { throw UserRequestErrorType.SearchTypeNil }
        
        switch searchType {
            
        case SearchType.UserName.rawValue:
            if parametes.keys.contains(UserNetRequsetKey.UserName.rawValue) != true { throw UserRequestErrorType.UserNameNil }
            
        case SearchType.Nearby.rawValue:
            if parametes.keys.contains(UserNetRequsetKey.Latitude.rawValue) != true ||
               parametes.keys.contains(UserNetRequsetKey.Longitude.rawValue) != true {
                throw UserRequestErrorType.LBSNil
            }
            
        case SearchType.AddressBook.rawValue:
            if parametes.keys.contains(UserNetRequsetKey.PhoneNumList.rawValue) != true { UserRequestErrorType.PhoneNumListNil }
            
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
        para[UserNetRequsetKey.Cmd.rawValue] = UserNetRequestMethod.SearchFriend.rawValue
        para[UserNetRequsetKey.UserID.rawValue] = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: para, completionHandler: callBack)
        
    }
    
    /**
     通过用户账号搜索
     
     - parameter userName: 用户账号
     - parameter callBack: 回调
     
     - throws:
     */
    func searchFriendByUserName(userName: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.SearchType.rawValue: SearchType.UserName.rawValue,
                         UserNetRequsetKey.UserName.rawValue: userName]
        
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    
    /**
     获取推荐好友列表
     
     - parameter callBack: 回调
     
     - throws:
     */
    func getRecommendFriend(callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.SearchType.rawValue: SearchType.Recommend.rawValue]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     通过通讯录搜索好友
     
     - parameter phoneNumList: 手机号列表
     - parameter callBack:     回调
     
     - throws:
     */
    func searchFriendByAddressBook(phoneNumList: [String], callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.SearchType.rawValue: SearchType.AddressBook.rawValue,
                                              UserNetRequsetKey.PhoneNumList.rawValue: phoneNumList]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     获取附近好友
     
     - parameter lbs:      坐标
     - parameter callBack: 回调
     
     - throws:
     */
    func getNearbyFriend(longitude: String, latitude: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.SearchType.rawValue: SearchType.Nearby.rawValue,
                                              UserNetRequsetKey.Longitude.rawValue: longitude,
                                              UserNetRequsetKey.Latitude.rawValue: latitude]
        
        try searchFriend(parametes, callBack: callBack)
        
    }
    
    /**
     获取好友列表
     
     - parameter userId:   用户ID
     - parameter callBack: 回调
     */
    func getFriendReqList(userId: String, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetFriendReqList.rawValue,
                                              UserNetRequsetKey.UserID.rawValue: userId]
        
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
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.AddFriend.rawValue,
                                              UserNetRequsetKey.FriendReqType.rawValue: "1",
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId,
                                              UserNetRequsetKey.VerifyMsg.rawValue: verifyMsg]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     同意添加好友
     
     - parameter userId:    用户ID
     - parameter friendId:  好友ID
     - parameter callBack:  回调
     */
    func agreeFriend(userId: String, friendId: String, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.AddFriend.rawValue,
                                              UserNetRequsetKey.FriendReqType.rawValue: "2",
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     删除好友
     
     - parameter userId:   用户ID
     - parameter friendId: 好友ID
     - parameter callBack: 回调
     */
    func delFriend(userId: String, friendId: String, callBack: CompletionHandlernType? = nil) {
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.DeleteFriend.rawValue,
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId]
        
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
        
        let isFollow = follow ? 1 : 0
        
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.FollowFriend.rawValue,
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId,
                                              UserNetRequsetKey.Operate.rawValue: isFollow]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     查询好友信息
     
     - parameter userId:   用户Id
     - parameter friendId: 好友Id
     - parameter callBack: 回调
     */
    func getContactPersonInfo(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, friendId: String, callBack: CompletionHandlernType? = nil) throws {
        
        if friendId.characters.count == 0 {
            callBack?(.Failure(.FriendIdNil))
        }
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetFriendInfo.rawValue,
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
    /**
     修改好友备注
     
     - parameter userId:   用户Id
     - parameter friendId: 好友Id
     - parameter remark:   备注
     - parameter callBack: 回调
     
     - throws: 
     */
    func setFriendRemark(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, friendId: String, remark: String, callBack: CompletionHandlernType? = nil) {
        
        if friendId.characters.count == 0 {
            callBack?(.Failure(.FriendIdNil))
        }
        
        let parametes: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SetFriendRemark.rawValue,
                                              UserNetRequsetKey.UserID.rawValue: userId,
                                              UserNetRequsetKey.FriendID.rawValue: friendId,
                                              UserNetRequsetKey.Remarks.rawValue: remark]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parametes, completionHandler: callBack)
        
    }
    
}

