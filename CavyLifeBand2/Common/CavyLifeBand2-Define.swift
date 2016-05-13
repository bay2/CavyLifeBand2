//
//  CavyLifeBand2-Define.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import EZSwiftExtensions

struct CavyDefine {
    
    // 异常上报服务器地址
    static let bugHDKey = "https://collector.bughd.com/kscrash?key=9c009d806879cec4233b3b66b4264315"
    
    // 服务器地址
    static let serverAddr = "http://115.28.144.243/cavylife"
//    static let serverAddr = "http://192.168.100.214/cavylife"
    
    // webApi地址
    static let webApiAddr = serverAddr + "/api.do"
    
    static let updateImgAddr = serverAddr + "/api/userIcon.do"
    
    // 邮箱验证码地址
    static let emailCodeAddr = serverAddr + "/imageCode.do"
    
    // 官网Api地址
    static let officialSiteAddr = "http://game.tunshu.com"
    
    //相关App地址
    static let relateAppWebApiAddr = officialSiteAddr + "/appIndex/index"
    
    // 1/25 宽度间隙
    static let spacingWidth25 = ez.screenWidth / 25
    
    // 1/25 高度间隙
    static let spacingHeight25 = ez.screenHeight / 25
    
    // 统一圆角值
    static let commonCornerRadius: CGFloat = 8 / 3
    
    // 已登录用户信息
    static var loginUserBaseInfo = LoginUserBaseInfoStorage()
    
    // 已登录用户昵称
    static var userNickname = ""
    
    /**
     性别数字转汉字
     
     - parameter sex: 性别标识
     
     - returns: 性别
     */
    static func definiteAccountSex(sex: String) -> String {
        
        var accountSex = L10n.ContactsGenderGirl.string
        
        if sex == "0" {
            
            accountSex = L10n.ContactsGenderBoy.string
            
        }
        
        return accountSex
    }
    
    
}

/**
 *  @author xuemincai
 *
 *  已登录用户基本信息
 */
struct LoginUserBaseInfoStorage {
    
    private var userDefaults: LoginStorage
    var loginUserInfo: LoginUserBaseInfo {
        didSet {
            save()
        }
    }
    
    init() {
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        let userBaseInfo = userDefaults.objectForKey("SignUserBaseInfo") as? [String: AnyObject] ?? [:]
        
        loginUserInfo = LoginUserBaseInfo(dictionary: userBaseInfo)
        
    }
    
