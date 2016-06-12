//
//  PKWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import JSONJoy
import RealmSwift

class PKWebApi: NetRequestAdapter {
    
    static var shareApi = PKWebApi()
    
    /**
     获取PK列表
     
     - parameter userId:   用户Id
     - parameter type:     查询类型：0：查询用户自己的pk列表，1：查询好友的pk列表
     - parameter friendId: 好友ID，当type=1时必选
     - parameter callBack: 回调
     
     - throws:
     */
    func getPKRecordList(userId: String, type: Int = 0, friendId: String = "", callBack: CompletionHandlernType? = nil) throws {
        
        if type == 1 && friendId.characters.count == 0 {
            
            callBack?(.Failure(.FriendIdNil))
            Log.error("friendId is nil")
            return
             
        }
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetPKRecordList.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.FriendReqType.rawValue: type,
                                               UserNetRequsetKey.FriendID.rawValue: type]
        
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
    func undoPK(userId: String, undoPKList: [String], callBack: CompletionHandlernType? = nil) throws {
        
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
    func deletePK(userId: String, delPkList: [String], callBack: CompletionHandlernType? = nil) throws {
        
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
    func acceptPK(userId: String, acceptPkList: [String], callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.AcceptPK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.AcceptPkList.rawValue: acceptPkList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     获取PK详细资料
     
     - parameter userId:   用户ID
     - parameter callBack:
     
     - throws:
     */
    func getPKInfo(userId: String, pkId: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetPKInfo.rawValue,
                                               UserNetRequsetKey.PKId.rawValue: pkId,
                                               UserNetRequsetKey.UserID.rawValue: userId]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}

typealias FailureHandle = (String) -> Void

protocol PKWebRequestProtocol {
    //发起PK
    func launchPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: (([String]) -> Void)?, failure: FailureHandle?) -> Void
    //接受PK
    func acceptPKInvitation(dueRealms: [PKDueRealmModel], loginUserId: String, callBack: ((Void) -> Void)?, failure: FailureHandle?) -> Void
    //撤销PK
    func undoPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: ((Void) -> Void)?, failure: FailureHandle?) -> Void
    //删除PK
    func deletePKFinish(finishRealms: [PKFinishRealmModel], loginUserId: String, callBack: ((Void) -> Void)?, failure: FailureHandle?) -> Void
    //获取PK详细资料
    func getPKInfo(pkId: String, callBack: ((PKInfoResponse) -> Void)?, failure: FailureHandle?) -> Void
    
}

extension PKWebRequestProtocol {
    
