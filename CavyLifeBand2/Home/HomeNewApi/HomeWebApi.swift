//
//  HomeWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import JSONJoy
import Log
import EZSwiftExtensions
import RealmSwift


class HomeWebApi: NetRequest, HomeRealmProtocol {
    
    static var shareApi = HomeWebApi()
    
    var realm: Realm = try! Realm()
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    /**
     某一天的数据
     */
    
    func parserHomeLineData(startDate: String, endDate: String) {

        let parameters: [String: AnyObject] = [NetRequsetKey.StartDate.rawValue: startDate,
                                         NetRequsetKey.EndDate.rawValue: endDate]
   
        netGetRequest(WebApiMethod.Dailies.description, para: parameters, modelObject: HomeLineMsg.self, successHandler: { result in
            
            Log.info(result.data?.dailiesData)
            
            // 保存到本地
            result.data?.dailiesData.forEach {
                
                self.addHomeData(HomeLineRealm(jsonModel: $0))
                
            }
            
            }) { msg in
                
                Log.error(msg)
        }
        
        
    }
    
    
}


