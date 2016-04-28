//
//  PKWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log
import JSONJoy

class PKWebApi: NetRequestAdapter {
    
    static var shareApi = PKWebApi()
    
    /**
     获取PK列表
     
     - parameter userId:   用户id
     - parameter callBack: 回调
     */
    func getPKRecordList(userId: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetPKRecordList.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     发起PK
     
     - parameter userId:         用户id
     - parameter launchPKList:   发起PK列表
     - parameter callBack:       回调
     
     launchPKList
     - parameter friendId:       好友Id
     - parameter launchTime:     发起时间
     - parameter pkDuration:     PK时长
     */
    func launchPK(userId: String, launchPKList: [[String: AnyObject]], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.LaunchPK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.LaunchPkList.rawValue: launchPKList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     撤销PK
     
     - parameter userId:         用户id
     - parameter undoPKList:     撤销PK列表
     - parameter callBack:       回调
     
     undoPKList
     - parameter pkId:           PK记录的Id
     */
    func undoPK(userId: String, undoPKList: [[String: String]], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.UndoPK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.UndoPkList.rawValue: undoPKList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     删除已完成PK记录
     
     - parameter userId:         用户id
     - parameter delPkList:      删除PK列表
     - parameter callBack:       回调
     
     delPkList
     - parameter pkId:           PK记录的Id
     */
    func deletePK(userId: String, delPkList: [[String: String]], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.DeletePK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.DelPkList.rawValue: delPkList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     接受PK
     
     - parameter userId:         用户id
     - parameter acceptPkList:   接受PK列表
     - parameter callBack:       回调
     
     acceptPkList
     - parameter pkId:           PK记录的Id
     - parameter acceptTime:     接受时间
     */
    func acceptPK(userId: String, acceptPkList: [[String: String]], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.AcceptPK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.AcceptPkList.rawValue: acceptPkList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}

protocol PKWebRequestProtocol {
    //发起PK
    func launchPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: (([PKId]) -> Void)?) -> Void
    //接受PK
    func acceptPKInvitation(dueRealms: [PKDueRealmModel], loginUserId: String, callBack: ((Void) -> Void)?) -> Void
    //撤销PK
    func undoPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: ((Void) -> Void)?) -> Void
    //删除PK
    func deletePKFinish(finishRealms: [PKFinishRealmModel], loginUserId: String, callBack: ((Void) -> Void)?) -> Void
    
}

extension PKWebRequestProtocol {
    
    func launchPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: (([PKId]) -> Void)? = nil) -> Void {
        
        do {
            
            let pk: [[String: AnyObject]] = translateWaitRealmToLaunchRequest(waitRealms)
            
            try PKWebApi.shareApi.launchPK(loginUserId, launchPKList: pk) {(result) in
                
                guard result.isSuccess else {
                    return
                }
                
                let resultMsg = try! LaunchPKResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    return
                }
                
                callBack?(resultMsg.pkIdList!)
                
            }
            
        } catch let error {
            Log.warning("\(error)")
        }

    }
    
    func acceptPKInvitation(dueRealms: [PKDueRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil) -> Void {
        
        do {
            
            let pk: [[String: String]] = translateDueRealmToAcceptRequest(dueRealms)
            
            try PKWebApi.shareApi.acceptPK(loginUserId, acceptPkList: pk) {(result) in
                
                guard result.isSuccess else {
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    return
                }
                
                callBack?()

                
            }
            
        } catch let error {
            Log.warning("\(error)")
        }
        
    }
    
    
    func undoPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil) -> Void {
        
        do {
            
            let pk: [[String: String]] = translateWaitRealmToUndoRequest(waitRealms)
            
            try PKWebApi.shareApi.undoPK(loginUserId, undoPKList: pk) {(result) in
                
                guard result.isSuccess else {
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    return
                }
                
                callBack?()
    
            }
            
        } catch let error {
            Log.warning("\(error)")
        }
        
    }

    
    func deletePKFinish(finishRealms: [PKFinishRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil) -> Void {

        do {
            
            let pk: [[String: String]] = translateFinishRealmToDeleteRequest(finishRealms)
            
            try PKWebApi.shareApi.deletePK(loginUserId, delPkList: pk) {(result) in
                
                guard result.isSuccess else {
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    return
                }
                
                callBack?()
            }
            
        } catch let error {
            Log.warning("\(error)")
        }
        
    }
    
    //把数据库已完成记录转成删除PK接口的请求入参格式
    func translateFinishRealmToDeleteRequest(finishRealms: [PKFinishRealmModel]) -> [[String: String]] {
        var requests: [[String: String]] = [[String: String]]()
        
        for realm in finishRealms {
            
            let request: [String: String] = [UserNetRequsetKey.PKId.rawValue: realm.pkId]
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库待回应记录转成撤销PK接口的请求入参格式
    func translateWaitRealmToUndoRequest(waitRealms: [PKWaitRealmModel]) -> [[String: String]] {
        var requests: [[String: String]] = [[String: String]]()
        
        for realm in waitRealms {
            
            let request: [String: String] = [UserNetRequsetKey.PKId.rawValue: realm.pkId]
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库待回应记录转成发起PK接口的请求入参格式
    func translateWaitRealmToLaunchRequest(waitRealms: [PKWaitRealmModel]) -> [[String: AnyObject]] {
        var requests: [[String: AnyObject]] = [[String: AnyObject]]()
        
        for realm in waitRealms {
            
            let request: [String: AnyObject] = [UserNetRequsetKey.FriendID.rawValue: realm.userId,
                                                UserNetRequsetKey.LaunchTime.rawValue: realm.launchedTime,
                                                UserNetRequsetKey.PKDuration.rawValue: realm.pkDuration,
                                                UserNetRequsetKey.IsAllowWatch.rawValue: realm.isAllowWatch]
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库接受的进行中记录转成接受PK接口的请求入参格式
    func translateDueRealmToAcceptRequest(dueRealms: [PKDueRealmModel]) -> [[String: String]] {
        var requests: [[String: String]] = [[String: String]]()
        
        for realm in dueRealms {
            
            let request: [String: String] = [UserNetRequsetKey.PKId.rawValue: realm.pkId,
                                             UserNetRequsetKey.AcceptTime.rawValue: realm.beginTime]
            
            requests.append(request)
        }
        
        return requests
    }


}






