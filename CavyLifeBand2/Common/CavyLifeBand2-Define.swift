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
    
    // webApi地址
    static let webApiAddr = serverAddr + "/api.do"
    
    // 邮箱验证码地址
    static let emailCodeAddr = serverAddr + "/imageCode.do"
    
    // 1/25 宽度间隙
    static let spacingWidth25 = ez.screenWidth / 25
    
    // 1/25 高度间隙
    static let spacingHeight25 = ez.screenHeight / 25
    
    // 统一圆角值
    static let commonCornerRadius: CGFloat = 8 / 3
    
    // 已登录用户信息
    static var loginUserBaseInfo = LoginUserBaseInfoStorage()
    
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
    
    init(dictionary: [String: AnyObject]) {
        
        loginUserId = (dictionary["SignUserId"] as? String) ?? ""
        loginUsername = (dictionary["SignUserName"] as? String) ?? ""
        
    }
    
    func serialize() -> [String: AnyObject] {
        return ["SignUserId": loginUserId, "SignUserName": loginUsername]
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
    case HomeLeftOnClickCellPushView
    case HomeLeftHiddenMenu
    case HomeLeftAccountInfo
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