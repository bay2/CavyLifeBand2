//
//  HomeListNetRequest.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import JSONJoy
import EZSwiftExtensions

class HomeListNetRequest: NetRequest {
    
    static var shareApi = HomeListNetRequest()
    
    /**
     解析全部数据
     startTime：注册时间
     endTime：当前日期
     - parameter callBack: 返回T
     */
    func parserAllHomeListData(callBack: RequestHandler? = nil) {
        
        // 默认CavyDefine.webServerAddr 参数 dailies
        // http://pay.tunshu.com/live/api/v1/dailies?start_date=2016-6-5&end_date=2016-6-20
        let head = "dailies?"
        let startDate = "2016-6-5"  // 用户的注册时间：CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken
        let endDate = NSDate().toString(format: "yyyy-M-d")
        let parameters: [String: AnyObject] = ["start_date": startDate,"end_date": endDate]
        
        netGetRequest(CavyDefine.webServerAddr + head, para: parameters, modelObject: HomeListMsg.self, successHandler: { (HomeListMsg) in
            
            }, failureHandler: <#T##FailureHandler?##FailureHandler?##(CommenResponse) -> Void#>)
        
        
    }
    
    /*
    func parseHomeListData(dataString: String, callBack: CompletionHandlernType? = nil) {
        
        /*
         cmd	是	string	index
         userId	是	string	用户名
         date	是	string	日期，格式为“yyyy-MM-dd”
         */
        
        let parameters: [String: AnyObject] = ["cmd": "index", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, "date": dataString]
        
        // netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)

    }
    */
}




struct HomeListMsg: JSONJoy, CommenResponseProtocol {
    
    // 通用消息头
    var commonMsg: CommenResponse
    // 步数
    var stepCount: Int = 0
    // 睡眠时间
    var sleepTime: Int = 0
    // 成就列表
    var achieveList: [Int] = []
    // pk列表
    var pkList: [PKList] = []
    // 健康列表
    var healthList: [HealthList] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        do { stepCount = try decoder["stepCount"].getInt() } catch { stepCount = 0 }
        do { sleepTime = try decoder["sleepTime"].getInt() } catch { sleepTime = 0 }
        
//        guard let achieveLists = decoder["achieveList"].array else { return }
//        for perList in achieveLists {
//            let perAchieve: Int = perList.integer!
//            achieveList.append(perAchieve)
//        }
//        
//        guard let pklists = decoder["pkList"].array else {throw JSONError.WrongType}
//        var pkListTemp = [PKList]()
//        for perList in pklists {
//            pkListTemp.append(try PKList(perList))
//        }
//        pkList = pkListTemp
//        
//        guard let healthLists = decoder["healthList"].array else { throw JSONError.WrongType}
//        var healthListTemp = [HealthList]()
//        for perList in healthLists {
//            healthListTemp.append(try HealthList(perList))
//        }
//        healthList = healthListTemp
//        
    }
    
}

struct PKList: JSONJoy {
    
    var friendName: String?
    var pkId: String?
    var status: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { friendName = try decoder["friendName"].getString() } catch { friendName = "" }
        do { pkId = try decoder["pkId"].getString() } catch { pkId = "" }
        do { status = try decoder["friendName"].getInt() } catch { status = 1 }
        
    }
}

struct HealthList: JSONJoy {
    
    var friendId: String?
    var friendName: String?
    var iconUrl: String?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { friendId = try decoder["friendId"].getString() } catch { friendId = "" }
        do { friendName = try decoder["friendName"].getString() } catch { friendName = "" }
        do { iconUrl = try decoder["iconUrl"].getString() } catch { iconUrl = "" }
        
    }
    
}
