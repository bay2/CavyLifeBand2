//
//  HomeRealm.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift

/// 数据库结构
class HomeLineRealm: Object {
    
    dynamic var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    dynamic var date: String = "" //yyyy.M.d
    
    dynamic var totalSteps: Int = 0
    
    dynamic var totalStepTime: Int = 0
    
    dynamic var totalSleep: Int = 0
    
    dynamic var totalDeepSleep: Int = 0
    
    let awards = List<AwardsRealm>()
    
}

/// 成就
class AwardsRealm: Object {
    
    dynamic var award = 0
    
    convenience init(awardValue: Int) {
        
        self.init()
        
        award = awardValue
    }
    
}

extension HomeLineRealm {
    
    /**
     用接口模型快捷初始化数据库模型
     
     - parameter jsonModel: JSONJoy 模型
     
     - returns:
     */
    convenience init(jsonModel: HomeDailiesData) {
        
        self.init()
        self.date = jsonModel.date.toString(format: "yyyy.M.d")
        self.totalSteps = jsonModel.totalSteps
        self.totalStepTime = jsonModel.totalStepTime
        self.totalSleep = jsonModel.totalSleep
        self.totalDeepSleep = jsonModel.totalDeepSleep
        for award in jsonModel.awards {
            
            self.awards.append(AwardsRealm(awardValue: award))
            
        }
        
    }
    
}


