//
//  WeatherWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy 


class HomeWeatherWebApi: NetRequestAdapter {
    
    static var shareApi = HomeWeatherWebApi()
    
    
    func parseWeatherData(loction: String, callBack: CompletionHandlernType? = nil) {
        
        let  parameters: [String: AnyObject] = ["cmd": "getWeather", "city": loction]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}


struct HomeWeatherMsg: JSONJoy {
    
    /// 天气状况
    var cond: String?
    /// 温度
    var tmp: String?
    /// pm2.5
    var pm25: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { cond = try decoder["cond"].getString() } catch { cond = "" }
        do { tmp = try decoder["tmp"].getString() } catch { tmp = "" }
        do { pm25 = try decoder["pm25"].getInt() } catch { pm25 = 0 }
        
    }
    
    
}
