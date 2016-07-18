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
        self.stepGoal       = guideUserinfo.stepGoal
        self.sleepGoal      = guideUserinfo.sleepGoal
        
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
        self.stepGoal       = guideUserinfo.stepGoal
        self.sleepGoal      = guideUserinfo.sleepGoal
        
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
    var height: Double
    var weight: Double
    var birthday: String
    var isNoitfication: Bool
    var isLocalShare: Bool
    var stepGoal: Int
    var sleepGoal: Int

    
    static var userInfo = GuideUserInfo()
    
    init() {
        
        userId         = ""
        gender         = 0
        height         = 0.0
        weight         = 0.0
        birthday       = ""
        isNoitfication = true
        isLocalShare   = true
        stepGoal       = 0
        sleepGoal      = 0
        
    }
    
}

enum BindScene {
    
    case SignUpBind, SignInBind, Rebind
    
}

