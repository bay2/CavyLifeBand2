//
//  ChartJSON.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy

/**
 *  日 周 年 最大的
 */
struct StepChartView: JSONJoy {
    
    /// 日/周/月
    var timeBucket: String?
    var stepCharts: [StepCharts]?

    
    init(_ decoder: JSONDecoder) throws {
    
        do { timeBucket = try decoder[""].getString() } catch { timeBucket = "" }
        
        
        stepCharts = [StepCharts]()
        
        guard let data = decoder["charts"].array else { throw JSONError.WrongType }
        
        for chartDecoder in data {
            stepCharts?.append(try  StepCharts(chartDecoder))
        }

        
    }
    
}

/**
 *  计步每页数据 【 时间段Str & 柱状图数据 & 详情List数据】
 *  ---------------------
 *  当页数据的时间段
 *  数据数组 【2h：4km】
 *  计步详情 【今日步数 & 公里数 & 目标完成度 & 花费时长】
 *  ---------------------
 */
struct StepCharts: JSONJoy {
    
    var time: String?
    
    var charts: [PerStepChartData]?
    
    var todatStep: Int?
    var kilometer: Int?
    var percent: Int?
    var useTime: Int?

    init(_ decoder: JSONDecoder) throws {
        
        do { time = try decoder[""].getString() } catch { time = "" }
        do { todatStep = try decoder[""].getInt() } catch { todatStep = 0 }
        do { kilometer = try decoder[""].getInt() } catch { kilometer = 0 }
        do { percent = try decoder[""].getInt() } catch { percent = 0 }
        do { useTime = try decoder[""].getInt() } catch { useTime = 0 }

        charts = [PerStepChartData]()
        
        guard let data = decoder["charts"].array else { throw JSONError.WrongType }
        
        for chartDecoder in data {
            charts?.append(try  PerStepChartData(chartDecoder))
        }
        
    }

}


/**
 *  计步柱状图单条数据
 */
struct PerStepChartData: JSONJoy {
    
    var name: String?
    var number: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { name = try decoder[""].getString() } catch { name = "" }
        
        do { number = try decoder[""].getInt() } catch { number = 0 }
    }
}








/**
 *  睡眠最大的
 */
struct SleepChartView: JSONJoy {
    
    /// 日/周/月
    var timeBucket: String?
    var sleepCharts: [SleepCharts]?
    
    
    init(_ decoder: JSONDecoder) throws {
        
        do { timeBucket = try decoder[""].getString() } catch { timeBucket = "" }
        
        
        sleepCharts = [SleepCharts]()
        
        guard let data = decoder["charts"].array else { throw JSONError.WrongType }
        
        for chartDecoder in data {
            sleepCharts?.append(try  SleepCharts(chartDecoder))
        }
        
        
    }
    
}



/**
 *  睡眠每页数据 【 时间段Str & 柱状图数据 & 详情List数据】
 *  ---------------------
 *  当页数据的时间段
 *  数据数组 【4点: deep(2h30nim) & light(3h23min) 】
 *  睡眠详情 【周睡眠指数 & 深度睡眠h+min & 浅度睡眠h+min & 平均睡眠】
 *  ---------------------
 */
struct SleepCharts: JSONJoy {
    
    var time: String?
    
    var charts: [PerSleepChartData]?
    
    var indexNumber: Int?
    var deepHour: Int?
    var deepMIn: Int?
    var lightHour: Int?
    var lightMIn: Int?
    var avarage: Int?

    init(_ decoder: JSONDecoder) throws {
        
        do { time = try decoder[""].getString() } catch { time = "" }
        
        do { indexNumber = try decoder[""].getInt() } catch { indexNumber = 0 }
        do { deepHour = try decoder[""].getInt() } catch { deepHour = 0 }
        do { deepMIn = try decoder[""].getInt() } catch { deepMIn = 0 }
        do { lightHour = try decoder[""].getInt() } catch { lightHour = 0 }
        do { lightMIn = try decoder[""].getInt() } catch { lightMIn = 0 }
        do { avarage = try decoder[""].getInt() } catch { avarage = 0 }
        
        charts = [PerSleepChartData]()
        
        guard let data = decoder["charts"].array else { throw JSONError.WrongType }
        
        for chartDecoder in data {
            charts?.append(try  PerSleepChartData(chartDecoder))
        }
        
    }
    
}
/**
 *  睡眠柱状图单条数据
 */
struct PerSleepChartData: JSONJoy {
    
    var name: String?
    var deep: Int?
    var light: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { name = try decoder[""].getString() } catch { name = "" }
        do { deep = try decoder[""].getInt() } catch { deep = 0 }
        do { light = try decoder[""].getInt() } catch { light = 0 }
    }
}














