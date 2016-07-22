//
//  StepWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy
import RealmSwift

class StepWebApi: NetRequest, UserInfoRealmOperateDelegate {
    
    static var shareApi = StepWebApi()
    
    var realm: Realm = try! Realm()
    
    func fetchStepWebData() {
    
        /// 获取
//   guard let dateTuple = calculateFetchDate() else { return }
        
        let  parameters: [String: AnyObject] = [NetRequestKey.StartDate.rawValue: "",
                                                NetRequestKey.EndDate.rawValue:""]
        
            NetWebApi.shareApi.netGetRequest(WebApiMethod.Steps.description, para: parameters, modelObject: NChartStepData.self, successHandler: { result  in
                
                
                // 把数据库最后一条数据删除，以防止原本的最后一条数据不是最新的
//                self.deleteSleepWebRealm(startDate: NSDate(fromString: dateTuple.0, format: "yyyy-MM-dd")!,
//                    endDate: NSDate(fromString: dateTuple.0, format: "yyyy-MM-dd")!)
//                
//                // 把数据存到数据库
//                data.data?.sleepData.forEach {
//                    self.addSleepWebRealm(SleepWebRealm(jsonModel: $0))
//                }
                
//                for list in result.stepsData.stepsData {
//                    
//                    self.addNStepListRealm(list)
//                }
//                
            }) { msg in
                
                
                Log.info(msg)
                Log.error("Parse Home Lists Data Error")
            }
        
    
    }

    /**
     返回拉取的时间段
     
     - returns: (String, String) 开始时间，结束时间
     */
//    func gainTimeBucket() -> (String, String)? {
//        
//        let format = NSDateFormatter()
//        
//        format.dateFormat = "yyyy-MM-dd"
//        
//        
//    }
    
    
}


