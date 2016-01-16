//
//  UserRequestData.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Alamofire
import Log

class NetRequestData: NSObject {
    
    /*!
    网络请求API
    
    - PhoneNum: 手机号
    */
    enum NetRequestParaKey: String {
        
        case PhoneNum =  "phoneNum"
        
    }
    
    enum Method: String {
        
        //发送短信验证码
        case SMSCode
        
        //用户注册
        case SignUp
        
        //用户登录
        case SignIn
        
        //找回密码
        case ForgotPwd
        
        //查询用户信息
        case UserProfile
        
        //设置用户信息
        case SetUserProfile
        
        //获取推荐好友
        case RecommendFriends
        
        //查询好友
        case SearchFriends
        
        //添加好友
        case AddFriends
        
        //上报坐标
        case ReportLocation
    }
    
    /**
     网络请求错误类型
     
     - NetErr:    网络错误
     - NetAPIErr: API接口错误
     - ParamErr:  参数错误
     */
    enum UserRequestErrorType: ErrorType {
        case NetErr, NetAPIErr, ParamErr
    }
    
    /**
     
     - parameter method:     请求类型
     - parameter parameters: 参数
     */
    func netRequestApi(method: Method, parameters: [String: AnyObject]? = nil) {
        
        switch method {
        case .SMSCode:
            requestSMSCode(parameters!)
            
        default:
            Log.error("methoe Invalid (\(method))")
            
        }
        
    }
    
    /**
     请求短信验证码
     
     - parameter parameters: 参数 PhoneNum
     */
    func requestSMSCode(parameters: [String: AnyObject]) {
        
        let urlString = serverAddr + ""
        
        Alamofire.request(.GET, urlString, parameters: ["foo": "bar"]).responseJSON { (response) -> Void in
            
        }
        
    }
    

}
