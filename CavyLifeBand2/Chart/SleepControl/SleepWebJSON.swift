//
//  SleepWebModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

/*

 睡眠响应JSON格式
 
 {
     "code": 1000,
     "msg": "",
     "time": 1466498836,
     "data": {
         start_date: '2016-06-18',
         end_date: '2016-06-19',
         sleep_data: [ {
             "date": "2016-06-18",
             "total_time": 820,
             "deep_time": 60 }, 
            {
             "date": "2016-06-19",
             "total_time": 20,
             "deep_time": 10 }
         ]
     }
 }
 
 */

import JSONJoy

struct NChartSleepMsg: JSONJoy, CommenResponseProtocol {
    
    // 通用消息
    var commonMsg: CommenResponse
    
    // 日期数据
    var data: SleepsData?
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        data = try SleepsData(decoder["data"])
        
    }
    
}

/**
 *  单日睡眠数据
 */
struct SleepsData: JSONJoy {
    
    // 日期 格式为"yyyy-MM-dd"
    var startDate: NSDate
    
    // 当天睡眠時長（分鐘）
    var endDate: NSDate
    
    // 当天深睡時長（分鐘）
    var sleepData: [SingleSleepData]
    
    init(_ decoder: JSONDecoder) throws {
        
        let startDateString = try decoder["start_date"].getString()
        startDate = NSDate(fromString: startDateString, format: "yyyy-MM-dd")!
        
        let endDateString = try decoder["end_date"].getString()
        endDate = NSDate(fromString: endDateString, format: "yyyy-MM-dd")!
        
        sleepData = [SingleSleepData]()
        
        guard let sleepArray = decoder["sleep_data"].array else {
            return
        }
        
        for sleep in sleepArray {
            
            sleepData.append(try SingleSleepData(sleep))
            
        }
        
    }
    
}

/**
 *  单日睡眠数据
 */
struct SingleSleepData: JSONJoy {
    
    // 日期 格式为"yyyy-MM-dd"
    var date: NSDate
    
    // 当天睡眠時長（分鐘）
    var totalTime: Int
    
    // 当天深睡時長（分鐘）
    var deepTime: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        let dateString = try decoder["date"].getString()
        date = NSDate(fromString: dateString, format: "yyyy-MM-dd")!
        
        do { totalTime = try decoder["total_time"].getInt() } catch { totalTime = 0 }
        do { deepTime  = try decoder["deep_time"].getInt() } catch { deepTime = 0 }
        
    }

}