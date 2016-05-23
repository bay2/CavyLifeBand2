//
//  HomeListWebApi.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import JSONJoy
import EZSwiftExtensions

class HomeListWebApi: NetRequestAdapter {
    
    static var shareApi = HomeListWebApi()
    
    /**
     某一天的数据
     */
    func parseHomeListData(dataString: String, callBack: CompletionHandlernType? = nil) {
        
        let parameters: [String: AnyObject] = ["cmd": "index", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, "dateString": dataString]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
 
    }
    
    /**
     解析全部主页 homeLists 数据
     */
    func parseHomeListsData(callBack: CompletionHandlernType? = nil) {
        
        let parameters: [String: AnyObject] = ["cmd": "index", "userId": CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}

struct HomeListMsgs:JSONJoy {
    
    var msgLists: [HomeListMsg] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        guard let lists = decoder.array else {throw JSONError.WrongType}
        
        for list in lists {
            
            msgLists.append(try HomeListMsg(list))
            
        }

    }
    
}

struct HomeListMsg: JSONJoy {
    
    // 通用消息头
    var commonMsg: CommenMsg
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
        
        commonMsg = try CommenMsg(decoder)
        
        do { stepCount = try decoder["stepCount"].getInt() } catch { stepCount = 0 }
        do { sleepTime = try decoder["sleepTime"].getInt() } catch { sleepTime = 0 }
        
        guard let achieveLists = decoder["achieveList"].array else { return }
        for perList in achieveLists {
            let perAchieve: Int = perList.integer!
            achieveList.append(perAchieve)
        }
        
        guard let pklists = decoder["pkList"].array else {throw JSONError.WrongType}
        var pkListTemp = [PKList]()
        for perList in pklists {
            pkListTemp.append(try PKList(perList))
        }
        pkList = pkListTemp
        
        guard let healthLists = decoder["healthList"].array else { throw JSONError.WrongType}
        var healthListTemp = [HealthList]()
        for perList in healthLists {
            healthListTemp.append(try HealthList(perList))
        }
        healthList = healthListTemp
        
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
    
    init(_ decoder: JSONDecoder) throws {
        
        do { friendId = try decoder["friendId"].getString() } catch { friendId = "" }
        do { friendName = try decoder["friendName"].getString() } catch { friendName = "" }

    }
    
}

