//
//  ChartsJSON.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions

// 数据库取出
struct ChartStepData: JSONJoy {
    
    var userId: String
    var time: NSDate? = nil
    var step: Int
    var kilometer: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        do {
            let timeString = try decoder["time"].getString()
            time = NSDate(fromString: timeString, format: "yyyy-MM-dd HH:mm:ss")
        } catch {
            time = nil
        }
        do { step = try decoder["step"].getInt() } catch { step = 0 }
        do { kilometer = try decoder["kilometer"].getInt() } catch { kilometer = 0 }

        }
    
}

// MARK: 显示数据时候的结构体
 
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










