//
//  WeatherWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy


typealias WearherCallBack = (WeatherInfoMsg) -> Void

// MARK: --- new Api
class WeatherWebApi: NetRequest {
    
    var weatherCallBack: WearherCallBack?
    static var shareApi = WeatherWebApi()
    
    func parseWeatherInfo(location: String, callBack: WearherCallBack? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequestKey.City.rawValue: location]
        
        netGetRequest(WebApiMethod.Weather.description, para: parameters, modelObject: WeatherMsg.self, successHandler: { result in
            
            Log.info(result.data)
            
            callBack?(result.data!)
            
        }) { msg in
            
            Log.error(msg)
        }
        
    }
    
}


/*
 {
 "data": {
 "condition": "多云",
 "tmp": 34,
 "pm25": 127
 },
 "code": 1000,
 "msg": "",
 "time": 1468048519
 }
 */

struct WeatherMsg: JSONJoy, CommenResponseProtocol {
    
    var commonMsg: CommenResponse
    
    var data: WeatherInfoMsg?
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        data = try WeatherInfoMsg(decoder["data"])
        
    }
    
    
}

struct WeatherInfoMsg: JSONJoy {
    
    /// 天气状况
    var condition: String?
    /// 温度
    var tmp: Int?
    /// pm2.5
    var pm25: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { condition = try decoder["cond"].getString() } catch { condition = "" }
        do { tmp = try decoder["tmp"].getInt() } catch { tmp = 0 }
        do { pm25 = try decoder["pm25"].getInt() } catch { pm25 = 0 }
        
    }
    
    
}

