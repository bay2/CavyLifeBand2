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


// MARK: Step
class ChartStepDataRealm: Object {
    
    dynamic var userId = ""
    dynamic var timeBucket = ""
    dynamic var time: NSDate? = nil
    dynamic var step = 0
    dynamic var kilometer = 0
    let charts = List<ChartsList>()

}

class ChartsList: Object {
    dynamic var chartName = ""
    dynamic var chartNumber: Float = 0
}


protocol ChartsRealmProtocol {
    
    var realm: Realm { get }
    
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool
    
    func queryStepData(userId: String, timeBucket: String, time: NSData) -> [ChartStepDataRealm]?
    
}


extension ChartsRealmProtocol {
    
    /**
     添加计步数据
     
     - parameter chartsInfo: 用户的计步信息
     
     - returns: 成功：true 失败： false
     */
    func addStepData(chartsInfo: ChartStepDataRealm) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(chartsInfo, update: false)
            }
            
        } catch {
            
            Log.error("Add charts info error [\(chartsInfo)]")
            return false
            
        }
        
        Log.info("Add charts info success")
        return true
        
    }
    
    /**
     查询 日周月下 某一时段的 数据信息
     
     - parameter userId:     用户ID
     - parameter timeBucket: 日周月
     - parameter time:       时间
     
     - returns:              数据数组
     */
    func queryStepNumber(userId: String, timeBucket: String) -> [ChartStepDataRealm]? {
        
        if realm.objects(ChartStepDataRealm).count == 0 {
            return nil
        }
        
        
         /// 区分 日 周 月 ？
        
        
        let dataInfo = realm.objects(ChartStepDataRealm).filter("userId == '\(userId)' AND timebucket == '\(timeBucket)' ")
        
        if dataInfo.count == 0 {
            return nil
        }
        
        var datas: [ChartStepDataRealm] = []

        for data in dataInfo {
            datas.append(data)
        }
        
        return datas
        
    }

    
 
}



/*


class ChartSleepDataRealm: Object {
    
    dynamic var userId = ""
    dynamic var timeBucket = ""
    dynamic var timeInfo: NSData = NSData()
    dynamic var chartName  = ""
    dynamic var deepNumber: Float = 0
    dynamic var lightNumber: Float = 0
    dynamic var indexNumber = 0
    dynamic var deepHour = 0
    dynamic var deepMIn = 0
    dynamic var lightHour  = 0
    dynamic var lightMIn  = 0
    dynamic var avarage  = 0
    
    override class func primaryKey() -> String? {
        return "userId"
    }
}

*/





