//
//  CavyLifeBand2-Define.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import EZSwiftExtensions
import KeychainAccess

struct CavyDefine {

    
    // 服务器地址
    static let serverAddr = "http://test.tunshu.com/cavylife"
//    static let serverAddr = "http://192.168.100.214/cavylife"
    
    // 新的后台服务器地址
    static let webServerAddr = "http://pay.tunshu.com/live/api/v1/"
    
    // webApi地址
    static let webApiAddr = serverAddr + "/api.do"
    
    static let updateImgAddr = serverAddr + "/api/userIcon.do"
    
    // 邮箱验证码地址
    static let emailCodeAddr = serverAddr + "/imageCode.do"
    
    // 官网Api地址
    static let officialSiteAddr = "http://game.tunshu.com"
    
    //APP推荐地址
    static let relateAppWebApiAddr = officialSiteAddr + "/appIndex/index"
    
    // 1/25 宽度间隙
    static let spacingWidth25 = ez.screenWidth / 25
    
    // 1/25 高度间隙
    static let spacingHeight25 = ez.screenHeight / 25
    
    // 统一圆角值
    static let commonCornerRadius: CGFloat = 8 / 3
    
    // 已登录用户信息
    static var loginUserBaseInfo = LoginUserBaseInfoStorage()
    
    // 手环绑定信息
    static var bindBandInfos = BindBandInfo()
    
    // 已登录用户昵称
    static var userNickname = ""
    
    static var shareImageName: String = "CavyLifeBand2ShareImage"
    
    static var shareSDKAppKey: String = "12dda1a902dc9"
    
    static var sinaShareAppKey: String = "3896444646"
    
    static var sinaShareAppSecret: String = "aeea3f7222fb54b4f65e2be9edd7df47"
    
    static var sinaShareAppRedirectUri: String = "https://api.weibo.com/oauth2/default.html"
    
    static var qqShareAppKey: String = "1105413066"
    
    static var wechatShareAppKey: String = "wx5369dd21e588ac2b"
    
    static var wechatShareAppSecret: String = "41058772462b6033ea37a9c9f7ef0bb2"
    
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
    
    // MARK - 蓝牙连接ViewController 跳转处理
    /**
     蓝牙连接Present视图
     
     - parameter viewController:
     */
    static func bluetoothPresentViewController(viewController: UIViewController) {
        
        UIApplication.sharedApplication().keyWindow?.layer.addAnimation(CATransition(), forKey: kCATransition)
        
        UIView.animateWithDuration(0.5) {
            ez.topMostVC?.presentViewController(viewController, animated: false, completion: nil)
        }
        
    }
    
