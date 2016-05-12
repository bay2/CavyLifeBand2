//
//  PKJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import JSONJoy

struct LaunchPKResponse: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg
    
    //等待列表
    var pkId: [String] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        guard let pkIdArray = decoder["pkId"].array else {
            return
        }
        
        pkId = pkIdArray.map{ pkID -> String in
            do { return try pkID.getString() } catch { return "" }
        }
        
    }
}

struct PKRecordList: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg
    
    //等待列表
    var waitList: [PKWaitRecord]
    
    //进行中列表
    var dueList: [PKDueRecord]
    
    //完成列表
    var finishList: [PKFinishRecord]
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg  = try CommenMsg(decoder)

        waitList   = [PKWaitRecord]()

        dueList    = [PKDueRecord]()

        finishList = [PKFinishRecord]()
        
        
        if let waitArray = decoder["waitList"].array {
            
            for waitRecord in waitArray {
                
                waitList.append(try PKWaitRecord(waitRecord))
                
            }
        }
        
        if let dueArray = decoder["dueList"].array {
            
            for dueRecord in dueArray {
                
                dueList.append(try PKDueRecord(dueRecord))
                
            }
        }
        
        if let finishArray = decoder["finishList"].array {
            
            for finishRecord in finishArray {
                
                finishList.append(try PKFinishRecord(finishRecord))
                
            }
        }
        
        
    }
}

struct PKWaitRecord: JSONJoy {
    //PK记录Id
    var pkId: String
    
    //等待类型 0等待对方接受；1对方等待我接受
    var type: Int
    
    //用户Id
    var userId: String
    
    //头像
    var avatarUrl: String
    
    //昵称
    var nickname: String
    
    //发起挑战时间，时间格式：yyyy-MM-dd HH:mm:ss
    var launchedTime: String
    
    //PK时长
    var pkDuration: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { pkId = try decoder["pkId"].getString() } catch { pkId = "" }
        do { type = try decoder["type"].getInt() } catch { type = 0 }
        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { nickname = try decoder["nickname"].getString() } catch { nickname = "" }
        do { launchedTime = try decoder["launchedTime"].getString() } catch { launchedTime = "" }
        do { pkDuration   = try decoder["pkDuration"].getString() } catch { pkDuration = "" }
        
    }
    
}

struct PKDueRecord: JSONJoy {
    //PK记录Id
    var pkId: String
    
    //用户Id
    var userId: String
    
    //头像
    var avatarUrl: String
    
    //昵称
    var nickname: String
    
    //开始PK时间，时间格式：yyyy-MM-dd HH:mm:ss
    var beginTime: String

    //PK时长
    var pkDuration: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { pkId       = try decoder["pkId"].getString() } catch { pkId = "" }
        do { userId     = try decoder["userId"].getString() } catch { userId = "" }
        do { avatarUrl  = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { nickname   = try decoder["nickname"].getString() } catch { nickname = "" }
        do { beginTime  = try decoder["beginTime"].getString() } catch { beginTime = "" }
        do { pkDuration = try decoder["pkDuration"].getString() } catch { pkDuration = "" }
        
    }
    
}

struct PKFinishRecord: JSONJoy {
    //PK记录Id
    var pkId: String
    
    //用户Id
    var userId: String
    
    //头像
    var avatarUrl: String
    
    //昵称
    var nickname: String
    
    //我是否胜利
    var isWin: Bool
    
    //PK完成时间，时间格式：yyyy-MM-dd HH:mm:ss
    var completeTime: String
    
    //PK时长
    var pkDuration: String
    
    init(_ decoder: JSONDecoder) throws {
        
        isWin = decoder["isWin"].bool
        
        do { pkId         = try decoder["pkId"].getString() } catch { pkId = "" }
        do { userId       = try decoder["userId"].getString() } catch { userId = "" }
        do { avatarUrl    = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { nickname     = try decoder["nickname"].getString() } catch { nickname = "" }
        do { completeTime = try decoder["completeTime"].getString() } catch { completeTime = "" }
        do { pkDuration   = try decoder["pkDuration"].getString() } catch { pkDuration = "" }
        
    }
    
}


struct PKInfoResponse: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg
    
    //我的计步数
    var userStepCount: Int
    
    //对方的计步数
    var friendStepCount: Int
    
    //是否好友可见
    var isAllowWatch: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        do { userStepCount   = try decoder["userStepCount"].getInt() } catch { userStepCount = 0 }
        do { friendStepCount = try decoder["friendStepCount"].getInt() } catch { friendStepCount = 0 }
        do { isAllowWatch    = try decoder["isAllowWatch"].getInt() } catch { isAllowWatch = PKAllowWatchState.OtherNoWatch.rawValue }
        
    }
}