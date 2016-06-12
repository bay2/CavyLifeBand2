//
//  ChartsWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import JSONJoy
import EZSwiftExtensions

class ChartsWebApi: NetRequestAdapter {
    
    static var shareApi = ChartsWebApi()
    
    /**
     计步的时间段数据  
     */
    func parseStepChartsData(startDate: String? = "", endDate: String? = "", callBack: CompletionHandlernType? = nil) {
        
        var parameters: [String: AnyObject] = ["cmd": "getStepCount", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, "startDate": startDate!, "endDate": endDate!]
        
        if startDate == "" && endDate == ""  {
            parameters = ["cmd": "getStepCount", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
        }
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     睡眠的时间段数据
     */
    func parseSleepChartsData(startDate: String? = "", endDate: String? = "", callBack: CompletionHandlernType? = nil) {
        
        var parameters: [String: AnyObject] = ["cmd": "getSleepInfo", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, "startDate": startDate!, "endDate": endDate!]
        
        if startDate == "" && endDate == ""  {
            parameters = ["cmd": "getSleepInfo", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
        }
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
 
}
// MARK: 计步结构体
struct ChartStepMsg: JSONJoy {
    
    var commonMsg: CommenMsg
    var stepList: [StepMsg]
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        guard let resultList = decoder["stepList"].array else { throw JSONError.WrongType}
        var tempList = [StepMsg]()
        for list in resultList {
            tempList.append(try StepMsg(list))
        }
        stepList = tempList
    }
    
}

struct StepMsg: JSONJoy {
    
    var dateTime: String //	日期，格式为"yyyy-MM-dd hh:mm:ss"
    var stepCount: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do { dateTime = try decoder["dateTime"].getString() } catch { dateTime = "" }
        do { stepCount = try decoder["stepCount"].getInt() } catch { stepCount = 0 }
        
    }
    
}

// MARK: 睡眠结构体
struct ChartSleepMsg: JSONJoy {
    
    var commonMsg: CommenMsg
    var sleepList: [SleepMsg]
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        guard let resultList = decoder["sleepList"].array else { throw JSONError.WrongType}
        var tempList = [SleepMsg]()
        for list in resultList {
            tempList.append(try SleepMsg(list))
        }
        sleepList = tempList
    }
    
}

struct SleepMsg: JSONJoy {
    
    var dateTime: String //	日期，格式为"yyyy-MM-dd hh:mm:ss"
    var rollCount: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do { dateTime = try decoder["dateTime"].getString() } catch { dateTime = "" }
        do { rollCount = try decoder["rollCount"].getInt() } catch { rollCount = 0 }
        
    }
    
}