    func launchPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: (([String]) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [[String: AnyObject]] = translateWaitRealmToLaunchRequest(waitRealms)
            
            try PKWebApi.shareApi.launchPK(loginUserId, launchPKList: pk) { (result) in
                
                guard result.isSuccess else {
                    failure?(result.error?.description ?? "")
                    return
                }
                
                let resultMsg = try! LaunchPKResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    failure?(WebApiCode(apiCode: resultMsg.commonMsg.code).description)
                    return
                }
                
                guard resultMsg.pkId.count > 0 else {
                    failure?("没有返回pkID")
                    return
                }
                
                callBack?(resultMsg.pkId)
                
            }
            
        } catch let error {
            let err = error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError
            failure?(err.description ?? "")
        }

    }
    
    func acceptPKInvitation(dueRealms: [PKDueRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [String] = translateDueRealmToAcceptRequest(dueRealms)
            
            try PKWebApi.shareApi.acceptPK(loginUserId, acceptPkList: pk) { (result) in
                
                guard result.isSuccess else {
                    failure?(result.error?.description ?? "")
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(WebApiCode(apiCode: resultMsg.code).description)
                    return
                }
                
                callBack?()

                
            }
            
        } catch let error {
            let err = error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError
            failure?(err.description ?? "")
        }
        
    }
    
    
    func undoPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [String] = translateWaitRealmToUndoRequest(waitRealms)
            
            try PKWebApi.shareApi.undoPK(loginUserId, undoPKList: pk) { (result) in
                
                guard result.isSuccess else {
                    failure?(result.error?.description ?? "")
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(WebApiCode(apiCode: resultMsg.code).description)
                    return
                }
                
                callBack?()
    
            }
            
        } catch let error {
            let err = error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError
            failure?(err.description ?? "")
        }
        
    }

    
    func deletePKFinish(finishRealms: [PKFinishRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {

        do {
            
            let pk: [String] = translateFinishRealmToDeleteRequest(finishRealms)
            
            try PKWebApi.shareApi.deletePK(loginUserId, delPkList: pk) { (result) in
                
                guard result.isSuccess else {
                    failure?(result.error?.description ?? "")
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(WebApiCode(apiCode: resultMsg.code).description)
                    return
                }
                
                callBack?()
            }
            
        } catch let error {
            let err = error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError
            failure?(err.description ?? "")
        }
        
    }
    
    func getPKInfo(pkId: String, callBack: ((PKInfoResponse) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        do {

            try PKWebApi.shareApi.getPKInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, pkId: pkId) { (result) in
                
                guard result.isSuccess else {
                    failure?(result.error?.description ?? "")
                    return
                }
                
                let resultMsg = try! PKInfoResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    failure?(WebApiCode(apiCode: resultMsg.commonMsg.code).description)
                    return
                }
                
                callBack?(resultMsg)
            }
            
        } catch let error {
            let err = error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError
            failure?(err.description ?? "")
        }
    }
    
    //把数据库已完成记录转成删除PK接口的请求入参格式
    func translateFinishRealmToDeleteRequest(finishRealms: [PKFinishRealmModel]) -> [String] {
        var requests: [String] = [String]()
        
        for realm in finishRealms {
            
            let request: String = realm.pkId
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库待回应记录转成撤销PK接口的请求入参格式
    func translateWaitRealmToUndoRequest(waitRealms: [PKWaitRealmModel]) -> [String] {
        var requests: [String] = [String]()
        
        for realm in waitRealms {
            
            let request: String = realm.pkId
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库待回应记录转成发起PK接口的请求入参格式
    func translateWaitRealmToLaunchRequest(waitRealms: [PKWaitRealmModel]) -> [[String: AnyObject]] {
        var requests: [[String: AnyObject]] = [[String: AnyObject]]()
        
        for realm in waitRealms {
            
            let request: [String: AnyObject] = [UserNetRequsetKey.FriendID.rawValue: realm.userId,
                                                UserNetRequsetKey.PKDuration.rawValue: realm.pkDuration,
                                                UserNetRequsetKey.IsAllowWatch.rawValue: realm.isAllowWatch]
            
            requests.append(request)
        }
        
        return requests
    }
    
    //把数据库接受的进行中记录转成接受PK接口的请求入参格式
    func translateDueRealmToAcceptRequest(dueRealms: [PKDueRealmModel]) -> [String] {
        var requests: [String] = [String]()
        
        for realm in dueRealms {
            
            let request: String = realm.pkId
                                            
            requests.append(request)
        }
        
        return requests
    }

}

protocol PKRecordsUpdateFormWeb: PKRecordsRealmModelOperateDelegate {
    
    func loadDataFromWeb(loginUserId: String)
    var realm: Realm { get }
    
}

extension PKRecordsUpdateFormWeb  {
    
    func loadDataFromWeb(loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {

        do {
            
            try PKWebApi.shareApi.getPKRecordList(loginUserId) { (result) in
                
                guard result.isSuccess else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: result.error ?? UserRequestErrorType.UnknownError)
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value ?? ""))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: resultMsg.commonMsg.code)
                    return
                }
                
                let waitRecordsRealm: [PKWaitRealmModel] = resultMsg.waitList.map {
                    PKWaitRealmModel(model: $0)
                }
                
                let dueRecordsRealm: [PKDueRealmModel] = resultMsg.dueList.map {
                    PKDueRealmModel(model: $0)
                }
                
                let finishRecordsRealm: [PKFinishRealmModel] = resultMsg.finishList.map {
                    PKFinishRealmModel(model: $0)
                }
                
                self.deletePKRecordsRealm(PKWaitRealmModel.self)
                self.deletePKRecordsRealm(PKDueRealmModel.self)
                self.deletePKRecordsRealm(PKFinishRealmModel.self)
                
                self.savePKRecordsRealm(waitRecordsRealm)
                self.savePKRecordsRealm(dueRecordsRealm)
                self.savePKRecordsRealm(finishRecordsRealm)
                
            }
            
        } catch let error {
            
            Log.warning("弹框提示失败\(error)")
            
        }
        
    }
    
    
}

extension PKWaitRealmModel {
    
    convenience init(loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, model: PKWaitRecord) {
        
        self.init()
        
        self.pkId         = model.pkId
        self.loginUserId  = loginUserId
        self.userId       = model.userId
        self.avatarUrl    = model.avatarUrl
        self.nickname     = model.nickname
        self.type         = model.type
        self.launchedTime = model.launchedTime
        self.pkDuration   = model.pkDuration
        
    }
    
}

extension PKDueRealmModel {
    
    convenience init(loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, model: PKDueRecord) {
        
        self.init()
        
        self.pkId        = model.pkId
        self.loginUserId = loginUserId
        self.userId      = model.userId
        self.avatarUrl   = model.avatarUrl
        self.nickname    = model.nickname
        self.beginTime   = model.beginTime
        self.pkDuration  = model.pkDuration
        
    }
    
}

extension PKFinishRealmModel {
    
    convenience init(loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, model: PKFinishRecord) {
        
        self.init()
        
        self.pkId         = model.pkId
        self.loginUserId  = loginUserId
        self.userId       = model.userId
        self.avatarUrl    = model.avatarUrl
        self.nickname     = model.nickname
        self.completeTime = model.completeTime
        self.pkDuration   = model.pkDuration
        self.isWin        = model.isWin
        
    }
    
}






