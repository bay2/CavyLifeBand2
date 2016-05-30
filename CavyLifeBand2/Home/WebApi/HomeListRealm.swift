//
//  HomeListRealm.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log

class HomeListRealm: Object {
    
    // 用户名
    dynamic var userId: String = ""
    // 时间 yyyy.M.d
    dynamic var time: String  = ""
    // 步数
    dynamic var stepCount: Int = 0
    // 睡眠时间
    dynamic var sleepTime: Int = 0
    // 成就列表
    let achieveList = List<AchieveListRealm>()
    // pk列表
    let pkList      = List<PKListRealm>()
    // 健康列表
    let healthList  = List<HealthListRealm>()
    
    
    
}

class AchieveListRealm: Object {
    
    dynamic var achieve = 0
    
}

class PKListRealm: Object {
    
    dynamic var friendName: String = ""
    dynamic var pkId: String = ""
    dynamic var status: Int = 0
    
}

class HealthListRealm: Object {
    
    dynamic var friendId: String = ""
    dynamic var friendName: String = ""
    dynamic var iconUrl: String = ""
    
}