    /**
     蓝牙连接dismis视图
     */
    static func bluetoothDismisViewController() {
        
        UIApplication.sharedApplication().keyWindow?.layer.addAnimation(CATransition(), forKey: kCATransition)
        
        UIView.animateWithDuration(0.5) {
            ez.topMostVC?.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
}

// MARK: - 已登录的用户基本信息，存储NSUserDefaults

/**
   已登录用户基本信息
 
   - Author:
    xuemincai
 
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
 已登录用户信息
 
 - Author:
 xuemincai
 
 */
struct LoginUserBaseInfo {
    
    var loginUserId: String
    var loginUsername: String
    var loginAvatar: String
    var loginAuthToken: String
    
    init(dictionary: [String: AnyObject]) {

        loginUserId   = (dictionary["SignUserId"] as? String) ?? ""
        loginUsername = (dictionary["SignUserName"] as? String) ?? ""
        loginAvatar = (dictionary["SignUserAvatar"] as? String) ?? ""
        loginAuthToken = (dictionary["SignUserAuthToken"] as? String) ?? ""
        
    }
    
    func serialize() -> [String: AnyObject] {
        return ["SignUserId": loginUserId, "SignUserName": loginUsername, "SignUserAvatar": loginAvatar, "SignUserAuthToken": loginAuthToken]
//        return ["SignUserId": loginUserId, "SignUserName": loginUsername, "SignUserAvatar": loginAvatar, "SignUserAuthToken": "sX9oLibbpvsZmpNYe"]
        
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

// MARK: - 手环绑定信息存储 KeyChain
/**
 *  手环绑定信息
 */
struct BindBandInfo {
    
    private let keychain = Keychain(service: "com.cavytech.CavyLifeBand2")
    
    var bindBandInfo: BindBandInfoStorage {
        
        didSet {
            save()
        }
        
    }
    
    init() {
        
        guard let userMac = keychain[data: "CavyUserMAC"] else {
            
            self.bindBandInfo = BindBandInfoStorage(defaultBindBand: keychain["CavyGameMAC"] ?? "", userBindBand: [:])
            return
            
        }
        
        guard let userBindBand = NSKeyedUnarchiver.unarchiveObjectWithData(userMac) as? [String: NSData] else {
            self.bindBandInfo = BindBandInfoStorage(defaultBindBand: keychain["CavyGameMAC"] ?? "", userBindBand: [:])
            return
        }
        
        self.bindBandInfo = BindBandInfoStorage(defaultBindBand: keychain["CavyGameMAC"] ?? "", userBindBand: userBindBand)
        
    }
    
    private func save() {
        
        keychain["CavyGameMAC"] = bindBandInfo.defaultBindBand
        keychain[data: "CavyUserMAC"] = NSKeyedArchiver.archivedDataWithRootObject(bindBandInfo.userBindBand)
        
    }
    
    
}

struct BindBandInfoStorage {
    
    var defaultBindBand: String
    var userBindBand: [String: NSData]
    
    
}



// MARK: - 通知消息定义


enum NotificationName: String {
    
    case HomeLeftOnClickMenu           // 点击左侧菜单
    case HomePushView                  // 跳转页面
    case HomeShowHomeView              // 显示主页
    case HomeRightOnClickMenu          // 点击右侧菜单
    case HomeLeftAccountInfo           // 点击左侧头像，账号信息
    case ReminderPhoneSwitchChange     // 提醒电话的开关改变
    case ReminderPhoneScrollToSelect   // 提醒电话picker被滑动
    

    case ContactsFirendReqDeleteItem
    case HomeShowStepView                   // 主页push 计步页面
    case HomeShowSleepView                  // 主页push 睡眠页面
    case HomeShowPKView                     // 主页push PK页面
    case HomeShowAchieveView                  // 主页push 徽章页面
    case HomeShowHealthyView                // 主页push 健康页面
    
}


// MARK: - 服务器返回码定义

enum WebApiCode: String {

    case Success               = "0000"
    case ParaError             = "1000"
    case UserPasswdError       = "1001"
    case PhoneNumError         = "1002"
    case SecurityCodeError     = "1003"
    case MobifyUserError       = "1004"
    case UserExisted           = "1005"
    case UserNotExisted        = "1006"
    case SendSecutityCodeError = "1007"
    case SystemError           = "5001"
    case DBError               = "5002"
    case NetError
    
    init(apiCode: String) {
        switch apiCode {
        case "0000":
            self = WebApiCode.Success
        case "1000":
            self = WebApiCode.ParaError
        case "1001":
            self = WebApiCode.UserPasswdError
        case "1002":
            self = WebApiCode.PhoneNumError
        case "1003":
            self = WebApiCode.SecurityCodeError
        case "1004":
            self = WebApiCode.MobifyUserError
        case "1005":
            self = WebApiCode.UserExisted
        case "1006":
            self = WebApiCode.UserNotExisted
        case "1007":
            self = WebApiCode.SendSecutityCodeError
        case "5001":
            self = WebApiCode.SystemError
        case "5002":
            self = WebApiCode.DBError
        default:
            self = WebApiCode.NetError
        }
    
    }
}

extension WebApiCode: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .Success:
            return ""
        case .ParaError:
            return L10n.WebErrorCode1000.string
        case .UserPasswdError:
            return L10n.WebErrorCode1001.string
        case .PhoneNumError:
            return L10n.WebErrorCode1002.string
        case .SecurityCodeError:
            return L10n.WebErrorCode1003.string
        case .MobifyUserError:
            return L10n.WebErrorCode1004.string
        case .UserExisted:
            return L10n.WebErrorCode1005.string
        case .UserNotExisted:
            return L10n.WebErrorCode1006.string
        case .SendSecutityCodeError:
            return L10n.WebErrorCode1007.string
        case .SystemError:
            return L10n.WebErrorCode5001.string
        case .DBError:
            return L10n.WebErrorCode5002.string
        case .NetError:
            return L10n.UserModuleErrorCodeNetAPIError.string
        }
    
    }

}

// web Get接口错误码定义
enum WebGetApiCode: String {
    case Success = "1001"
    case Unknown = "9001"
    
