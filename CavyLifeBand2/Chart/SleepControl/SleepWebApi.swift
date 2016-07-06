//
//  SleepWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import JSONJoy
import RealmSwift

class SleepWebApi: NetRequest, SleepWebRealmOperate, UserInfoRealmOperateDelegate {

    static var shareApi = SleepWebApi()
    
    var realm: Realm = try! Realm()
    
    func fetchSleepWebData() {
        
        let dateTuple = calculateFetchDate()
        
        let parameters: [String: AnyObject] = [NetRequsetKey.StartDate.rawValue: dateTuple.0,
                                               NetRequsetKey.EndDate.rawValue: dateTuple.1]
        
        netGetRequest(WebApiMethod.Sleep.description, para: parameters, modelObject: NChartSleepMsg.self, successHandler: { [unowned self] (data) in
            
            // 把数据库最后一条数据删除，以防止原本的最后一条数据不是最新的
            self.deleteSleepWebRealm(startDate: NSDate(fromString: dateTuple.0, format: "yyyy-MM-dd")!,
                                       endDate: NSDate(fromString: dateTuple.0, format: "yyyy-MM-dd")!)
            
            // 把数据存到数据库
            data.data?.sleepData.forEach {
                self.addSleepWebRealm(SleepWebRealm(jsonModel: $0))
            }
            
        }) { (msg) in
            
            Log.error(msg)
            
        }
        
    }
    
    /**
     返回拉取的时间段
     
     - returns: (String, String) 开始时间，结束时间
     */
    func calculateFetchDate() -> (String, String) {
        
        let format = NSDateFormatter()
        
        format.dateFormat = "yyyy-MM-dd"
        
        let sleepData = queryUserSleepWebRealm()
        
        guard sleepData != nil && sleepData?.count > 0 else {
            
            if let userInfo: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                
                return (format.stringFromDate(userInfo.signUpDate) ,format.stringFromDate(NSDate()))
            
            } else {
                
                return ("2016-5-5", format.stringFromDate(NSDate()))
                
            }
            
        }
        
        let startDate = sleepData!.last!.date
        
        return (format.stringFromDate(startDate), format.stringFromDate(NSDate()))
        
    }
    
}