    private func save() {
        
        userDefaults.setObject(loginUserInfo.serialize(), forKey: "SignUserBaseInfo")
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  已登录用户信息
 */
struct LoginUserBaseInfo {
    
    var loginUserId: String
    var loginUsername: String
    var loginAvatar: String
    
    
    init(dictionary: [String: AnyObject]) {
        
        loginUserId = (dictionary["SignUserId"] as? String) ?? ""
        loginUsername = (dictionary["SignUserName"] as? String) ?? ""
        loginAvatar = (dictionary["SignUserAvatar"] as? String) ?? ""
        
    }
    
    func serialize() -> [String: AnyObject] {
        return ["SignUserId": loginUserId, "SignUserName": loginUsername, "SignUserAvatar": loginAvatar]
    }
    
}

/**
 *  @author xuemincai
 *
 *  存储协议
 */
protocol LoginStorage {
    func objectForKey(key: String) -> AnyObject?
    func setObject(object: AnyObject?, forKey: String)
}

extension NSUserDefaults: LoginStorage { }

/**
 消息定义
 
 - HomeLeftOnClickMenu:         点击菜单
 - HomeLeftOnClickCellPushView: 点击list
 - HomeLeftHiddenMenu:          隐藏菜单
 - HomeLeftAccountInfo:         点头像
 */
enum NotificationName: String {
    
    case HomeLeftOnClickMenu
    case HomePushView
    case HomeShowHomeView
    case HomeRightOnClickMenu
    case HomeLeftAccountInfo
    case ReminderPhoneSwitchChange
    case ReminderPhoneScrollToSelect
    case ContactsFirendReqDeleteItem
    
}


// web 接口错误码定义
enum WebApiCode: String {

    case Success = "0000"
    case ParaError = "1000"
    case UserPasswdError = "1001"
    case PhoneNumError = "1002"
    case SecurityCodeError = "1003"
    case MobifyUserError = "1004"
    case UserExisted = "1005"
    case UserNotExisted = "1006"
    case SendSecutityCodeError = "1007"
    case SystemError = "5001"
    case DBError = "5002"
}

// web Get接口错误码定义
enum WebGetApiCode: String {
    case Success = "1001"
}

/**
 web api参数
 
 - PhoneNum:     手机号
 - Email:        邮箱
 - Passwd:       密码
 - SecurityCode: 验证码
 - UserName:     用户名
 - UserID:       用户ID
 - Avater:       头像
 - StepNum:      步数
 - SleepTime:    睡眠时间
 - FriendID:     好友ID
 - Flag:         标识
 - Local:        坐标
 - FriendIdList: 好友列表
 - Operate:      操作
 - NickName:     昵称
 - Sex:          性别
 - Height:       身高
 - Weight:       体重
 - Birthday:     生日
 - Address:      地址
 - StepNum:      步数
 - SleepTime:    睡眠时间
 - LaunchPkList: 发起PK列表
 - UndoPkList:   撤销PK列表
 - DelPkList:    删除已完成PK列表
 - AcceptPkList: 接受PK列表
 - LaunchTime:   发起PK的时间
 - PKDuration:   PK时长
 - PKId:         PK记录的ID
 - AcceptTime:   接受PK的时间
 - IsAllowWatch: 是否好友可见
 - FriendReqType:
 - FileName:
 - Name:
 - FeedbackContent: 意见反馈内容
 */
enum UserNetRequsetKey: String {
    
    case Cmd = "cmd"
    case PhoneNum = "phoneNum"
    case Passwd = "pwd"
    case SecurityCode = "authCode"
    case UserName = "user"
    case UserID = "userId"
    case Avater = "imgFile"
    case FriendID = "friendId"
    case Flag = "flag"
    case FriendIdList = "friendIds"
    case Operate = "operate"
    case NickName = "nickname"
    case Sex = "sex"
    case Height = "height"
    case Weight = "weight"
    case Birthday = "birthday"
    case Address = "address"
    case StepNum = "stepNum"
    case SleepTime = "sleepTime"
    case IsNotification = "isNotification"
    case IsLocalShare = "isLocalShare"
    case IsOpenBirthday = "isOpenBirthday"
    case IsOpenHeight = "isOpenHeight"
    case IsOpenWeight = "isOpenWeight"
    case SearchType = "searchType"
    case PhoneNumList = "phoneNumList"
    case VerifyMsg = "verifyMsg"
    case Longitude = "longitude"
    case Latitude = "latitude"
    case LaunchPkList = "launchPkList"
    case UndoPkList = "undoPkList"
    case DelPkList = "delPkList"
    case AcceptPkList = "acceptPkList"
    case LaunchTime = "launchTime"
    case PKDuration = "pkDuration"
    case PKId = "pkId"
    case AcceptTime = "acceptTime"
    case IsAllowWatch = "isAllowWatch"
    case FriendReqType = "type"
    case FileName = "filename"
    case Name = "name"
    case FeedbackContent = "feedback"
    case PageSize = "pagesize"
    case PageNum = "pagenum"
    case AC = "ac"
    
}

/**
 网络请求API
 
 - SendSecurityCode: 发送验证码
 - SignUp:           注册
 - SignIn:           登录
 - UpdateAvatar:     上传头像
 - ForgotPwd:        找回密码
 - UserProfile:      查询个人信息
 - SetUserProfile:   设置个人信息
 - SearchFriends:    搜索好友
 - AddFriends:       添加好友
 - DelFriends:       删除好友
 - FriendsList:      查询好友列表
 - FriendsReqList:   查询请求添加好友列表
 - WatchFriend:      关注好友
 - ReportLocation:   上报坐标
 - SetTargetValue:   设置目标值
 - TargetValue:      查询目标值
 - GetPKRecordList:  查询PK列表
 - LaunchPK:         发起PK
 - UndoPK:           撤销PK
 - DeletePK:         删除已完成PK记录
 - AcceptPK:         接受PK
 - GetHelpList:      获取帮助与反馈列表
 - SubmitFeedback:   提交意见反馈
 - GetPKInfo:        获取pk信息
 - CavyLife:         获取相关App
 */
enum UserNetRequestMethod: String {
    
    case SendSecurityCode = "sendAuthCode"
    case SignUp = "userReg"
    case SignIn = "userLogin"
    case UpdateAvatar = "setUserIcon"
    case ForgotPwd = "resetPsw"
    case UserProfile = "getUserInfo"
    case SetUserProfile = "setUserInfo"
    case GetFriendList = "getFriendList"
    case SearchFriend = "searchFriend"
    case AddFriend = "addFriend"
    case GetFriendReqList = "getFriendReqList"
    case FollowFriend = "followUser"
    case DeleteFriend = "deleteFriend"
    case ReportCoordinate = "setUserLBS"
    case GetPKRecordList = "getPkList"
    case LaunchPK = "launchPK"
    case UndoPK = "undoPK"
    case DeletePK = "delePK"
    case AcceptPK = "acceptPK"
    case GetHelpList = "getHelpList"
    case SubmitFeedback = "submitFeedback"
    case GetPKInfo = "getPKInfo"
    case CavyLife = "cavylife"
}
