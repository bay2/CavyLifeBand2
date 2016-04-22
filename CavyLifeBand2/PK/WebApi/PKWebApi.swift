//
//  PKWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log

class PKWebApi: NetRequestAdapter {
    
    static var shareApi = UserNetRequestData()
    
    /**
     获取PK列表
     
     - parameter userId:   用户id
     - parameter callBack: 回调
     */
    func getPKRecordList(userId: String, callBack: CompletionHandlernType? = nil) {
        
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
    func launchPK(userId: String, launchPKList: [[String: String]], callBack: CompletionHandlernType? = nil) {
        
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
    func undoPK(userId: String, undoPKList: [[String: String]], callBack: CompletionHandlernType? = nil) {
        
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
    func deletePK(userId: String, delPkList: [[String: String]], callBack: CompletionHandlernType? = nil) {
        
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
    func acceptPK(userId: String, acceptPkList: [[String: String]], callBack: CompletionHandlernType? = nil) {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.AcceptPK.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.AcceptPkList.rawValue: acceptPkList]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
}
