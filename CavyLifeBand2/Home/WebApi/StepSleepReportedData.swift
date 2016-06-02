//
//  StepSleepReportedData.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/31.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Alamofire


class StepSleepReportedData: NetRequestAdapter {
    
    static var shareApi = StepSleepReportedData()
   
    /**
     上报计步数据
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter stepInfo: 计步信息
        - NSDate: 步数生成的时间
        - Int:    步数
     
     - returns: Request
     */
    func stepsReportedDataToWebServer(stepInfo: [(NSDate, Int)]) -> Request {
        
        let stepInfos = stepInfo.map {
            ["countDate": $0.toString(format: "yyyy-MM-dd HH:mm:ss"), "stepCount": $1]
        }
        
        let para: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SetStepCount.rawValue,
                                         UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId,
                                         UserNetRequsetKey.StepsList.rawValue: stepInfos]
        
        
        return netPostRequestAdapter(CavyDefine.webApiAddr, para: para)
        
    }
    
    /**
     上报睡眠信息
     
     - author: sim cai
     - date: 2016-05-31
     
     - parameter sleepInfo: 睡眠信息
        - NSDate: 睡眠数据生成时间
        - Int:    翻身次数
     
     - returns: Request
     */
    func sleepReportedDataToWebServer(sleepInfo: [(NSDate, Int)]) -> Request {
        
        let sleepInfos = sleepInfo.map {
            ["countDate": $0.toString(format: "yyyy-MM-dd HH:mm:ss"), "rollCount": $1]
        }
        
        let para: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SetStepCount.rawValue,
                                         UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId,
                                         UserNetRequsetKey.StepsList.rawValue: sleepInfos]
        
        return netPostRequestAdapter(CavyDefine.webApiAddr, para: para)
    }
    
}