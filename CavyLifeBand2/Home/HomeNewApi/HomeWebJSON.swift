//
//  HomeWebJSON.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

/*
{
    "code": 1000,
    "msg": "",
    "time": 1466498836,
    "data": {
        start_date: '2016-06-18',
        end_date: '2016-06-19',
        dailies_data: [
        {
        "date": "2016-06-18",
        "total_steps": 820,
        "total_steps_time": 60,
        "total_sleep_time": 20,
        "total_deep_time": 10,
        "awards": [1]
        }, {
        "date": "2016-06-19",
        "total_steps": 820,
        "total_steps_time": 60,
        "total_sleep_time": 20,
        "total_deep_time": 10,
        "awards": [2, 3]
        }
        ]
    }
}
*/


import Foundation
import JSONJoy

struct HomeLineMsg: JSONJoy, CommenResponseProtocol {
    
    // 通用消息
    var commonMsg: CommenResponse
    
    // 日期数据
    var data: HomeData?
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        data = try HomeData(decoder["data"])
        
    }
    
}

struct HomeData: JSONJoy {

    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    var dailiesData: [HomeDailiesData] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        let startDateString = try decoder["start_date"].getString()
        startDate = NSDate(fromString: startDateString, format: "yyyy-MM-dd")!
        
        let endDateString = try decoder["end_date"].getString()
        endDate = NSDate(fromString: endDateString, format: "yyyy-MM-dd")!
        
        guard let dataArray = decoder["dailies_data"].array else {
            return
        }
        
        for data in dataArray {
            
            dailiesData.append(try HomeDailiesData(data))
            
        }
    
    }

}

/**
 * 
 {
 "date": "2016-06-18",
 "total_steps": 820,
 "total_steps_time": 60,
 "total_sleep_time": 20,
 "total_deep_time": 10,
 "awards": [1]
 }
 */
struct HomeDailiesData: JSONJoy {
    
    var date: NSDate = NSDate()
    var totalSteps: Int = 0
    var totalStepTime: Int = 0
    var totalSleep: Int = 0
    var totalDeepSleep: Int = 0
    var awards: [Int] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        let dateSring = try decoder["date"].getString()
        date = NSDate(fromString: dateSring, format: "yyyy-MM-dd")!
        
        do { totalSteps = try decoder["total_steps"].getInt() } catch { totalSteps = 0 }
        do { totalStepTime = try decoder["total_steps_time"].getInt() } catch { totalStepTime = 0 }
        
        do { totalSleep = try decoder["total_sleep_time"].getInt() } catch { totalSleep = 0 }
        do { totalDeepSleep = try decoder["total_deep_time"].getInt() } catch { totalDeepSleep = 0 }

        guard let awardArray = decoder["awards"].array else { return }
        
        for award in awardArray {
            
            awards.append(award.integer!)
        }
        
    }
    
}

