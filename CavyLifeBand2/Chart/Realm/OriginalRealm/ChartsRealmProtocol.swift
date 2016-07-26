//
//  ChartsDataRealm.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import Alamofire
import Realm

// MARK: 计步睡眠数据库操作协议

protocol ChartsRealmProtocol: ChartStepRealmProtocol, SleepWebRealmOperate, UserInfoRealmOperateDelegate {
    
    var realm: Realm { get }
    var userId: String { get }
    
    // MARK: Other
    func queryTimeBucketFromFirstDay() -> [String]?
    
    // MARK: 计步
    func queryAllWebStepRealm(userId: String) -> Results<(ChartStepDataRealm)>
    func addWebStepRealm(chartsInfo: ChartStepDataRealm) -> Bool
    func queryStepNumber(beginTime: NSDate, endTime: NSDate, timeBucket: TimeBucketStyle) -> StepChartsData
    func removeStepData(chartsInfo: ChartStepDataRealm) -> Bool
    func delecSteptDate(beginTime: NSDate, endTime: NSDate) -> Bool
    
    // MARK: 睡眠
    func queryAllSleepInfo(userId: String) -> Results<(ChartSleepDataRealm)>
    func addSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    func querySleepNumber(beginTime: NSDate, endTime: NSDate) -> [PerSleepChartsData]
    func querySleepInfoDays(beginTime: NSDate, endTime: NSDate) -> [(Double, Double, Double)]
    func queryTodaySleepInfo() -> (Double, Double, Double)
    func removeSleepData(chartsInfo: ChartSleepDataRealm) -> Bool
    
}

// MARK: Other Extension
extension ChartsRealmProtocol {
    
    func queryAllWebStepRealm(userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) -> Results<(ChartStepDataRealm)> {
        
        return realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'").sorted("time", ascending: true)
        
    }
    
    // 返回 第一天开始的时间段
    func queryTimeBucketFromFirstDay() -> [String]? {
        
        guard let realmUserInfo: UserInfoModel = queryUserInfo(userId) else {
            return [NSDate().toString(format: "yyyy.M.d")]
        }
        
        let signDate = realmUserInfo.signUpDate ?? NSDate()
        
        return signDate.untilTodayArrayWithFormatter("yyyy.M.d")
    }
    
}





