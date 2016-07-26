//
//  StepsDataReaml.swift
//  CavyLifeBand2
//
//  Created by Hanks on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import JSONJoy

class StepWebRealm: Object {
    
    dynamic var userId             = ""
    dynamic var date: NSDate       = NSDate()
    dynamic var totalTime: Int     = 0
    dynamic var totalStep: Int     = 0
    dynamic var kilometer: CGFloat = 0
    
    var stepList = List<StepListItem>()
    
   
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, date: NSDate, totalTime: Int, totalStep: Int, stepList: List<StepListItem>) {
        
        self.init()
        self.userId    = userId
        self.date      = date
        self.totalStep = totalStep
        self.kilometer = CGFloat(self.totalStep) * 0.0006
        self.totalTime = totalTime
        self.stepList  = stepList
    }
    
}

class StepListItem: Object {
    
    dynamic var step = 0
    
    convenience required init(step: Int) {
        
        self.init()
        self.step = step
    }
    
}

