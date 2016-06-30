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


class NChartStepDataRealm: Object {
    
    dynamic var userId             = ""
    dynamic var date: NSDate?
    dynamic var totalTime: Int     = 0
    dynamic var totalStep: Int     = 0
    var stepList: [StepHourCoun]   = []
    dynamic var kilometer: CGFloat = 0
   
    
    convenience init(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, date: NSDate?, totalTime: Int, totalStep: Int, stepList: [StepHourCoun] ) {
        
        self.init()
        self.userId    = userId
        self.date      = date
        self.totalStep = totalStep
        self.kilometer = CGFloat(self.totalStep) * 0.0006
        self.totalTime = totalTime
        self.stepList  = stepList
    }
    
}


// MARK: 计步数据库操作协议
protocol ChartStepRealmProtocol {
    
    var realm:  Realm  { get }
    var userId: String { get }
    
    
    func queryBeforTodayStepInfo()
    
    
}