    init(apiCode: String) {
        switch apiCode {
        case "0000":
            self = WebGetApiCode.Success
        default:
            self = WebGetApiCode.Unknown
        }
        
    }
    
}

extension WebGetApiCode: CustomStringConvertible {
    var description: String {
        
        switch self {
        case .Success:
            return ""
        case .Unknown:
            return L10n.UserModuleErrorCodeUnknownError.string
        }
        
    }
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
 - PhoneList: 电话号码列表
 - Version: 固件当前版本
 */
enum UserNetRequsetKey: String {
    
    case Cmd             = "cmd"
    case PhoneNum        = "phoneNum"
    case Passwd          = "pwd"
    case SecurityCode    = "authCode"
    case UserName        = "user"
    case UserID          = "userId"
    case Avater          = "imgFile"
    case FriendID        = "friendId"
    case Flag            = "flag"
    case FriendIdList    = "friendIds"
    case Operate         = "operate"
    case NickName        = "nickname"
    case Sex             = "sex"
    case Height          = "height"
    case Weight          = "weight"
    case Birthday        = "birthday"
    case Address         = "address"
    case StepNum         = "stepNum"
    case SleepTime       = "sleepTime"
    case IsNotification  = "isNotification"
    case IsLocalShare    = "isLocalShare"
    case IsOpenBirthday  = "isOpenBirthday"
    case IsOpenHeight    = "isOpenHeight"
    case IsOpenWeight    = "isOpenWeight"
    case SearchType      = "searchType"
    case PhoneNumList    = "phoneNumList"
    case VerifyMsg       = "verifyMsg"
    case Longitude       = "longitude"
    case Latitude        = "latitude"
    case LaunchPkList    = "launchPkList"
    case UndoPkList      = "undoPkList"
    case DelPkList       = "delPkList"
    case AcceptPkList    = "acceptPkList"
    case LaunchTime      = "launchTime"
    case PKDuration      = "pkDuration"
    case PKId            = "pkId"
    case AcceptTime      = "acceptTime"
    case IsAllowWatch    = "isAllowWatch"
    case FriendReqType   = "type"
    case FileName        = "filename"
    case Name            = "name"
    case FeedbackContent = "feedback"
    case HelpList        = "helpList"
    case HelpId          = "helpId"
    case HelpTitle       = "title"
    case HelpWebUrl      = "webUrl"
    case PageSize        = "pagesize"
    case PageNum         = "pagenum"
    case AC              = "ac"
    case PhoneList       = "phoneList"
    case Remarks         = "remarks"
    case StepsList       = "stepsList"
    case Version         = "version"
    case AuthToken       = "auth-token"
}

// MARK: - 服务器接口命令
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
 - CavyLife:         获取APP推荐
 - SetEmergencyPhone 上传紧急联系人电话号码列表
 - GetFriendInfo     查询好友信息
 - SetFriendRemark   设置好友备注
 - SendEmergencyMsg  发送紧急消息
 - GetEmergencyPhone 查询紧急联系人列表
 - GetVersion        查询版本信息
 */
enum UserNetRequestMethod: String {
    
