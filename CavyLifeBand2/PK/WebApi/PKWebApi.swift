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
import RealmSwift

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
    func getPKInfo(userId: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetPKInfo.rawValue,
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
    func getPKInfo(loginUserId: String, callBack: ((PKInfoResponse) -> Void)?, failure: FailureHandle?) -> Void
    
}

extension PKWebRequestProtocol {
    
    func launchPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: (([String]) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [[String: AnyObject]] = translateWaitRealmToLaunchRequest(waitRealms)
            
            try PKWebApi.shareApi.launchPK(loginUserId, launchPKList: pk) {(result) in
                
                guard result.isSuccess else {
                    failure?(self.getErroMsgFromUserCode(result.error))
                    return
                }
                
                let resultMsg = try! LaunchPKResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    failure?(self.getErroMsgFromWebErrorCode(resultMsg.commonMsg.code ?? ""))
                    return
                }
                
                guard resultMsg.pkId.count > 0 else {
                    failure?("没有返回pkID")
                    return
                }
                
                callBack?(resultMsg.pkId)
                
            }
            
        } catch let error {
            failure?(self.getErroMsgFromUserCode(error as? UserRequestErrorType))
        }

    }
    
    func acceptPKInvitation(dueRealms: [PKDueRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [String] = translateDueRealmToAcceptRequest(dueRealms)
            
            try PKWebApi.shareApi.acceptPK(loginUserId, acceptPkList: pk) {(result) in
                
                guard result.isSuccess else {
                    failure?(self.getErroMsgFromUserCode(result.error))
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(self.getErroMsgFromWebErrorCode(resultMsg.code ?? ""))
                    return
                }
                
                callBack?()

                
            }
            
        } catch let error {
            failure?(self.getErroMsgFromUserCode(error as? UserRequestErrorType))
        }
        
    }
    
    
    func undoPK(waitRealms: [PKWaitRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        
        do {
            
            let pk: [String] = translateWaitRealmToUndoRequest(waitRealms)
            
            try PKWebApi.shareApi.undoPK(loginUserId, undoPKList: pk) {(result) in
                
                guard result.isSuccess else {
                    failure?(self.getErroMsgFromUserCode(result.error))
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(self.getErroMsgFromWebErrorCode(resultMsg.code ?? ""))
                    return
                }
                
                callBack?()
    
            }
            
        } catch let error {
            failure?(self.getErroMsgFromUserCode(error as? UserRequestErrorType))
        }
        
    }

    
    func deletePKFinish(finishRealms: [PKFinishRealmModel], loginUserId: String, callBack: ((Void) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {

        do {
            
            let pk: [String] = translateFinishRealmToDeleteRequest(finishRealms)
            
            try PKWebApi.shareApi.deletePK(loginUserId, delPkList: pk) {(result) in
                
                guard result.isSuccess else {
                    failure?(self.getErroMsgFromUserCode(result.error))
                    return
                }
                
                let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
                
                guard resultMsg.code == WebApiCode.Success.rawValue else {
                    failure?(self.getErroMsgFromWebErrorCode(resultMsg.code ?? ""))
                    return
                }
                
                callBack?()
            }
            
        } catch let error {
            failure?(self.getErroMsgFromUserCode(error as? UserRequestErrorType))
        }
        
    }
    
    func getPKInfo(loginUserId: String, callBack: ((PKInfoResponse) -> Void)? = nil, failure: FailureHandle? = nil) -> Void {
        do {

            try PKWebApi.shareApi.getPKInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {(result) in
                
                guard result.isSuccess else {
                    failure?(self.getErroMsgFromUserCode(result.error))
                    return
                }
                
                let resultMsg = try! PKInfoResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    failure?(self.getErroMsgFromWebErrorCode(resultMsg.commonMsg.code ?? ""))
                    return
                }
                
                callBack?(resultMsg)
            }
            
        } catch let error {
            failure?(self.getErroMsgFromUserCode(error as? UserRequestErrorType))
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

    //user error code to string
    func getErroMsgFromUserCode(userErrorCode: UserRequestErrorType?) -> String {
        
        let errorMessage = [UserRequestErrorType.EmailErr: L10n.UserModuleErrorCodeEmailError.string,
                            UserRequestErrorType.EmailNil: L10n.UserModuleErrorCodeEmailNil.string,
                            UserRequestErrorType.NetAPIErr: L10n.UserModuleErrorCodeNetAPIError.string,
                            UserRequestErrorType.NetErr: L10n.UserModuleErrorCodeNetError.string,
                            UserRequestErrorType.PassWdErr: L10n.UserModuleErrorCodePasswdError.string,
                            UserRequestErrorType.PassWdNil: L10n.UserModuleErrorCodePasswdNil.string,
                            UserRequestErrorType.PhoneNil: L10n.UserModuleErrorCodePhoneNil.string,
                            UserRequestErrorType.PhoneErr: L10n.UserModuleErrorCodePhoneError.string,
                            UserRequestErrorType.SecurityCodeErr: L10n.UserModuleErrorCodeSecurityError.string,
                            UserRequestErrorType.SecurityCodeNil: L10n.UserModuleErrorCodeSecurityNil.string,
                            UserRequestErrorType.UserNameErr: L10n.UserModuleErrorCodeUserNameError.string,
                            UserRequestErrorType.UserNameNil: L10n.UserModuleErrorCodeUserNameNil.string,
                            UserRequestErrorType.UnknownError: L10n.UserModuleErrorCodeUnknownError.string]
        
        let userError = userErrorCode ?? UserRequestErrorType.UnknownError
        
        return errorMessage[userError]!
    }
    
    //web error code to string
    func getErroMsgFromWebErrorCode(webErrorCode: String) -> String {
    
        let errorMessage = [WebApiCode.ParaError.rawValue: L10n.WebErrorCode1000.string,
                            WebApiCode.UserPasswdError.rawValue: L10n.WebErrorCode1001.string,
                            WebApiCode.PhoneNumError.rawValue: L10n.WebErrorCode1002.string,
                            WebApiCode.SecurityCodeError.rawValue: L10n.WebErrorCode1003.string,
                            WebApiCode.MobifyUserError.rawValue: L10n.WebErrorCode1004.string,
                            WebApiCode.UserExisted.rawValue: L10n.WebErrorCode1005.string,
                            WebApiCode.UserNotExisted.rawValue: L10n.WebErrorCode1006.string,
                            WebApiCode.SendSecutityCodeError.rawValue: L10n.WebErrorCode1007.string]
        
        if let message = errorMessage[webErrorCode] {
            
            return message
            
        } else {
        
            return L10n.UserModuleErrorCodeNetAPIError.string
        
        }
        
    }

}

protocol PKRecordsUpdateFormWeb: PKRecordsRealmModelOperateDelegate {
    
    func loadDataFromWeb(loginUserId: String)
    var realm: Realm { get }
    
}

extension PKRecordsUpdateFormWeb  {
    
    func loadDataFromWeb(loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
        Log.info(realm.path)
        do {
            
            try PKWebApi.shareApi.getPKRecordList(loginUserId) {(result) in
                
                guard result.isSuccess else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: result.error ?? UserRequestErrorType.UnknownError)
                    return
                }
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value ?? ""))
                
                guard resultMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(message: resultMsg.commonMsg.code ?? "")
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






