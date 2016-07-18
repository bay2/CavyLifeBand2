//
//  StepDataJson.swift
//  CavyLifeBand2
//
//  Created by Hanks on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy
import EZSwiftExtensions


/**
 *  第一层
 */
struct NChartStepData: JSONJoy, CommenResponseProtocol {
    
    var commonMsg: CommenResponse
    var stepsData: StepsData
    
    init(_ decoder: JSONDecoder) throws {
        
       commonMsg = try CommenResponse(decoder)
       stepsData = try StepsData(decoder["data"])
     
    }
    
}

/**
 *  第二层 
 
 start_date: '2016-06-18',
 end_date: '2016-06-19',
 steps_data: [
 {
 "date": "2016-06-18",
 "total_steps": 820,
 "total_time": 60,
 "hours": [
 { "steps": 100 },
 { "steps": 150 },
 
 */

struct StepsData: JSONJoy {
    
    var stepsData: [StepsDataItem]
    
    init(_ decoder: JSONDecoder) throws {
        
        stepsData = [StepsDataItem]()
        
    if  let stepDataArr = decoder["steps_data"].array  {
        
        for item in stepDataArr {
            
          stepsData.append(try StepsDataItem(item))
        }
    }
        
  }
    
}




/**
 *  第三层
 */
struct StepsDataItem: JSONJoy {
    
    var date: NSDate? = nil
    var totalSteps: Int
    var totalTime: Int
    var hours: [StepHourCoun]
    
    init(_ decoder: JSONDecoder) throws {
        
        do { let timeStr = try decoder["date"].getString()
            
            date = NSDate(fromString: timeStr, format: "yyyy-MM-dd")

        } catch { date = nil }
        
        do { totalSteps = try decoder["total_steps"].getInt() } catch { totalSteps = 0 }
        do { totalTime  = try decoder["total_time"].getInt() } catch { totalTime = 0 }
        
        hours = [StepHourCoun]()
        
        if let stepHoursArr = decoder["hours"].array {
            
            for item in stepHoursArr {
                
                hours.append(try StepHourCoun(item))
            }
        }

    }
    
}



struct StepHourCoun: JSONJoy {
    
    var steps: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do { steps = try decoder["steps"].getInt() } catch { steps = 0 }
    }
    
}


