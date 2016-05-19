//
//  GuideUserInfo.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import RealmSwift
import Log

extension UserInfoModel {
    
    convenience init(guideUserinfo: GuideUserInfo) {
        
        self.init()
       
        self.userId         = guideUserinfo.userId
        self.sex            = guideUserinfo.gender
        self.height         = guideUserinfo.height
        self.weight         = guideUserinfo.weight
        self.birthday       = guideUserinfo.birthday
        self.isNotification = guideUserinfo.isNoitfication
        self.isLocalShare   = guideUserinfo.isLocalShare
        self.stepNum        = guideUserinfo.stepNum
        self.sleepTime      = guideUserinfo.sleepTime
        
    }
    
    /**
     根据GuideUserInfo设置用户信息
     
     - parameter guideUserinfo: 用户信息
     */
    func setUserInfo(guideUserinfo: GuideUserInfo) {
        
        self.sex            = guideUserinfo.gender
        self.height         = guideUserinfo.height
        self.weight         = guideUserinfo.weight
        self.birthday       = guideUserinfo.birthday
        self.isNotification = guideUserinfo.isNoitfication
        self.isLocalShare   = guideUserinfo.isLocalShare
        self.stepNum        = guideUserinfo.stepNum
        self.sleepTime      = guideUserinfo.sleepTime
        
    }
    
    
}

/**
 *  @author xuemincai
 *
 *  导航页用户信息
 */
struct GuideUserInfo {
    
    var userId: String
    var gender: Int
    var height: String
    var weight: String
    var birthday: String
    var isNoitfication: Bool
    var isLocalShare: Bool
    var stepNum: Int
    var sleepTime: String

    
    static var userInfo = GuideUserInfo()
    
    init() {
        
        userId         = ""
        gender         = 0
        height         = ""
        weight         = ""
        birthday       = ""
        isNoitfication = true
        isLocalShare   = true
        stepNum        = 0
        sleepTime      = ""
        
    }
    
}

enum BindScene {
    
    case SignUpBind, SignInBind, Rebind
    
}

