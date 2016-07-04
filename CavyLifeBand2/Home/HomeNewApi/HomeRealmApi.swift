//
//  HomeRealmApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import JSONJoy

protocol HomeRealmProtocol {

    var realm: Realm { set get }
    var userId: String { get }
    
    /**
     是否存在主页每日资讯
     
     - parameter timeString: 时间 yyyy-MM-dd
     
     - returns: 是否成功
     */
    func isExistHomeData(timeString: String) -> Bool
    
    /**
     添加到数据库
     
     - parameter homeList: homeList description
     
     - returns: 是否成功
     */
    func addHomeData(homeRealm: HomeLineRealm) -> Bool
    
    /**
     查询全部数据库变化的
     
     - parameter timeString: 时间 yyyy-MM-dd
     
     - returns: 查询结果
     */
    func queryHomeData(timeString: String) -> Results<(HomeLineRealm)>

}


extension HomeRealmProtocol {
    
    /**
     某一天是否存在 HomeList
     
     - parameter timeString: 时间格式 yyyy-MM-dd
     - returns: true 存在数据 false 不存在数据
     */
    func isExistHomeData(timeString: String) -> Bool {
        
        let array = realm.objects(HomeLineRealm).filter("userId = '\(userId)' AND time = '\(timeString)'")
        
        if array.count == 0 {
            
            return false
            
        } else {
            
            return true
        }
        
    }
    
    /**
     添加到数据库
     */
    func addHomeData(homeRealm: HomeLineRealm) -> Bool{
        
        do {
            
            try realm.write {
                realm.add(homeRealm, update: false)
            }
            
        } catch {
            
            Log.error("Add user info error [\(homeRealm)]")
            return false
            
        }
        
        Log.info("Add user info success")
        return true
        
    }
    
    /**
     根据时间返回当天的时间轴信息
     
     - parameter time: 格式是 yyyy-MM-dd
     
     - returns:
     */
    func queryHomeData(timeString: String) -> Results<(HomeLineRealm)> {
        
        Log.info("userId = \(userId)")
        return realm.objects(HomeLineRealm).filter("userId = '\(userId)' AND time = '\(timeString)'")
        
    }
    
}
