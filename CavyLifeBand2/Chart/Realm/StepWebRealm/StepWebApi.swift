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

class StepWebApi: NetRequest, UserInfoRealmOperateDelegate, ChartStepRealmProtocol {
    
    static var shareApi = StepWebApi()
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    func fetchStepWebData() {
    
        /// 获取
        guard let date = calculateFetchDate() else { return }
        
        let  parameters: [String: AnyObject] = [NetRequestKey.StartDate.rawValue: date.0,
                                                NetRequestKey.EndDate.rawValue: date.1]
        
        // 把数据库最后一条数据删除，以防止原本的最后一条数据不是最新的
            NetWebApi.shareApi.netGetRequest(WebApiMethod.Steps.description, para: parameters, modelObject: NChartStepData.self, successHandler: { result  in
                
                self.delWebStepRealm(NSDate(fromString: date.0, format: "yyyy-MM-dd")!, endTime: NSDate(fromString: date.0, format: "yyyy-MM-dd")!)
                
                for list in result.stepsData.stepsData {
                    
                    self.addWebStepListRealm(list)
                }

            }) { msg in
                
                
                Log.info(msg)
                Log.error("Parse Home Lists Data Error")
            }
        
    }

    /**
     返回拉取的时间段
     
     - returns: (String, String) 开始时间，结束时间
     */
    private func calculateFetchDate() -> (String, String)? {
        
        let format = NSDateFormatter()
        
        format.dateFormat = "yyyy-MM-dd"
        
        let stepData = queryAllWebStepRealm()//  queryUserSleepWebRealm()
        
        guard stepData != nil && stepData?.count > 0 else {
            
            if let userInfo: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                
                return (format.stringFromDate(userInfo.signUpDate), format.stringFromDate(NSDate()))
                
            } else {
                
                return nil
                
            }
            
        }
        
        let startDate = stepData!.last!.date
        
        return (format.stringFromDate(startDate), format.stringFromDate(NSDate()))
        
    }
    
    
    //  从服务器获取数据存入表
    private func addWebStepListRealm(list: StepsDataItem) {
    
        let stepList = List<StepListItem> ()
    
        for item in list.hours {
    
            let  stepItem = StepListItem(step: item.steps)
    
            stepList.append(stepItem)
        }
    
        self.addWebStepRealm(StepWebRealm(userId: self.userId, date: list.date!, totalTime: list.totalTime, totalStep: list.totalSteps, stepList: stepList))
    
    }

    // 删除某条数据
    private func deleteStepDataWithDate(searchDate: String) {
    
        guard let time = NSDate(fromString: searchDate, format: "yyyy-MM-dd") else {
            Log.error("Time from erro [\(searchDate)]")
            return
        }
        
        self.delWebStepRealm(time, endTime: time)

    }

    
}


