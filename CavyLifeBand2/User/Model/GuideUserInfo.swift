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
        
        self.sex = guideUserinfo.gender
        self.height = guideUserinfo.height
        self.weight = guideUserinfo.weight
        self.birthday = guideUserinfo.birthday
        self.isNotification = guideUserinfo.isNoitfication
        self.isLocalShare = guideUserinfo.isLocalShare
        self.stepNum = guideUserinfo.stepNum
        self.sleepTime = guideUserinfo.sleepTime
        
    }
    
    /**
     根据GuideUserInfo设置用户信息
     
     - parameter guideUserinfo: 用户信息
     */
    func setUserInfo(guideUserinfo: GuideUserInfo) {
        
        self.sex = guideUserinfo.gender
        self.height = guideUserinfo.height
        self.weight = guideUserinfo.weight
        self.birthday = guideUserinfo.birthday
        self.isNotification = guideUserinfo.isNoitfication
        self.isLocalShare = guideUserinfo.isLocalShare
        self.stepNum = guideUserinfo.stepNum
        self.sleepTime = guideUserinfo.sleepTime
    }
    
    
}

/**
 *  @author xuemincai
 *
 *  导航页用户信息
 */
struct GuideUserInfo: SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate {
    
    var userId: String
    var gender: Int
    var height: String
    var weight: String
    var birthday: String
    var isNoitfication: Bool
    var isLocalShare: Bool
    var stepNum: Int
    var sleepTime: String
    var realm: Realm = try! Realm()
    
    var userInfoPara: [String: AnyObject] {
        return [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId,
                UserNetRequsetKey.Sex.rawValue: gender,
                UserNetRequsetKey.Height.rawValue: height,
                UserNetRequsetKey.Weight.rawValue: weight,
                UserNetRequsetKey.Birthday.rawValue: birthday,
                UserNetRequsetKey.StepNum.rawValue: stepNum,
                UserNetRequsetKey.SleepTime.rawValue: sleepTime,
                UserNetRequsetKey.IsLocalShare.rawValue: isLocalShare,
                UserNetRequsetKey.IsNotification.rawValue: isNoitfication]
    }
    
    static var userInfo = GuideUserInfo()
    
    init(realm: Realm) {
        
        self.realm = realm
        userId = ""
        gender = 0
        height = ""
        weight = ""
        birthday = ""
        isNoitfication = true
        isLocalShare = true
        stepNum = 0
        sleepTime = ""
        
    }
    
    init() {
        
        self.init(realm: try! Realm())
        
    }
    
    /**
     更新用户信息
     */
    mutating func updateUserInfo() {
        
        let setUserInfoComplete: (Bool -> Void) = {
            
            guard let userInfo = self.queryUserInfo(self.userId) else {
                
                let userInfo = UserInfoModel(guideUserinfo: self)
                userInfo.isSync = $0
                self.addUserInfo(userInfo)
                
                return
            }
            
            self.realm.beginWrite()
            
            userInfo.setUserInfo(self)
            userInfo.isSync = $0
            
            self.realm.add(userInfo, update: true)
            
            do {
                
                try self.realm.commitWrite()
                
            } catch let error {
            
                Log.error("[\(#function)] update user info erro.(\(error))")
                
            }
            
        }
        
        self.setUserInfo(setUserInfoComplete)
        
    }
    
    
}