//
//  HomeListOper.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import JSONJoy

protocol HomeListRealmProtocol {
    
    var realm: Realm { set get }
    var userId: String { get }
    
    func isExistHomeList(timeString: String) -> Bool
    func addHomeList(homeList: HomeListRealm) -> Bool
    func queryHomeList(time: String) -> HomeListRealm?
    
}

extension HomeListRealmProtocol {
    
    /**
     根据时间返回当天的时间轴信息
     
     - parameter time: 格式是 yyyy-MM-dd
     
     - returns:
     */
    func queryHomeList(timeString: String) -> HomeListRealm? {
        
        
        if isExistHomeList(timeString) == false {
            
          return HomeListRealm()
            
        }
                
        let list = realm.objects(HomeListRealm).filter("userId = '\(userId)' AND time = '\(timeString)'")
        
        if list.count == 0 {
            
            return HomeListRealm()

        }

        return list.first
    }
    
    /**
     某一天是否存在 HomeList    
     时间格式 yyyy.M.dd
     */
    func isExistHomeList(timeString: String) -> Bool {
    
        let list = realm.objects(HomeListRealm).filter("userId = '\(userId)' AND time = '\(timeString)'")
        
        if list.count == 0 {
            
            return false
            
        } else {
            
            return true
        }

    }
    
    /**
     添加到数据库
     */
    func addHomeList(homeList: HomeListRealm) -> Bool {
        
        do {
            
            try realm.write {
                realm.add(homeList, update: false)
            }
            
        } catch {
            
            Log.error("Add user info error [\(homeList)]")
            return false
            
        }
        
        Log.info("Add user info success")
        return true

    }
    
    
    
}









