//
//  ChartsRealmStruct.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

// MARK: 数据显示时候的结构体

// Step 整个数据 包括总步数 总公里数 花费时长
struct StepChartsData {
    
    var datas: [PerStepChartsData] = []
    var totalStep: Int
    var totalKilometer: CGFloat
    var finishTime: Int
    var averageStep: Int
    
    
}

// Step 单条数据
struct PerStepChartsData {
    
    var time: String
    var step: Int
}


// Sleep 单条数据
struct PerSleepChartsData {
    
    var time: NSDate
    var deepSleep: Int
    var lightSleep: Int
    
}

