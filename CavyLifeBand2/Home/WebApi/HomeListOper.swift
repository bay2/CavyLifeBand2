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
    
}

extension HomeListRealmProtocol {
    
    /**
     根据时间返回当天的时间轴信息
     
     - parameter time: 格式是 yyyy-MM-dd
     
     - returns:
     */
    func queryHomeList(time: String) -> HomeListRealm? {
        
        let list = realm.objects(HomeListRealm).filter("userId = '\(userId)' AND time = '\(time)'")
        
        return list.first
    }
    
    func isExistHomeList() -> Bool {
        
        let list = realm.objects(HomeListRealm).filter("userId = '\(userId)'")
        if list.count == 0 {
            
            return false
            
        } else {
            
            return true
            
        }
        
    }
    
    func saveHomeList(homeList: HomeListRealm) {
        
    }
    
    
    
}









