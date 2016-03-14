//
//  CavyLifeBand2-Define.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import EZSwiftExtensions

// 异常上报服务器地址
let bugHDKey = "https://collector.bughd.com/kscrash?key=9c009d806879cec4233b3b66b4264315"

// 服务器地址
let serverAddr = "http://115.28.144.243/cavylife"

// webApi地址
let webApiAddr = serverAddr + "/api.do"

// 邮箱验证码地址
let emailCodeAddr = serverAddr + "/imageCode.do"

// 1/25 宽度间隙
let spacingWidth25 = ez.screenWidth / 25

// 1/25 高度间隙
let spacingHeight25 = ez.screenHeight / 25

// 宽度
//let ez.screenWidth = UIScreen.mainScreen().bounds.width

// 统一圆角值
let commonCornerRadius: CGFloat = 8 / 3

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