    case SendSecurityCode  = "sendAuthCode"
    case SignUp            = "userReg"
    case SignIn            = "userLogin"
    case UpdateAvatar      = "setUserIcon"
    case ForgotPwd         = "resetPsw"
    case UserProfile       = "getUserInfo"
    case SetUserProfile    = "setUserInfo"
    case GetFriendList     = "getFriendList"
    case SearchFriend      = "searchFriend"
    case AddFriend         = "addFriend"
    case GetFriendReqList  = "getFriendReqList"
    case FollowFriend      = "followUser"
    case DeleteFriend      = "deleteFriend"
    case ReportCoordinate  = "setUserLBS"
    case GetPKRecordList   = "getPkList"
    case LaunchPK          = "launchPK"
    case UndoPK            = "undoPK"
    case DeletePK          = "delePK"
    case AcceptPK          = "acceptPK"
    case GetHelpList       = "getHelpList"
    case SubmitFeedback    = "submitFeedback"
    case GetPKInfo         = "getPKInfo"
    case CavyLife          = "cavylife"
    case SetEmergencyPhone = "setEmergencyPhone"
    case GetFriendInfo     = "getFriendInfo"
    case SetFriendRemark   = "setFriendRemark"
    case SendEmergencyMsg  = "sendEmergencyMsg"
    case GetEmergencyPhone = "getEmergencyPhone"
    case SetStepCount      = "setStepCount"
    case GetVersion        = "getVersion"
}


// MARK: - Web Api 方法定义
enum WebApiMethod: CustomStringConvertible {
    case Login, Logout, Dailies, Steps, Sleep, UsersProfile, Firmware, EmergencyContacts, Emergency

    var description: String {
        
        switch self {
        case .Login:
            return CavyDefine.webServerAddr + "login"
        case .Logout:
            return CavyDefine.webServerAddr + "logout"
        case .Dailies:
            return CavyDefine.webServerAddr + "dailies"
        case .Steps:
            return CavyDefine.webServerAddr + "steps"
        case .Sleep:
            return CavyDefine.webServerAddr + "sleep"
        case .UsersProfile:
            return CavyDefine.webServerAddr + "users/profile"
        case .Firmware:
            return CavyDefine.webServerAddr + "firmware"
        case .EmergencyContacts:
            return CavyDefine.webServerAddr + "emergency/contacts"
        case .Emergency:
            return CavyDefine.webServerAddr + "emergency"
        }
        
    }
    
}

// MARK: - Web Api 参数定义
enum NetRequsetKey: String {
    
    case UserName = "username"
    case Password = "password"
    case Profile = "profile"
    case Nickname = "nickname"
    case Address = "address"
    case Sex = "sex"
    case Height = "height"
    case Weight = "weight"
    case Figure = "figure"
    case Birthday = "birthday"
    case StepsGoal = "steps_goal"
    case SleepTimeGoal = "sleep_time_goal"
    case EnableNotification = "enable_notification"
    case ShareLocation = "share_location"
    case ShareBirthday = "share_birthday"
    case ShareHeight = "share_height"
    case ShareWeight = "share_weight"
    case Contacts = "contacts"
    case Name = "name"
    case Phone = "phone"
    case Longitude = "longitude"
    case Latitude = "latitude"
    case StartDate = "start_date"
    case EndDate   = "end_date"
    case Date      = "date"
    case Time      = "time"
    case Tilts     = "tilts"
    case Steps     = "steps"
    case Raw       = "raw"
    case TimeScale = "time_scale"
    
}



// MARK: - Request Api Code

enum RequestApiCode: Int {
    
    case Success            = 1000
    case UukownError        = 1100
    case IncorrectParameter = 1102
    case LostAccountField   = 1200
    case LostPasswordField  = 1201
    case AccountNotExist    = 1202
    case LoginFailed        = 1203
    case LogoutFailed       = 1204
    case InvalidToken       = 1205
    case NetError           = 9999
    
    init(apiCode: Int) {
        
        switch apiCode {
        case 1000:
            self = RequestApiCode.Success
        case 9999:
            self = RequestApiCode.NetError
        default:
            self = RequestApiCode.NetError
        }
        
    }
    
}

extension RequestApiCode: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .Success:
            return ""
        case .NetError:
            return L10n.UserModuleErrorCodeNetError.string
        default:
            return L10n.UserModuleErrorCodeNetError.string
        }
        
    }
    
}

